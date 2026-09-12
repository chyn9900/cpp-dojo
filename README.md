# 찬연의 C++ 도장 — 복습 퀴즈 앱

수업에서 배운 C++ 내용(문법 26단원 + 프로젝트 4개)을 복습하는 모바일 퀴즈 앱입니다.

- **접속 주소(휴대폰에서 열기)**: https://claude.ai/code/artifact/6121ad20-1969-4e7d-9c3c-8ecbc40892ba
- 단원별 4지선다 30문제 (총 900문제) + 코딩 테스트 3문제 (총 90문제)
- 문제를 틀리면 자동으로 **오답노트**에 저장되고, **다음 날** "오늘의 복습"에 올라옵니다. 복습에서 2번 연속 맞히면 졸업(제거)됩니다.
- 코딩 테스트: 코드를 입력하면 핵심 기준(정규식) 채점 + 모범답안/해설 제공. "Claude에게 검사받기" 버튼으로 문제+내 코드를 복사해 Claude 앱에 붙여넣으면 정밀 첨삭을 받을 수 있습니다.
- 학습 기록(진도, 오답노트, 작성 코드)은 접속한 기기 브라우저(localStorage)에 저장됩니다. 같은 휴대폰·같은 브라우저로 접속해야 이어집니다.

## 폴더 구성

| 파일 | 설명 |
|---|---|
| `cpp-dojo.html` | 앱 전체(문제 데이터 포함). 아티팩트로 게시된 것과 같은 내용의 백업본 |
| `questions/*.json` | 단원별 문제 데이터 원본 (g01~g26 = 문법, p01~p04 = 프로젝트) |
| `app-template.html` | 데이터 없는 앱 껍데기(템플릿). `__QUIZ_DATA_JSON__` 자리에 데이터가 들어감 |
| `assemble.ps1` | questions/*.json + 템플릿 → cpp-dojo.html 로 조립하는 빌드 스크립트 |

## 새 단원을 배웠을 때 추가하는 방법

Claude Code에서 이 폴더를 열고 이렇게 요청하면 됩니다:

> 새로 배운 cpp 파일(경로)로 "C++ 도장"에 단원을 추가해줘. 기존 방식대로 30문제 + 코딩 3문제 만들어서 같은 주소로 다시 게시해줘.

Claude가 하는 일: 새 cpp 파일 기반으로 `questions/gXX.json`(같은 스키마) 생성 → `assemble.ps1`로 재조립 → **같은 아티팩트 주소로 재게시** (주소가 바뀌지 않으므로 휴대폰 즐겨찾기와 학습 기록이 그대로 유지됩니다).

문제 JSON 스키마: `{id, num, group, title, srcFile, questions:[{q, code, choices[4], answer(0~3), explain, difficulty}], coding:[{title, prompt, starter, checks:[{pattern, desc}], solution, explain}]}`

## 매일 아침 알림

매일 아침 7시에 휴대폰으로 복습 링크가 담긴 알림이 갑니다. (Claude 예약 작업으로 등록됨 — claude.ai 또는 Claude Code의 예약 작업 목록에서 수정/해제 가능)
