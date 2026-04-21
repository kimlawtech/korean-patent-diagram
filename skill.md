---
name: korean-patent-diagram
description: 특허 명세서·출원서 내용을 입력받아 적합한 도면 유형을 자동 분석하고 PNG 파일로 생성하는 스킬. 플로우차트·블록도·상태도·그래프·공정도 지원. KIPO 규격 준수. 변리사·발명자용.
license: Apache-2.0
version: 1.1.0
---

<!-- 이 파일의 절대 경로: /Users/sarangcho/Desktop/skill/korean-patent-diagram/skill.md -->

# Patent Diagram Skill — 특허 도면 자동 생성

## 스킬 시작 시 인사 (필수, 맨 처음 출력)

```
──────────────────────────────────────────
  SpeciAI — 한국 법률 AI 허브
  특허·계약·노동·투자를 AI로 해결하는
  창업자·변리사·변호사 커뮤니티
  discord.gg/3gYGuMcqgb
  이 허브에서 만들고 있습니다. @kimlawtech
──────────────────────────────────────────

특허 도면 자동 생성 스킬입니다.
명세서·청구항·아이디어를 입력하면 도면 유형을 분석해 PNG로 만들어 드립니다.

[설정] 시작 전 아래 항목을 입력해 주세요. (엔터 = 기본값 사용)

  1. 저장 경로     : _______________ (기본: 현재 디렉토리)
  2. 도면 번호     : _______________ (기본: 도 1, 도 2 ...)
  3. 글자 크기     : _______________ (기본: 9pt / KIPO 최소 3.2mm)
  4. 참조부호 시작 : _______________ (기본: 100번대, 예: 100, 110, 120...)
  5. 출원 유형     : 국내(K) / PCT국제(P) (기본: K)

설정 완료 후 특허 내용을 입력해 주세요.
(명세서 전문, 청구항, 발명 아이디어 등 자유롭게 붙여넣기)

도면 유형을 직접 선택하려면 번호를 입력하세요:
  1) 플로우차트 — SW·방법·알고리즘 특허
  2) 블록도     — 전자·통신·시스템 특허
  3) 상태도     — 제어·프로토콜·UI 특허
  4) 그래프     — 성능 비교·실험 결과
  5) 공정도     — 제조·화학·생산 공정
```

## KIPO 도면 규격 (특허법 시행규칙 기준 — 반드시 준수)

### 용지 및 여백

| 항목 | 국내 출원 | PCT 국제출원 |
|------|----------|-------------|
| 용지 | A4 (210×297mm) | A4 (210×297mm) |
| 상단 여백 | 40mm | 25mm |
| 좌단 여백 | 25mm | 25mm |
| 하단 여백 | 20mm | 10mm |
| 우단 여백 | 20mm | 15mm |

### 폰트 규격

- **폰트**: 굴림체 우선 적용. 없으면 맑은고딕 → 나눔고딕 → DejaVu Sans 순으로 대체
- **최소 글자 크기**: 3.2mm (약 9pt) — 2/3 축척 축소 후에도 식별 가능해야 함
- **도면 내 텍스트**: 불필요한 문자 최소화. 꼭 필요한 명칭·부호만 기재

### 선 및 도형 규격

- **선 색상**: 짙은 흑색만 사용 (컬러 금지)
- **선 굵기**: 0.5mm 기본 (외곽선), 0.35mm (보조선), 0.25mm (세부선)
- **절단면**: 평행사선으로 표시
- **해상도**: 300 DPI 이상

### 참조부호 (도면 부호) 체계

- 백 단위 체계 사용: 100번대(첫 번째 구성), 200번대(두 번째 구성) 등
- 세부 구성요소: 110, 120, 130 / 210, 220, 230 형식
- 명세서 전체에서 동일 부호 일관 사용
- 부호는 도형 외부에 인출선(지시선)으로 연결

### 도면 번호 표기

- **기본 형식**: "도 1", "도 2" (우측 하단)
- **면수 표기**: 우측 상단에 "1/5" 형식 (총 5면 중 1면)
- PCT 출원 시 "Fig. 1" 병기 가능

## 지원 도면 유형

