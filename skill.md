---
name: korean-patent-diagram
description: 특허 명세서·출원서 내용을 입력받아 적합한 도면 유형을 자동 분석하고 PNG 파일로 생성하는 스킬. 플로우차트·블록도·상태도·그래프·공정도 지원. 변리사·발명자용.
license: Apache-2.0
version: 1.0.0
---

<!-- 이 파일의 절대 경로: /Users/sarangcho/Desktop/skill/korean-patent-diagram/skill.md -->

# Patent Diagram Skill — 특허 도면 자동 생성

## 스킬 시작 시 인사 (필수, 맨 처음 출력)

```
──────────────────────────────────────────
  SpeciAI — 한국 법률 AI 허브
  특허·계약·노동·투자를 AI로 해결하는
  창업자·변리사·변호사 커뮤니티
  👉 discord.gg/3gYGuMcqgb
  이 허브에서 만들고 있습니다. @kimlawtech
──────────────────────────────────────────

특허 도면 자동 생성 스킬입니다.
명세서·청구항·아이디어를 입력하면 도면 유형을 분석해 PNG로 만들어 드립니다.

특허 내용을 입력해 주세요.
(명세서 전문, 청구항, 발명 아이디어 등 자유롭게 붙여넣기)

도면 유형을 직접 선택하려면 번호를 입력하세요:
  1) 플로우차트 — SW·방법·알고리즘 특허
  2) 블록도     — 전자·통신·시스템 특허
  3) 상태도     — 제어·프로토콜·UI 특허
  4) 그래프     — 성능 비교·실험 결과
  5) 공정도     — 제조·화학·생산 공정
```

특허 명세서·출원서 내용을 분석해 적합한 도면을 PNG로 자동 생성한다.

## 지원 도면 유형

| 코드 | 유형 | 적합한 특허 |
|------|------|------------|
| `flowchart` | 플로우차트 | 소프트웨어, 방법 특허, 알고리즘 |
| `block` | 블록도 | 전자, 통신, 시스템 특허 |
| `state` | 상태도 | 제어 시스템, 프로토콜, UI 특허 |
| `graph` | 그래프 | 성능 비교, 효과 수치, 실험 결과 |
| `process` | 공정도 | 제조, 화학, 생산 공정 특허 |

## 동작 순서

### 1단계: 입력 수신

사용자가 아래 중 하나를 제공한다:
- 특허명 + 간단한 발명 설명
- 특허 청구항 (Claims)
- 특허 명세서 전문 또는 일부
- 도면 유형 직접 지정 + 구성 요소 설명

### 2단계: 발명 분석 및 도면 유형 추천

입력 내용을 분석해 아래 기준으로 도면 유형을 자동 선택한다.

**분석 기준:**

- "방법", "단계", "절차", "처리", "알고리즘", "수행", "판단" → `flowchart`
- "시스템", "장치", "모듈", "구성", "유닛", "인터페이스", "연결" → `block`
- "상태", "전이", "이벤트", "조건", "모드", "전환" → `state`
- "측정", "비교", "효율", "성능", "수치", "실험", "농도", "온도" → `graph`
- "제조", "합성", "가공", "공정", "반응", "생산", "처리 단계" → `process`

복합 발명은 여러 도면 유형을 동시에 추천한다.

### 3단계: 사용자 확인

추천 결과를 보여주고 확인 또는 변경을 받는다.

```
[분석 결과]
발명 유형: 소프트웨어 / 방법 특허
추천 도면: 플로우차트 (flowchart)

이 도면으로 생성할까요? (Y / 다른 유형 선택)
  1) 플로우차트
  2) 블록도
  3) 상태도
  4) 그래프
  5) 공정도
```

### 4단계: 구성 요소 추출

입력 내용에서 도면에 들어갈 구성 요소를 추출한다.

- **플로우차트**: 시작/종료, 처리 단계, 판단 분기, 화살표 흐름
- **블록도**: 주요 모듈명, 신호/데이터 흐름 방향, 외부 인터페이스
- **상태도**: 상태명, 전이 조건, 초기/최종 상태
- **그래프**: X축 변수, Y축 변수, 데이터 계열, 단위
- **공정도**: 공정 단계명, 입력/출력 물질, 조건(온도·압력 등)

