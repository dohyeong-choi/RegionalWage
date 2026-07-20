library(data.table)
library(haven)
library(logitr)

# ============================================================
# 1. Settings
# ============================================================
data_path <- paste0(
  "D:/이경재/학술대회 및 논문공모전/",
  "2027 Journal of Regional Science/분석/goms/pooled.dta"
)

out_dir <- paste0(
  "D:/이경재/학술대회 및 논문공모전/",
  "2027 Journal of Regional Science/분석/logitr_results"
)

if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE)
}

sample_frac     <- 1
seed            <- 20260717
num_draws       <- 100
num_multistarts <- 5
num_threads     <- max(1, parallel::detectCores() - 1)

# Random coefficients are normally distributed.
# Their standard deviations are common across 2015 and 2020.
# y_wages, y_high, y_college identify changes in mean coefficients.
rand_pars <- c(
  wages   = "n",
  high    = "n",
  college = "n"
)

# ============================================================
# 2. Load pooled data
# ============================================================
df <- as.data.table(read_dta(data_path))

cat(
  "Rows:", format(nrow(df), big.mark = ","),
  " Cols:", ncol(df), "\n"
)

# ============================================================
# 3. Variable list
# ============================================================

# 2015 baseline coefficients and 2020 changes
base_vars <- c(
  "wages",
  "y_wages",
  "res",
  "y_res",
  "high",
  "y_high",
  "college",
  "y_college"
)

# Alternative-specific constants, year interactions,
# and individual-characteristic interactions
alt_vars <- unlist(
  lapply(2:16, function(k) {
    c(
      paste0("a", k),
      paste0("a", k, "_y2020"),
      paste0("a", k, "_age"),
      paste0("a", k, "_gender"),
      paste0("a", k, "_major"),
      paste0("a", k, "_edu"),
      paste0("a", k, "_gpa")
    )
  }),
  use.names = FALSE
)

pars <- c(base_vars, alt_vars)

required_cols <- c(
  "subject_pool",
  "y2020",
  "i",
  "decision",
  pars
)

missing_cols <- setdiff(required_cols, names(df))

if (length(missing_cols) > 0) {
  stop(
    "Missing columns:\n",
    paste(missing_cols, collapse = "\n")
  )
}

cat("Regressors:", length(pars), "\n")
cat("Random coefficients:\n")
print(rand_pars)

# ============================================================
# 4. Convert types
# ============================================================
df[, subject_pool := as.integer(subject_pool)]
df[, y2020       := as.integer(y2020)]
df[, i           := as.integer(i)]
df[, decision    := as.integer(decision)]

for (v in pars) {
  set(
    df,
    j = v,
    value = as.numeric(df[[v]])
  )
}

if (!all(unique(df$y2020) %in% c(0L, 1L))) {
  stop("y2020 must contain only 0 and 1.")
}

# One survey year per pooled subject ID
year_check <- df[
  ,
  .(n_year = uniqueN(y2020)),
  by = subject_pool
]

if (any(year_check$n_year != 1L)) {
  stop("Some subject_pool IDs appear in more than one year.")
}

# ============================================================
# 5. Check pooled interaction variables
# ============================================================
tolerance <- 1e-8

interaction_checks <- list(
  y_wages   = df$y2020 * df$wages,
  y_res     = df$y2020 * df$res,
  y_high    = df$y2020 * df$high,
  y_college = df$y2020 * df$college
)

for (v in names(interaction_checks)) {
  
  observed <- df[[v]]
  expected <- interaction_checks[[v]]
  
  difference <- abs(observed - expected)
  difference <- difference[!is.na(difference)]
  
  if (length(difference) > 0 &&
      max(difference) > tolerance) {
    stop(
      v,
      " is inconsistent with y2020 × its baseline variable."
    )
  }
}

for (k in 2:16) {
  
  asc_name  <- paste0("a", k)
  year_name <- paste0("a", k, "_y2020")
  
  difference <- abs(
    df[[year_name]] -
      df$y2020 * df[[asc_name]]
  )
  
  difference <- difference[!is.na(difference)]
  
  if (length(difference) > 0 &&
      max(difference) > tolerance) {
    stop(
      year_name,
      " is inconsistent with y2020 × ",
      asc_name,
      "."
    )
  }
}

cat("Pooled interaction variables are consistent.\n")

# ============================================================
# 6. Remove GPA-missing subjects
# ============================================================
gpa_cols <- paste0("a", 2:16, "_gpa")

bad_gpa_ids <- unique(
  df[
    rowSums(is.na(df[, ..gpa_cols])) > 0,
    subject_pool
  ]
)

cat(
  "GPA-missing subjects removed:",
  length(bad_gpa_ids),
  " Rows:",
  length(bad_gpa_ids) * 16,
  "\n"
)

df <- df[
  !(subject_pool %in% bad_gpa_ids)
]

cat(
  "Remaining subjects:",
  format(uniqueN(df$subject_pool), big.mark = ","),
  " Rows:",
  format(nrow(df), big.mark = ","),
  "\n"
)

# ============================================================
# 7. Choice-set diagnostics
# ============================================================

# Each person must have 16 alternatives
n_alt <- df[
  ,
  .(n_alt = uniqueN(i)),
  by = subject_pool
]

if (any(n_alt$n_alt != 16L)) {
  stop("Not all subjects have 16 alternatives.")
}