| 코드 | 유형 | 적합한 특허 |
|------|------|------------|
| `flowchart` | 플로우차트 | 소프트웨어, 방법 특허, 알고리즘 |
| `block` | 블록도 | 전자, 통신, 시스템 특허 |
| `state` | 상태도 | 제어 시스템, 프로토콜, UI 특허 |
| `graph` | 그래프 | 성능 비교, 효과 수치, 실험 결과 |
| `process` | 공정도 | 제조, 화학, 생산 공정 특허 |

## 동작 순서

### 1단계: 설정 수신

사용자 입력을 받아 아래 변수를 확정한다:

```
SAVE_PATH      = 입력값 or 현재 디렉토리
DIAGRAM_NO     = 입력값 or "도 1"
FONT_SIZE      = 입력값 or 9  (pt)
REF_START      = 입력값 or 100
FILING_TYPE    = "K"(국내) or "P"(PCT)
MARGIN         = K이면 상40/좌25/하20/우20mm, P이면 상25/좌25/하10/우15mm
```

### 2단계: 입력 수신

사용자가 아래 중 하나를 제공한다:
- 특허명 + 간단한 발명 설명
- 특허 청구항 (Claims)
- 특허 명세서 전문 또는 일부
- 도면 유형 직접 지정 + 구성 요소 설명

### 3단계: 발명 분석 및 도면 유형 추천

입력 내용을 분석해 아래 기준으로 도면 유형을 자동 선택한다.

- "방법", "단계", "절차", "처리", "알고리즘", "수행", "판단" → `flowchart`
- "시스템", "장치", "모듈", "구성", "유닛", "인터페이스", "연결" → `block`
- "상태", "전이", "이벤트", "조건", "모드", "전환" → `state`
- "측정", "비교", "효율", "성능", "수치", "실험", "농도", "온도" → `graph`
- "제조", "합성", "가공", "공정", "반응", "생산", "처리 단계" → `process`

복합 발명은 여러 도면 유형을 동시에 추천한다.

### 4단계: 사용자 확인

```
[분석 결과]
발명 유형: 소프트웨어 / 방법 특허
추천 도면: 플로우차트 (flowchart)

이 도면으로 생성할까요? (Y / 다른 유형 선택)
  1) 플로우차트  2) 블록도  3) 상태도  4) 그래프  5) 공정도
```

### 5단계: 구성 요소 추출 및 참조부호 부여

입력 내용에서 구성 요소를 추출하고 참조부호를 자동 부여한다.

- **플로우차트**: 시작/종료, 처리 단계(S100, S200...), 판단 분기
- **블록도**: 모듈명 + 참조부호(100, 200...), 신호 흐름 방향
- **상태도**: 상태명 + 참조부호, 전이 조건, 초기/최종 상태
- **그래프**: X축 변수·단위, Y축 변수·단위, 데이터 계열
- **공정도**: 공정 단계명 + 참조부호, 입출력 물질, 조건값

구성 요소가 불명확하면 추가 질문한다.

### 6단계: PNG 생성

Python 코드를 작성하고 Bash로 실행해 PNG를 생성한다.

**공통 생성 규칙:**
- 저장 경로: 1단계에서 확정한 SAVE_PATH 사용. 없으면 `mkdir -p`로 생성
- 파일명: `{도면유형}_{순번:02d}.png`
- 해상도: 300 DPI
- 용지: A4 (8.27×11.69인치 세로 / 11.69×8.27인치 가로)
- 여백: FILING_TYPE에 따라 MARGIN 적용
- 색상: 흑백 전용
- 폰트: 굴림체 우선, 없으면 맑은고딕 → 나눔고딕 → DejaVu Sans
- 글자 크기: FONT_SIZE 값 사용 (최소 9pt 강제)
- 선 굵기: 외곽 1.5pt / 보조 1.0pt
- 도면 번호: 우측 하단 DIAGRAM_NO 표기
- 면수: 우측 상단 "1/N" 형식 표기
- 참조부호: REF_START 기준으로 부여, 인출선으로 도형 외부 연결