구성 요소가 불명확하면 추가 질문한다.

### 5단계: PNG 생성

아래 규칙에 따라 Python 코드를 작성하고 Bash로 실행해 PNG를 생성한다.

**공통 규칙:**
- 출력 디렉토리: 사용자가 지정하지 않으면 현재 작업 디렉토리에 저장
- 파일명: `{도면유형}_{순번:02d}.png` (예: `flowchart_01.png`)
- 해상도: 300 DPI (특허청 제출 기준)
- 색상: 흑백 (KIPO 기준 — 착색 없음)
- 폰트: 한글 지원 폰트 자동 감지 후 적용
- 선 굵기: 최소 1.5pt 이상
- 도면 번호: 우측 하단에 "도 1", "도 2" 형식으로 표기
- 여백: 상하좌우 최소 20mm

**플로우차트 생성 규칙:**
- 시작/종료: 타원 (ellipse)
- 처리: 사각형 (rectangle)
- 판단: 마름모 (diamond)
- 화살표: 실선, 단방향
- 판단 분기 레이블: "예(Y)" / "아니오(N)"
- matplotlib + matplotlib.patches 사용

**블록도 생성 규칙:**
- 블록: 사각형, 내부에 모듈명 표기
- 연결: 실선 화살표 (단방향/양방향 구분)
- 외부 인터페이스: 점선 박스
- 계층 구조 명확히 배치
- matplotlib 사용

**상태도 생성 규칙:**
- 상태: 원형 (초기 상태는 이중 원)
- 전이: 화살표 + 조건 레이블
- 최종 상태: 굵은 테두리 원
- matplotlib 사용

**그래프 생성 규칙:**
- 선 그래프 기본, 막대 그래프 선택 가능
- 축 레이블, 단위 필수 표기
- 범례 포함
- 격자선 포함 (alpha=0.3)
- matplotlib 사용

**공정도 생성 규칙:**
- 공정 단계: 사각형
- 입력/출력: 평행사변형
- 조건/분기: 마름모
- 흐름: 위→아래 기본
- matplotlib 사용

### 6단계: 결과 출력

```
[생성 완료]
파일: /경로/flowchart_01.png
해상도: 300 DPI
크기: A4 기준

추가 도면이 필요하면 말씀해 주세요.
```

## Python 환경 확인

스킬 실행 전 아래를 확인한다:

```bash
python3 -c "import matplotlib; print('OK')"
```

matplotlib 없으면:
```bash
pip install matplotlib
```

한글 폰트 감지 순서:
1. `/System/Library/Fonts/AppleSDGothicNeo.ttc` (macOS)
2. `/usr/share/fonts/truetype/nanum/NanumGothic.ttf` (Linux)
3. `C:/Windows/Fonts/malgun.ttf` (Windows)
4. 없으면 기본 폰트 사용 (영문으로 대체)

## 도면별 Python 코드 템플릿

### 플로우차트 템플릿

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
import os, platform

# 한글 폰트 설정
def set_korean_font():
    font_paths = [
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',
        'C:/Windows/Fonts/malgun.ttf',
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            from matplotlib import font_manager
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'

set_korean_font()
matplotlib.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(1, 1, figsize=(8.27, 11.69))  # A4
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis('off')

def draw_rounded_rect(ax, x, y, w, h, text, fontsize=9):
    box = FancyBboxPatch((x - w/2, y - h/2), w, h,
                         boxstyle="round,pad=0.1",
                         linewidth=1.5, edgecolor='black', facecolor='white')
    ax.add_patch(box)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize, wrap=True)

