import os
import yaml
import subprocess
from pathlib import Path

# ==========================================
# 설정: 사용할 YAML 파일 이름
# ==========================================
YAML_FILE = "links.yaml"

def main():
    print("🚀 연구 환경 설정을 시작합니다...")

    # 1. YAML 설정 파일 읽기
    if not Path(YAML_FILE).exists():
        print(f"❌ [오류] 설정 파일 '{YAML_FILE}'이 없습니다. 같은 폴더에 만들어주세요.")
        return

    with open(YAML_FILE, 'r', encoding='utf-8') as f:
        links = yaml.safe_load(f)

    # 2. 링크 생성 루프
    print("-" * 40)
    for link_name, target_abs_path in links.items():
        # 프로젝트 내에 생성될 가상 폴더 (예: ./data)[cite: 2]
        link_path = Path(os.getcwd()) / link_name
        
        # YAML에 적힌 구글 드라이브 절대 경로[cite: 1, 2]
        target_path = Path(target_abs_path)
        
        # 구글 드라이브에 해당 폴더가 없으면 자동 생성[cite: 2]
        if not target_path.exists():
            print(f"📂 [알림] 원본 폴더가 없어서 새로 만듭니다: {target_abs_path}")
            target_path.mkdir(parents=True, exist_ok=True)

        # 이미 존재하는지 확인[cite: 2]
        if link_path.exists():
            print(f"⏭️ [SKIP] '{link_name}' 폴더는 이미 연결되어 있거나 존재합니다.")
            continue

        # 윈도우 mklink /J (Directory Junction) 명령어 실행[cite: 2]
        cmd = f'mklink /J "{link_path}" "{target_path}"'
        
        try:
            subprocess.check_call(cmd, shell=True)
            print(f"🔗 [성공] {link_name} <==> {target_abs_path}")
        except subprocess.CalledProcessError:
            print(f"❌ [실패] '{link_name}' 연결 실패. (명령 프롬프트를 관리자 권한으로 실행했는지 확인하세요.)")

    print("-" * 40)
    print("✨ 설정이 완료되었습니다.")

if __name__ == "__main__":
    main()