**플로우차트 생성 규칙:**
- 시작/종료: 타원
- 처리: 사각형 (단계번호 S100, S200 병기)
- 판단: 마름모
- 화살표: 실선 단방향
- 분기 레이블: "예(Y)" / "아니오(N)"

**블록도 생성 규칙:**
- 블록: 사각형 + 참조부호 우측 하단 표기
- 연결: 실선 화살표 (단방향/양방향)
- 외부 인터페이스: 점선 박스
- 계층 구조 명확히 배치

**상태도 생성 규칙:**
- 상태: 원형 + 참조부호
- 초기 상태: 이중 원
- 최종 상태: 굵은 테두리 원
- 전이: 화살표 + 조건 레이블

**그래프 생성 규칙:**
- 선 그래프 기본, 막대 그래프 선택 가능
- 축 레이블 + 단위 필수
- 범례 포함
- 격자선 (alpha=0.3)
- 흑백 선 스타일 구분: 실선/점선/일점쇄선

**공정도 생성 규칙:**
- 공정 단계: 사각형 + 참조부호
- 입출력: 평행사변형
- 조건/분기: 마름모
- 흐름: 위→아래

### 7단계: 결과 출력

```
[생성 완료]
파일: {SAVE_PATH}/flowchart_01.png
규격: A4 / 300 DPI / 흑백 / 굴림체
여백: 국내출원 기준 (상40/좌25/하20/우20mm)
참조부호: 100번대 적용

추가 도면이 필요하면 말씀해 주세요.
```

## Python 폰트 설정 — 굴림체 우선

모든 템플릿에 아래 함수를 공통 적용한다:

```python
def set_patent_font():
    import os
    from matplotlib import font_manager
    # 굴림체 우선 — KIPO 도면 표준 폰트
    font_paths = [
        'C:/Windows/Fonts/gulim.ttc',           # Windows 굴림체
        '/System/Library/Fonts/Supplemental/AppleGothic.ttf',  # macOS 대체
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',          # macOS SD고딕
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',     # Linux 나눔고딕
        'C:/Windows/Fonts/malgun.ttf',          # Windows 맑은고딕
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return prop.get_name()
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'
    return 'DejaVu Sans'
```

macOS에는 굴림체가 기본 내장되지 않으므로 Apple SD Gothic Neo로 대체한다. Windows 환경에서는 굴림체가 정확히 적용된다.

## 도면별 Python 코드 템플릿

### 공통 헤더 (모든 템플릿 상단에 포함)

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import matplotlib.patheffects as pe
import os

def set_patent_font():
    from matplotlib import font_manager
    font_paths = [
        'C:/Windows/Fonts/gulim.ttc',
        '/System/Library/Fonts/Supplemental/AppleGothic.ttf',
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',
        'C:/Windows/Fonts/malgun.ttf',
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'

set_patent_font()
matplotlib.rcParams['axes.unicode_minus'] = False

# ── 설정값 (사용자 입력 반영) ──
FONT_SIZE   = 9        # 최소 9pt (KIPO 3.2mm 기준)
DIAGRAM_NO  = '도 1'
SAVE_PATH   = '.'      # 저장 경로
TOTAL_PAGES = 1        # 전체 도면 수
PAGE_NO     = 1        # 현재 도면 번호
LINE_W      = 1.5      # 외곽선 굵기
SUB_LINE_W  = 1.0      # 보조선 굵기
```

### 플로우차트 템플릿

```python
# [공통 헤더 삽입]

# 국내출원 기준 여백 반영 A4
fig, ax = plt.subplots(figsize=(8.27, 11.69))
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis('off')

# 여백 표시 (국내: 상40/좌25/하20/우20mm → 비율 변환)
ax.set_position([0.095, 0.068, 0.810, 0.864])

def ellipse(ax, x, y, w, h, text, fs=None):
    fs = fs or FONT_SIZE
    e = mpatches.Ellipse((x,y), w, h, lw=LINE_W, edgecolor='black', facecolor='white')
    ax.add_patch(e)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs, multialignment='center')