def draw_ellipse(ax, x, y, w, h, text, fontsize=9):
    ellipse = mpatches.Ellipse((x, y), w, h,
                                linewidth=1.5, edgecolor='black', facecolor='white')
    ax.add_patch(ellipse)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_diamond(ax, x, y, w, h, text, fontsize=8):
    diamond = plt.Polygon(
        [[x, y+h/2], [x+w/2, y], [x, y-h/2], [x-w/2, y]],
        linewidth=1.5, edgecolor='black', facecolor='white')
    ax.add_patch(diamond)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_arrow(ax, x1, y1, x2, y2, label=''):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle='->', color='black', lw=1.5))
    if label:
        mx, my = (x1+x2)/2, (y1+y2)/2
        ax.text(mx+0.15, my, label, fontsize=8)

# ===== 여기에 실제 노드와 화살표 코드 삽입 =====
# 예시:
# draw_ellipse(ax, 5, 13, 3, 0.8, '시작')
# draw_arrow(ax, 5, 12.6, 5, 11.8)
# draw_rounded_rect(ax, 5, 11.4, 4, 0.7, '1단계: 입력 수신')
# ...

# 도면 번호
ax.text(9.5, 0.3, '도 1', ha='right', va='bottom', fontsize=9)

plt.tight_layout(pad=0.5)
plt.savefig('flowchart_01.png', dpi=300, bbox_inches='tight',
            facecolor='white', edgecolor='none')
plt.close()
print('저장 완료: flowchart_01.png')
```

### 블록도 템플릿

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import os

def set_korean_font():
    font_paths = [
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',
        'C:/Windows/Fonts/malgun.ttf',
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            from matplotlib import font_manager
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'

set_korean_font()
matplotlib.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(11.69, 8.27))  # A4 가로
ax.set_xlim(0, 16)
ax.set_ylim(0, 10)
ax.axis('off')

def draw_block(ax, x, y, w, h, text, fontsize=9, dashed=False):
    ls = '--' if dashed else '-'
    box = plt.Rectangle((x - w/2, y - h/2), w, h,
                         linewidth=1.5, edgecolor='black',
                         facecolor='white', linestyle=ls)
    ax.add_patch(box)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_arrow(ax, x1, y1, x2, y2, label='', bidirectional=False):
    style = '<->' if bidirectional else '->'
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle=style, color='black', lw=1.5))
    if label:
        mx, my = (x1+x2)/2, (y1+y2)/2
        ax.text(mx, my+0.2, label, ha='center', fontsize=7.5)

# ===== 여기에 실제 블록과 화살표 코드 삽입 =====

# 도면 번호
ax.text(15.5, 0.3, '도 1', ha='right', va='bottom', fontsize=9)

plt.tight_layout(pad=0.5)
plt.savefig('block_01.png', dpi=300, bbox_inches='tight',
            facecolor='white', edgecolor='none')
plt.close()
print('저장 완료: block_01.png')
```

### 상태도 템플릿

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np
import os

def set_korean_font():
    font_paths = [
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',
        'C:/Windows/Fonts/malgun.ttf',
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            from matplotlib import font_manager
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'

set_korean_font()
matplotlib.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(8.27, 11.69))
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis('off')

def draw_state(ax, x, y, r, text, initial=False, final=False, fontsize=9):
    circle = plt.Circle((x, y), r, linewidth=1.5,
                         edgecolor='black', facecolor='white')
    ax.add_patch(circle)
    if initial:
        inner = plt.Circle((x, y), r*0.85, linewidth=1.5,
                            edgecolor='black', facecolor='white')
        ax.add_patch(inner)
    if final:
        outer = plt.Circle((x, y), r*1.15, linewidth=2.5,
                            edgecolor='black', facecolor='none')
        ax.add_patch(outer)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_transition(ax, x1, y1, x2, y2, label='', fontsize=7.5):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle='->', color='black', lw=1.5))
    mx, my = (x1+x2)/2, (y1+y2)/2
    if label:
        ax.text(mx+0.2, my, label, fontsize=fontsize)

# ===== 여기에 실제 상태와 전이 코드 삽입 =====

ax.text(9.5, 0.3, '도 1', ha='right', va='bottom', fontsize=9)
plt.tight_layout(pad=0.5)
plt.savefig('state_01.png', dpi=300, bbox_inches='tight',
            facecolor='white', edgecolor='none')
