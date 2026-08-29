# korean-patent-diagram

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Claude Code](https://img.shields.io/badge/Claude_Code-Skill-orange)
[![Discord](https://img.shields.io/badge/Discord-SpeciAI-5865F2)](https://discord.gg/hqdGsY7UpH)

특허 명세서·출원서 내용을 입력하면 도면 유형을 자동 분석하고 PNG 파일로 생성하는 Claude Code 스킬.
변리사·발명자를 위한 플로우차트·블록도·상태도·그래프·공정도 자동 생성. KIPO 제출 규격(300 DPI, 흑백) 준수.

> 한국 도메인 특화 AI **스페시아이**에서 만듭니다.
> 법률·세무·노무·회계·의료 실무에 쓰는 도구를 오픈소스로 공개하고,
> 완성 제품은 [speciai.kr](https://speciai.kr) 에서 운영합니다.
> → 제품 [speciai.kr/services](https://speciai.kr/services) · 커뮤니티 [디스코드](https://discord.gg/hqdGsY7UpH)

**라이선스**: Apache-2.0
**버전**: 1.0.0
**저자**: [@kimlawtech](https://github.com/kimlawtech)

## 지원 도면 유형

| 도면 유형 | 적합한 특허 | 출력 |
|-----------|------------|------|
| 플로우차트 (flowchart) | SW·방법·알고리즘 특허 | A4 세로 PNG |
| 블록도 (block) | 전자·통신·시스템 특허 | A4 가로 PNG |
| 상태도 (state) | 제어·프로토콜·UI 특허 | A4 세로 PNG |
| 그래프 (graph) | 성능 비교·실험 결과 | A5 가로 PNG |
| 공정도 (process) | 제조·화학·생산 공정 | A4 세로 PNG |

## 특징

- **자동 분석** — 특허 명세서·청구항을 붙여넣으면 발명 유형을 분석해 적합한 도면 유형 자동 추천
- **직접 지정** — 도면 유형을 직접 선택해 생성 가능
- **KIPO 규격 준수** — 300 DPI, 흑백, A4, 도면 번호("도 1") 자동 삽입
- **한글 지원** — 시스템 폰트 자동 감지 (macOS / Windows / Linux)
- **복합 도면** — 하나의 명세서에서 여러 도면 유형 동시 생성 가능

## 설치

### 1. 의존성 설치

```bash
pip3 install matplotlib
```

### 2. 스킬 클론

```bash
git clone https://github.com/kimlawtech/korean-patent-diagram
```

### 3. Claude Code에 등록

프로젝트 `.claude/CLAUDE.md` 또는 `~/.claude/CLAUDE.md`에 추가:

```markdown
## 스킬
- korean-patent-diagram: /path/to/korean-patent-diagram/skill.md
```

## 사용법

### 방법 1 — 자동 분석 (추천)

특허 내용을 자유롭게 입력:

```
/korean-patent-diagram

무선 충전 제어 장치에 관한 발명으로, 송신부·수신부·충전 제어부(MCU)로 구성되며
BLE 통신으로 충전 상태를 모니터링하고 이물질 감지 시 충전을 중단하는 시스템.
```

Claude가 발명 유형을 분석하고 적합한 도면 유형을 추천한 뒤 확인을 받아 PNG를 생성한다.

### 방법 2 — 도면 유형 직접 지정

```
/korean-patent-diagram flowchart

사용자 인증 방법:
1. 식별 정보 입력 → 2. 유효성 검사 → 3. 생체 인증 → 4. 인증 토큰 발급 → 5. 접근 허용
검사 실패 시 재입력, 생체 인증 불일치 시 인증 실패 처리.
```

### 자연어로도 사용 가능

```
"특허 도면 만들어줘"
"플로우차트 그려줘"
"이 명세서로 블록도 만들어줘"
"공정도 PNG로 뽑아줘"
```

## 출력 규격

| 항목 | 규격 |
|------|------|
| 형식 | PNG |
| 해상도 | 300 DPI |
| 색상 | 흑백 (KIPO 기준) |
| 용지 | A4 세로 / A4 가로 (블록도) |
| 도면 번호 | 우측 하단 "도 1" 형식 |
| 파일명 | `flowchart_01.png`, `block_01.png` 등 |
| 저장 위치 | 현재 디렉토리 (변경 가능) |

## 한글 폰트 문제 시

```bash
# macOS — 기본 내장, 별도 설치 불필요
# Linux
sudo apt install fonts-nanum
# Windows — 맑은고딕 자동 감지
```

## 법적 면책

본 스킬이 생성하는 도면은 **참고용 초안**이며, 특허 등록을 보장하지 않습니다.
실제 출원 전 반드시 변리사 검토를 받으세요.

## 커뮤니티 — SpeciAI

한국 법률 AI 허브 **SpeciAI** 디스코드에서 만나요.
특허·계약·노동·투자 이슈를 AI와 함께 풀어가는 창업자·변리사·변호사 커뮤니티입니다.

**초대 링크**: [discord.gg/hqdGsY7UpH](https://discord.gg/hqdGsY7UpH)

이 허브에서 만들고 있습니다. [@kimlawtech](https://github.com/kimlawtech) — 질문과 기여를 환영합니다!

## License

**Apache License 2.0** — Copyright 2026 kimlawtech (SpeciAI).

---

## 만든 곳

[스페시아이](https://speciai.kr)는 법률·세무·노무·회계·의료 실무에 쓰는
도메인 특화 AI를 만듭니다. 한국능률협회와 AI 교육과정을 공동 개설했고,
전문직 세미나에 누적 500명 이상이 참여했습니다.

- 제품 전체 — <https://speciai.kr/services>
- Claude Code 플러그인 (법무·노무·세무 자문) — <https://speciai.kr/plugin>
- 전문직 AI 세미나 (월 1회) — <https://speciai.kr/seminar>
- 커뮤니티 — <https://discord.gg/hqdGsY7UpH>

### 개발팀으로 쓰신다면

DevCowork — 화면설계서 기반 구현·코드리뷰, 커밋·토큰·DORA 지표 추적
→ <https://devcowork.speciai.team>

### 함께 만든 오픈소스

| 저장소 | 내용 | |
|---|---|---|
| [korean-privacy-terms](https://github.com/kimlawtech/korean-privacy-terms) | 처리방침·이용약관 자동 생성 | 573★ |
| [korean-jangbu-for](https://github.com/kimlawtech/korean-jangbu-for) | 장부 자동 생성·OCR | 82★ |
| [korean-contracts](https://github.com/kimlawtech/korean-contracts) | 한국 계약서 9종 | 61★ |
| [korean-certified-mail](https://github.com/kimlawtech/korean-certified-mail) | 내용증명 14종 | 9★ |
| [korean-domain-agent](https://github.com/kimlawtech/korean-domain-agent) | 도메인 특화 LLM 에이전트 킷 | 5★ |