def rect(ax, x, y, w, h, text, step=None, ref=None, fs=None):
    fs = fs or FONT_SIZE
    from matplotlib.patches import FancyBboxPatch
    b = FancyBboxPatch((x-w/2, y-h/2), w, h, boxstyle="round,pad=0.05",
                       lw=LINE_W, edgecolor='black', facecolor='white')
    ax.add_patch(b)
    label = f"{step}\n{text}" if step else text
    ax.text(x, y, label, ha='center', va='center', fontsize=fs, multialignment='center')
    if ref:
        ax.text(x+w/2-0.05, y-h/2+0.05, str(ref), ha='right', va='bottom', fontsize=fs-2)

def diamond(ax, x, y, w, h, text, ref=None, fs=None):
    fs = fs or FONT_SIZE
    d = plt.Polygon([[x,y+h/2],[x+w/2,y],[x,y-h/2],[x-w/2,y]],
                    lw=LINE_W, edgecolor='black', facecolor='white')
    ax.add_patch(d)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs-1, multialignment='center')
    if ref:
        ax.text(x+w/2+0.05, y, str(ref), ha='left', va='center', fontsize=fs-2)

def arrow(ax, x1, y1, x2, y2, label='', lx=0.2, ly=0):
    ax.annotate('', xy=(x2,y2), xytext=(x1,y1),
                arrowprops=dict(arrowstyle='->', color='black', lw=LINE_W))
    if label:
        ax.text((x1+x2)/2+lx, (y1+y2)/2+ly, label, fontsize=FONT_SIZE-1.5)

def hline(ax, x1, y1, x2, y2):
    ax.plot([x1,x2],[y1,y2],'k-', lw=LINE_W)

# ===== 실제 노드와 화살표 코드 삽입 =====

# 도면 번호 (우측 하단)
ax.text(9.8, 0.2, DIAGRAM_NO, ha='right', va='bottom', fontsize=FONT_SIZE)
# 면수 표기 (우측 상단)
ax.text(9.8, 13.8, f'{PAGE_NO}/{TOTAL_PAGES}', ha='right', va='top', fontsize=FONT_SIZE-1)

os.makedirs(SAVE_PATH, exist_ok=True)
plt.savefig(f'{SAVE_PATH}/flowchart_{PAGE_NO:02d}.png', dpi=300,
            bbox_inches='tight', facecolor='white', edgecolor='none')
plt.close()
print(f'저장 완료: {SAVE_PATH}/flowchart_{PAGE_NO:02d}.png')
```

### 블록도 템플릿

```python
# [공통 헤더 삽입]

fig, ax = plt.subplots(figsize=(11.69, 8.27))  # A4 가로
ax.set_xlim(0, 16)
ax.set_ylim(0, 10)
ax.axis('off')
ax.set_position([0.085, 0.068, 0.830, 0.864])

def block(ax, x, y, w, h, text, ref=None, fs=None, dashed=False):
    fs = fs or FONT_SIZE
    ls = '--' if dashed else '-'
    b = plt.Rectangle((x-w/2, y-h/2), w, h, lw=LINE_W,
                       edgecolor='black', facecolor='white', linestyle=ls)
    ax.add_patch(b)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs, multialignment='center')
    if ref:
        ax.text(x+w/2-0.08, y-h/2+0.08, str(ref), ha='right', va='bottom', fontsize=fs-2)

def arrow(ax, x1, y1, x2, y2, label='', bidir=False):
    style = '<->' if bidir else '->'
    ax.annotate('', xy=(x2,y2), xytext=(x1,y1),
                arrowprops=dict(arrowstyle=style, color='black', lw=LINE_W))
    if label:
        mx, my = (x1+x2)/2, (y1+y2)/2
        ax.text(mx, my+0.22, label, ha='center', fontsize=FONT_SIZE-1.5)

def leader_line(ax, x1, y1, x2, y2, ref):
    ax.annotate(str(ref), xy=(x1,y1), xytext=(x2,y2),
                fontsize=FONT_SIZE-1,
                arrowprops=dict(arrowstyle='-', color='black', lw=SUB_LINE_W))

# ===== 실제 블록과 화살표 코드 삽입 =====

