#!/bin/bash
# korean-patent-diagram 설치 스크립트
# 사용법: bash install.sh

set -e

SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "소스 경로: $REPO_DIR"
echo "설치 경로: $SKILLS_DIR"
echo ""

# 1. matplotlib 설치
echo "[1/3] matplotlib 설치 확인..."
if python3 -c "import matplotlib" 2>/dev/null; then
  echo "      matplotlib 이미 설치됨"
else
  echo "      matplotlib 설치 중..."
  pip3 install --quiet matplotlib || {
    echo "  주의: pip 설치 실패. 수동 실행 필요:"
    echo "        pip3 install matplotlib"
  }
fi

# 2. skill.md 경로 치환
echo "[2/3] 경로 설정..."
SKILL_MD="$REPO_DIR/skill.md"
if [ -f "$SKILL_MD" ]; then
  if grep -q "{SKILL_DIR}" "$SKILL_MD"; then
    sed -i '' "s|{SKILL_DIR}|$REPO_DIR|g" "$SKILL_MD"
  fi
fi

# 3. skills 디렉토리에 심링크 생성
echo "[3/3] 스킬 등록..."
if [ ! -d "$SKILLS_DIR" ]; then
  mkdir -p "$SKILLS_DIR"
  echo "      $SKILLS_DIR 디렉토리 생성됨"
fi

TARGET="$SKILLS_DIR/korean-patent-diagram"
if [ -L "$TARGET" ]; then
  rm "$TARGET"
elif [ -d "$TARGET" ]; then
  echo "경고: $TARGET 이 이미 존재합니다. 건너뜁니다."
  exit 1
fi

ln -s "$REPO_DIR" "$TARGET"
echo "      심링크 생성: $TARGET"

echo ""
echo "─────────────────────────────────────────"
echo "  설치 완료"
echo "─────────────────────────────────────────"
echo ""
echo "Claude Code를 재시작하면 아래 명령어 사용 가능:"
echo ""
echo "  /korean-patent-diagram      특허 도면 자동 생성"
echo ""
echo "지원 도면 유형:"
echo "  flowchart  플로우차트  (SW·방법·알고리즘 특허)"
echo "  block      블록도      (전자·통신·시스템 특허)"
echo "  state      상태도      (제어·프로토콜·UI 특허)"
echo "  graph      그래프      (성능 비교·실험 결과)"
echo "  process    공정도      (제조·화학·생산 공정)"
echo ""
echo "커뮤니티: discord.gg/3gYGuMcqgb (SpeciAI)"
echo ""