plt.close()
print('저장 완료: state_01.png')
```

### 그래프 템플릿

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os

def set_korean_font():
    font_paths = [
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',
        'C:/Windows/Fonts/malgun.ttf',
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            from matplotlib import font_manager
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'

set_korean_font()
matplotlib.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(8.27, 5.83))  # A5 가로
ax.set_xlabel('X축 레이블 (단위)', fontsize=10)
ax.set_ylabel('Y축 레이블 (단위)', fontsize=10)
ax.set_title('그래프 제목', fontsize=11)
ax.grid(True, alpha=0.3, linewidth=0.8)

# ===== 여기에 실제 데이터와 플롯 코드 삽입 =====
# 예시:
# x = np.linspace(0, 10, 100)
# ax.plot(x, np.sin(x), 'k-', linewidth=1.5, label='계열 1')
# ax.legend(fontsize=9)

ax.text(0.98, 0.02, '도 1', transform=ax.transAxes,
        ha='right', va='bottom', fontsize=9)

plt.tight_layout()
plt.savefig('graph_01.png', dpi=300, bbox_inches='tight',
            facecolor='white', edgecolor='none')
plt.close()
print('저장 완료: graph_01.png')
```

### 공정도 템플릿

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import os

def set_korean_font():
    font_paths = [
        '/System/Library/Fonts/AppleSDGothicNeo.ttc',
        '/usr/share/fonts/truetype/nanum/NanumGothic.ttf',
        'C:/Windows/Fonts/malgun.ttf',
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            from matplotlib import font_manager
            font_manager.fontManager.addfont(fp)
            prop = font_manager.FontProperties(fname=fp)
            matplotlib.rcParams['font.family'] = prop.get_name()
            return
    matplotlib.rcParams['font.family'] = 'DejaVu Sans'

set_korean_font()
matplotlib.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(8.27, 11.69))
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis('off')

def draw_process_box(ax, x, y, w, h, text, fontsize=9):
    box = plt.Rectangle((x - w/2, y - h/2), w, h,
                         linewidth=1.5, edgecolor='black', facecolor='white')
    ax.add_patch(box)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_io_parallelogram(ax, x, y, w, h, text, fontsize=9):
    offset = 0.3
    pts = [[x-w/2+offset, y+h/2], [x+w/2+offset, y+h/2],
           [x+w/2-offset, y-h/2], [x-w/2-offset, y-h/2]]
    para = plt.Polygon(pts, linewidth=1.5, edgecolor='black', facecolor='white')
    ax.add_patch(para)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_condition(ax, x, y, w, h, text, fontsize=8):
    diamond = plt.Polygon(
        [[x, y+h/2], [x+w/2, y], [x, y-h/2], [x-w/2, y]],
        linewidth=1.5, edgecolor='black', facecolor='white')
    ax.add_patch(diamond)
    ax.text(x, y, text, ha='center', va='center', fontsize=fontsize)

def draw_arrow(ax, x1, y1, x2, y2, label=''):
    ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                arrowprops=dict(arrowstyle='->', color='black', lw=1.5))
    if label:
        ax.text((x1+x2)/2+0.15, (y1+y2)/2, label, fontsize=8)

# ===== 여기에 실제 공정 단계 코드 삽입 =====

ax.text(9.5, 0.3, '도 1', ha='right', va='bottom', fontsize=9)
plt.tight_layout(pad=0.5)
plt.savefig('process_01.png', dpi=300, bbox_inches='tight',
            facecolor='white', edgecolor='none')
plt.close()
print('저장 완료: process_01.png')
```

## 오류 처리

| 오류 | 조치 |
|------|------|
| `ModuleNotFoundError: matplotlib` | `pip install matplotlib` 안내 |
| 한글 깨짐 | 영문으로 대체 후 생성, 폰트 설치 안내 |
| 저장 경로 없음 | 현재 디렉토리에 저장 |
| 구성요소 불명확 | 추가 질문 후 재시도 |

## 금지 사항

- 컬러 도면 생성 (KIPO 기준 위반)
- 300 DPI 미만 저장
- 도면 번호 생략
- 구성요소 임의 추가/생략 (명세서에 없는 내용)