ax.text(15.8, 0.2, DIAGRAM_NO, ha='right', va='bottom', fontsize=FONT_SIZE)
ax.text(15.8, 9.8, f'{PAGE_NO}/{TOTAL_PAGES}', ha='right', va='top', fontsize=FONT_SIZE-1)

os.makedirs(SAVE_PATH, exist_ok=True)
plt.savefig(f'{SAVE_PATH}/block_{PAGE_NO:02d}.png', dpi=300,
            bbox_inches='tight', facecolor='white', edgecolor='none')
plt.close()
print(f'저장 완료: {SAVE_PATH}/block_{PAGE_NO:02d}.png')
```

### 상태도 템플릿

```python
# [공통 헤더 삽입]

fig, ax = plt.subplots(figsize=(8.27, 11.69))
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis('off')
ax.set_position([0.095, 0.068, 0.810, 0.864])

def state(ax, x, y, r, text, ref=None, initial=False, final=False, fs=None):
    fs = fs or FONT_SIZE
    c = plt.Circle((x,y), r, lw=LINE_W, edgecolor='black', facecolor='white')
    ax.add_patch(c)
    if initial:
        ci = plt.Circle((x,y), r*0.82, lw=LINE_W, edgecolor='black', facecolor='white')
        ax.add_patch(ci)
    if final:
        co = plt.Circle((x,y), r*1.18, lw=2.0, edgecolor='black', facecolor='none')
        ax.add_patch(co)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs, multialignment='center')
    if ref:
        ax.text(x+r+0.08, y+r+0.08, str(ref), ha='left', va='bottom', fontsize=fs-2)

def trans(ax, x1, y1, x2, y2, label='', fs=None):
    fs = fs or FONT_SIZE-1.5
    ax.annotate('', xy=(x2,y2), xytext=(x1,y1),
                arrowprops=dict(arrowstyle='->', color='black', lw=LINE_W))
    if label:
        ax.text((x1+x2)/2+0.2, (y1+y2)/2, label, fontsize=fs)

# ===== 실제 상태와 전이 코드 삽입 =====

ax.text(9.8, 0.2, DIAGRAM_NO, ha='right', va='bottom', fontsize=FONT_SIZE)
ax.text(9.8, 13.8, f'{PAGE_NO}/{TOTAL_PAGES}', ha='right', va='top', fontsize=FONT_SIZE-1)

os.makedirs(SAVE_PATH, exist_ok=True)
plt.savefig(f'{SAVE_PATH}/state_{PAGE_NO:02d}.png', dpi=300,
            bbox_inches='tight', facecolor='white', edgecolor='none')
plt.close()
print(f'저장 완료: {SAVE_PATH}/state_{PAGE_NO:02d}.png')
```

### 그래프 템플릿

```python
# [공통 헤더 삽입]

fig, ax = plt.subplots(figsize=(8.27, 5.83))
ax.set_position([0.095, 0.12, 0.810, 0.78])

# 흑백 선 스타일 (컬러 금지)
LINE_STYLES = ['-', '--', '-.', ':']

ax.set_xlabel('X축 레이블 (단위)', fontsize=FONT_SIZE)
ax.set_ylabel('Y축 레이블 (단위)', fontsize=FONT_SIZE)
ax.set_title('그래프 제목', fontsize=FONT_SIZE+1)
ax.grid(True, alpha=0.3, linewidth=0.5)
ax.tick_params(labelsize=FONT_SIZE-1)

# ===== 실제 데이터와 플롯 코드 삽입 =====
# 예:
# import numpy as np
# x = np.linspace(0, 10, 100)
# ax.plot(x, y1, LINE_STYLES[0], color='black', lw=1.5, label='본 발명')
# ax.plot(x, y2, LINE_STYLES[1], color='black', lw=1.5, label='비교예')
# ax.legend(fontsize=FONT_SIZE-1)

ax.text(1.0, -0.12, DIAGRAM_NO, transform=ax.transAxes,
        ha='right', va='top', fontsize=FONT_SIZE)
ax.text(1.0, 1.02, f'{PAGE_NO}/{TOTAL_PAGES}', transform=ax.transAxes,
        ha='right', va='bottom', fontsize=FONT_SIZE-1)

