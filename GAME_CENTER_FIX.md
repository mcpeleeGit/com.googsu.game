# Game Center Capability 추가 방법

## 문제
App Store Connect에서 "Xcode에서 com.apple.developer.game-center 키를 추가해야 합니다" 오류 발생

## 해결 방법

### 방법 1: Xcode에서 Capability 추가 (권장)

**단계별 가이드:**

1. **Xcode에서 프로젝트 열기**
   ```
   game.xcodeproj 파일을 Xcode로 엽니다
   ```

2. **프로젝트 네비게이터에서 프로젝트 선택**
   - 왼쪽 사이드바에서 최상단의 "game" (파란색 아이콘) 클릭

3. **타겟 선택**
   - 중앙 영역에서 "TARGETS" 아래의 "game" 선택

4. **Signing & Capabilities 탭 선택**
   - 상단 탭 메뉴에서 "Signing & Capabilities" 클릭

5. **Capability 추가**
   - 왼쪽 상단의 "+ Capability" 버튼 클릭
   - 검색창에 "Game Center" 입력
   - "Game Center" 선택하여 추가

6. **확인**
   - Capabilities 목록에 "Game Center"가 추가되었는지 확인
   - 체크박스가 활성화되어 있어야 함

7. **프로젝트 저장**
   - Cmd + S로 저장

8. **클린 빌드**
   - Product → Clean Build Folder (Shift + Cmd + K)
   - Product → Build (Cmd + B)

### 방법 2: 프로젝트 파일 직접 확인

만약 Xcode에서 추가했는데도 안 된다면:

1. **프로젝트 파일 확인**
   - `game.xcodeproj/project.pbxproj` 파일을 텍스트 에디터로 열기
   - `SystemCapabilities` 또는 `com.apple.GameCenter` 검색
   - 없으면 Xcode에서 제대로 추가되지 않은 것

2. **Xcode 재시작**
   - Xcode 완전 종료 후 다시 열기
   - 프로젝트 다시 열기
   - Capability 다시 추가 시도

### 방법 3: Archive 생성하여 확인

1. **Archive 생성**
   - Product → Archive
   - Archive가 성공적으로 생성되는지 확인

2. **Distribute App**
   - Archive 창에서 "Distribute App" 클릭
   - "App Store Connect" 선택
   - 업로드 시 Game Center 설정이 포함되는지 확인

## 확인 사항

### ✅ 이미 설정된 것들:
- `game/game.entitlements` 파일에 `com.apple.developer.game-center` 키가 있음
- `CODE_SIGN_ENTITLEMENTS` 경로가 올바르게 설정됨 (`game/game.entitlements`)
- `GameCenterResources.gamekit` 폴더가 있음

### ❌ 확인 필요한 것:
- Xcode 프로젝트 파일에 SystemCapabilities 섹션이 없음
- Xcode UI에서 Capability가 활성화되어 있는지 확인 필요

## 문제 해결 체크리스트

- [ ] Xcode에서 프로젝트 열기
- [ ] 프로젝트 → 타겟 → Signing & Capabilities 이동
- [ ] "+ Capability" → "Game Center" 추가
- [ ] Game Center가 Capabilities 목록에 체크되어 있는지 확인
- [ ] 프로젝트 저장 (Cmd + S)
- [ ] Clean Build Folder (Shift + Cmd + K)
- [ ] Build (Cmd + B)
- [ ] Archive 생성하여 테스트

## 추가 팁

### Apple Developer 계정 확인
- Xcode → Preferences → Accounts
- Apple Developer 계정이 등록되어 있는지 확인
- Development Team이 올바르게 설정되어 있는지 확인 (현재: 88J35QPT9J)

### App Store Connect에서 확인
- App Store Connect → 앱 선택
- "Game Center" 섹션 확인
- Game Center가 활성화되어 있는지 확인

## 여전히 안 된다면

1. **프로젝트 백업**
   - 프로젝트 전체를 백업

2. **Xcode 버전 확인**
   - 최신 Xcode 버전 사용 권장

3. **프로젝트 재생성**
   - 새 프로젝트 생성 후 파일 복사 (최후의 수단)

## 참고
- Entitlements 파일에는 이미 설정되어 있으므로, Xcode에서 Capability만 추가하면 됩니다
- Capability를 추가하면 프로젝트 파일이 자동으로 업데이트됩니다
