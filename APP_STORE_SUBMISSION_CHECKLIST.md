# App Store 심사 제출 체크리스트

## 1. Game Center 키 추가 ✅

### Xcode에서 설정:
1. Xcode에서 프로젝트 열기
2. 프로젝트 네비게이터에서 "game" 프로젝트 선택
3. "game" 타겟 선택
4. "Signing & Capabilities" 탭 선택
5. "+ Capability" 버튼 클릭
6. "Game Center" 검색 후 추가
7. 체크박스가 활성화되어 있는지 확인

### 확인:
- `game/game.entitlements` 파일에 이미 설정되어 있음
- Xcode에서 Capability로 추가하면 완료

---

## 2. 개인정보 처리지침 정보 제공

### App Store Connect에서 설정:
1. App Store Connect 로그인
2. 앱 선택 → "앱 개인정보 보호" 섹션
3. "개인정보 처리지침" 클릭
4. 다음 정보 입력:

**수집하는 데이터 유형:**
- 이 앱은 **개인정보를 수집하지 않습니다** (게임 점수만 로컬 저장)

**권장 설정:**
- "개인정보를 수집하지 않음" 선택
- 또는 "게임 점수"만 수집한다고 표시 (Game Center 사용 시)

---

## 3. 기본 카테고리 선택

### App Store Connect에서 설정:
1. App Store Connect → 앱 선택
2. "앱 정보" 탭
3. "카테고리" 섹션
4. **기본 카테고리**: "게임" 선택
5. **하위 카테고리**: "퍼즐" 또는 "캐주얼" 선택

**추천 카테고리:**
- 기본: 게임
- 하위: 퍼즐, 캐주얼, 전략 (게임에 따라)

---

## 4. 콘텐츠 권한 정보 설정

### App Store Connect에서 설정:
1. App Store Connect → 앱 선택
2. "앱 정보" 탭
3. "콘텐츠 권한" 섹션
4. 다음 정보 입력:

**권장 설정:**
- **연령 등급**: 4+ (모든 연령)
- **폭력**: 없음
- **성적/노골적 콘텐츠**: 없음
- **도박**: 없음
- **알코올/담배/마약**: 없음
- **의료/치료 정보**: 없음
- **불법/규제 대상 물질**: 없음

**간단한 설정:**
- "4+ 모든 연령" 선택
- 모든 항목 "없음" 또는 "아니오" 선택

---

## 5. 개인정보 처리방침 URL 입력

### 옵션 1: 개인정보를 수집하지 않는 경우

**간단한 개인정보 처리방침 페이지 생성:**

1. GitHub Pages 또는 간단한 웹 호스팅 사용
2. 다음 내용의 HTML 페이지 생성:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>개인정보 처리방침 - 캐주얼 게임 모음</title>
</head>
<body>
    <h1>개인정보 처리방침</h1>
    <h2>캐주얼 게임 모음</h2>
    
    <p><strong>최종 업데이트: 2026년 2월 6일</strong></p>
    
    <h3>1. 수집하는 개인정보</h3>
    <p>본 앱은 개인정보를 수집하지 않습니다.</p>
    
    <h3>2. 게임 데이터</h3>
    <p>게임 점수 및 진행 상황은 기기에만 로컬로 저장되며, 외부 서버로 전송되지 않습니다.</p>
    
    <h3>3. Game Center</h3>
    <p>Game Center를 사용하는 경우, Apple의 Game Center 서비스 정책이 적용됩니다.</p>
    
    <h3>4. 문의</h3>
    <p>개인정보 처리방침에 대한 문의사항이 있으시면 앱스토어를 통해 문의해주세요.</p>
</body>
</html>
```

3. URL을 App Store Connect에 입력

### 옵션 2: 간단한 텍스트 페이지

GitHub Gist나 간단한 호스팅 서비스 사용:
- GitHub Gist: https://gist.github.com
- 또는 간단한 웹사이트 생성

### App Store Connect에서 입력:
1. App Store Connect → 앱 선택
2. "앱 개인정보 보호" 탭
3. "개인정보 처리방침 URL" 필드에 URL 입력
4. 저장

---

## 빠른 체크리스트

- [ ] Xcode에서 Game Center Capability 추가 확인
- [ ] App Store Connect에서 기본 카테고리 선택 (게임 > 퍼즐/캐주얼)
- [ ] 콘텐츠 권한 설정 (4+ 모든 연령, 모든 항목 없음)
- [ ] 개인정보 처리방침 페이지 생성 및 URL 입력
- [ ] 앱 개인정보 보호 섹션에서 개인정보 수집 여부 설정

---

## 참고사항

### 개인정보 처리방침 간단 생성 방법:

**방법 1: GitHub Pages**
1. GitHub에 새 저장소 생성
2. `privacy-policy.html` 파일 생성
3. GitHub Pages 활성화
4. URL: `https://[사용자명].github.io/[저장소명]/privacy-policy.html`

**방법 2: 간단한 텍스트 파일**
- GitHub Gist에 텍스트로 작성
- Raw URL 사용

**방법 3: 무료 호스팅**
- Netlify, Vercel 등 사용

---

## 완료 후

모든 항목을 완료한 후:
1. App Store Connect에서 "심사에 제출" 버튼 클릭
2. 빌드 업로드 확인
3. 심사 제출 완료