os.makedirs(SAVE_PATH, exist_ok=True)
plt.savefig(f'{SAVE_PATH}/graph_{PAGE_NO:02d}.png', dpi=300,
            bbox_inches='tight', facecolor='white', edgecolor='none')
plt.close()
print(f'저장 완료: {SAVE_PATH}/graph_{PAGE_NO:02d}.png')
```

### 공정도 템플릿

```python
# [공통 헤더 삽입]

fig, ax = plt.subplots(figsize=(8.27, 11.69))
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis('off')
ax.set_position([0.095, 0.068, 0.810, 0.864])

def proc(ax, x, y, w, h, text, ref=None, fs=None):
    fs = fs or FONT_SIZE
    b = plt.Rectangle((x-w/2, y-h/2), w, h, lw=LINE_W,
                       edgecolor='black', facecolor='white')
    ax.add_patch(b)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs, multialignment='center')
    if ref:
        ax.text(x+w/2-0.05, y-h/2+0.05, str(ref), ha='right', va='bottom', fontsize=fs-2)

def io_para(ax, x, y, w, h, text, fs=None):
    fs = fs or FONT_SIZE
    off = 0.35
    pts = [[x-w/2+off, y+h/2],[x+w/2+off, y+h/2],
           [x+w/2-off, y-h/2],[x-w/2-off, y-h/2]]
    p = plt.Polygon(pts, lw=LINE_W, edgecolor='black', facecolor='white')
    ax.add_patch(p)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs, multialignment='center')

def cond(ax, x, y, w, h, text, ref=None, fs=None):
    fs = fs or FONT_SIZE
    d = plt.Polygon([[x,y+h/2],[x+w/2,y],[x,y-h/2],[x-w/2,y]],
                    lw=LINE_W, edgecolor='black', facecolor='white')
    ax.add_patch(d)
    ax.text(x, y, text, ha='center', va='center', fontsize=fs-1, multialignment='center')
    if ref:
        ax.text(x+w/2+0.08, y, str(ref), ha='left', va='center', fontsize=fs-2)

def arrow(ax, x1, y1, x2, y2, label='', lx=0.2):
    ax.annotate('', xy=(x2,y2), xytext=(x1,y1),
                arrowprops=dict(arrowstyle='->', color='black', lw=LINE_W))
    if label:
        ax.text((x1+x2)/2+lx, (y1+y2)/2, label, fontsize=FONT_SIZE-1.5)

def sideline(ax, x1, y1, x2, y2):
    ax.plot([x1,x2],[y1,y2],'k-', lw=LINE_W)

# ===== 실제 공정 단계 코드 삽입 =====

ax.text(9.8, 0.2, DIAGRAM_NO, ha='right', va='bottom', fontsize=FONT_SIZE)
ax.text(9.8, 13.8, f'{PAGE_NO}/{TOTAL_PAGES}', ha='right', va='top', fontsize=FONT_SIZE-1)

os.makedirs(SAVE_PATH, exist_ok=True)
plt.savefig(f'{SAVE_PATH}/process_{PAGE_NO:02d}.png', dpi=300,
            bbox_inches='tight', facecolor='white', edgecolor='none')
plt.close()
print(f'저장 완료: {SAVE_PATH}/process_{PAGE_NO:02d}.png')
```

## 오류 처리

| 오류 | 조치 |
|------|------|
| `ModuleNotFoundError: matplotlib` | `pip3 install matplotlib` 안내 |
| 굴림체 없음 | macOS: Apple SD Gothic Neo 자동 대체 / Linux: 나눔고딕 |
| 저장 경로 없음 | `mkdir -p`로 자동 생성 |
| 글자 크기 9pt 미만 입력 | 9pt로 강제 상향 후 경고 출력 |
| 구성요소 불명확 | 추가 질문 후 재시도 |

## 금지 사항

- 컬러 도면 생성 (KIPO 기준 위반)
- 300 DPI 미만 저장
- 도면 번호·면수 생략
- 글자 크기 3.2mm(9pt) 미만
- 구성요소 임의 추가/생략 (명세서에 없는 내용)
- 여백 KIPO 기준 미달