# Each person must choose exactly one alternative
n_choice <- df[
  ,
  .(n_choice = sum(decision)),
  by = subject_pool
]

if (any(n_choice$n_choice != 1L)) {
  stop("Not exactly one chosen alternative per subject.")
}

# No duplicated alternative within a choice set
duplicate_alt <- df[
  ,
  .N,
  by = .(subject_pool, i)
][
  N != 1L
]

if (nrow(duplicate_alt) > 0) {
  stop("Duplicated alternatives exist within some choice sets.")
}

# Missing-value check
na_counts <- sapply(
  df[, ..required_cols],
  function(x) sum(is.na(x))
)

na_counts <- na_counts[na_counts > 0]

if (length(na_counts) > 0) {
  print(na_counts)
  stop("NAs remain in required model variables.")
}

cat("Choice sets and missing values are valid.\n")

# Subjects by year
year_counts <- unique(
  df[, .(subject_pool, y2020)]
)[
  ,
  .(subjects = .N),
  by = y2020
][
  order(y2020)
]

cat("Subjects by year:\n")
print(year_counts)

# Chosen alternatives by year
choice_counts <- df[
  decision == 1L,
  .N,
  by = .(y2020, chosen_alt = i)
][
  order(y2020, chosen_alt)
]

cat("Chosen alternatives by year:\n")
print(choice_counts)

# ============================================================
# 8. Full sample or stratified test sample
# ============================================================
if (sample_frac >= 1) {
  
  dfs <- copy(df)
  
} else {
  
  set.seed(seed)
  
  chosen <- df[
    decision == 1L,
    .(
      subject_pool,
      y2020,
      chosen_alt = i
    )
  ]
  
  if (anyDuplicated(chosen$subject_pool) > 0) {
    stop("Duplicated chosen rows.")
  }
  
  # Stratification by year and chosen alternative
  sampled_chosen <- chosen[
    ,
    .SD[
      sample(
        .N,
        size = max(
          1L,
          round(.N * sample_frac)
        ),
        replace = FALSE
      )
    ],
    by = .(y2020, chosen_alt)
  ]
  
  sample_ids <- sampled_chosen$subject_pool
  
  dfs <- df[
    subject_pool %in% sample_ids
  ]
}

cat(
  "Estimation subjects:",
  format(uniqueN(dfs$subject_pool), big.mark = ","),
  " Rows:",
  format(nrow(dfs), big.mark = ","),
  "\n"
)

# Final checks after sampling
stopifnot(
  all(
    dfs[
      ,
      .(n = uniqueN(i)),
      by = subject_pool
    ]$n == 16L
  )
)

stopifnot(
  all(
    dfs[
      ,
      .(n = sum(decision)),
      by = subject_pool
    ]$n == 1L
  )
)

setorder(
  dfs,
  subject_pool,
  i
)

# ============================================================
# 9. Mixed logit estimation
# ============================================================
set.seed(seed)

t0 <- Sys.time()

mxl_model <- logitr(
  data           = dfs,
  outcome        = "decision",
  obsID          = "subject_pool",
  pars           = pars,
  randPars       = rand_pars,
  numDraws       = num_draws,
  numMultiStarts = num_multistarts,
  numThreads     = num_threads,
  robust         = TRUE,
  vcov           = TRUE,
  predict        = FALSE
)

elapsed <- as.numeric(
  difftime(
    Sys.time(),
    t0,
    units = "mins"
  )
)

cat(
  "Elapsed:",
  round(elapsed, 2),
  "minutes\n"
)

# ============================================================
# 10. Results
# ============================================================
model_summary <- summary(mxl_model)
print(model_summary)

rand_suffix <- paste(
  names(rand_pars),
  collapse = "_"
)

file_tag <- paste0(
  "pooled_",
  rand_suffix,
  "_draws", num_draws,
  "_starts", num_multistarts
)

# Text output
writeLines(
  capture.output({
    
    cat("Pooled GOMS mixed logit\n")
    cat("Sample: ages 20–34, selected before pooling\n")
    cat("Baseline year: 2015\n")
    cat("Comparison year: 2020\n")
    cat("Draws:", num_draws, "\n")
    cat("Multistarts:", num_multistarts, "\n")
    cat("Threads:", num_threads, "\n")
    
    cat("\nRandom coefficients:\n")
    print(rand_pars)
    
    cat("\nSubjects by year:\n")
    print(year_counts)
    
    cat("\nModel summary:\n")
    print(model_summary)
    
  }),
  file.path(
    out_dir,
    paste0(file_tag, ".txt")
  ),
  useBytes = TRUE
)

# Coefficient table
coef_table <- as.data.table(
  model_summary$coefTable,
  keep.rownames = "term"
)

fwrite(
  coef_table,
  file.path(
    out_dir,
    paste0(file_tag, "_coef.csv")
  ),
  bom = TRUE
)

# Complete model object
saveRDS(
  mxl_model,
  file.path(
    out_dir,
    paste0(file_tag, "_model.rds")
  )
)

# Sample counts
fwrite(
  year_counts,
  file.path(
    out_dir,
    paste0(file_tag, "_sample_counts.csv")
  ),
  bom = TRUE
)

# Chosen alternative counts
fwrite(
  choice_counts,
  file.path(
    out_dir,
    paste0(file_tag, "_choice_counts.csv")
  ),
  bom = TRUE
)

cat("Done.\n")