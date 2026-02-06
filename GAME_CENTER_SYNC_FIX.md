# Game Center Resources 동기화 문제 해결

## 문제
App Store Connect에서 Pull을 했는데 GameCenterResources 화면에 변경이 없음

## 원인
- App Store Connect에서 Game Center가 활성화되지 않았거나
- Xcode에서 Game Center Capability가 제대로 추가되지 않았거나
- 동기화가 완료되지 않았을 수 있습니다

## 해결 방법

### 1단계: App Store Connect에서 Game Center 활성화 확인

1. **App Store Connect 로그인**
   - https://appstoreconnect.apple.com 접속

2. **앱 선택**
   - 앱 목록에서 해당 앱 선택

3. **Game Center 섹션 확인**
   - 왼쪽 메뉴에서 "Game Center" 클릭
   - 또는 "앱 정보" → "Game Center" 섹션 확인

4. **Game Center 활성화**
   - "Game Center 활성화" 버튼이 있다면 클릭
   - 이미 활성화되어 있다면 확인

5. **Leaderboards/Achievements 설정 (선택사항)**
   - Game Center를 사용하려면 Leaderboards나 Achievements를 설정해야 할 수 있습니다
   - 하지만 기본적으로 Game Center만 활성화하면 됩니다

### 2단계: Xcode에서 Game Center Capability 확인 및 추가

1. **Xcode에서 프로젝트 열기**

2. **프로젝트 → 타겟 → Signing & Capabilities**

3. **Game Center Capability 확인**
   - Capabilities 목록에 "Game Center"가 있는지 확인
   - 체크박스가 활성화되어 있는지 확인

4. **없다면 추가**
   - "+ Capability" 버튼 클릭
   - "Game Center" 검색 후 추가

5. **프로젝트 저장**
   - Cmd + S로 저장

### 3단계: Xcode에서 Game Center Resources 동기화

1. **Game Center Resources 화면 열기**
   - Xcode에서 프로젝트 선택
   - 타겟 선택
   - "Signing & Capabilities" 탭
   - "Game Center" 섹션 확장
   - "Game Center Resources" 클릭

2. **Pull from App Store Connect**
   - Game Center Resources 화면에서
   - "Pull from App Store Connect" 버튼 클릭
   - 또는 상단 메뉴에서 동기화

3. **Apple Developer 계정 확인**
   - Xcode → Preferences → Accounts
   - Apple Developer 계정이 등록되어 있는지 확인
   - 올바른 계정으로 로그인되어 있는지 확인

### 4단계: 수동 동기화 시도

1. **Xcode 완전 종료**

2. **프로젝트 재열기**

3. **Game Center Resources 다시 확인**
   - Signing & Capabilities → Game Center → Game Center Resources

4. **Pull 다시 시도**

### 5단계: Game Center Resources 파일 확인

현재 `GameCenterResources.gamekit/gameCenterResources.json` 파일:
```json
{
  "meta" : {
    "version" : "2024-11-15"
  },
  "resources" : {
    // 비어있음 - 정상일 수 있음
  }
}
```

**참고:**
- `resources`가 비어있는 것은 정상일 수 있습니다
- Game Center를 활성화했지만 Leaderboards나 Achievements를 설정하지 않았다면 비어있을 수 있습니다
- Game Center Capability만 활성화하면 `resources`는 비어있어도 됩니다

## 중요 확인 사항

### ✅ Game Center가 작동하는지 확인하는 방법:

1. **Entitlements 파일 확인**
   - `game/game.entitlements` 파일에 `com.apple.developer.game-center` 키가 있으면 OK

2. **코드에서 테스트**
   ```swift
   import GameKit
   
   func checkGameCenter() {
       let localPlayer = GKLocalPlayer.local
       localPlayer.authenticateHandler = { viewController, error in
           if localPlayer.isAuthenticated {
               print("Game Center 활성화됨")
           }
       }
   }
   ```

3. **Archive 생성 테스트**
   - Product → Archive
   - Archive가 성공적으로 생성되면 Game Center 설정이 올바른 것입니다

## App Store Connect 심사 제출

### Game Center Resources가 비어있어도 제출 가능한가?

**답: 네, 가능합니다!**

- Game Center Capability가 활성화되어 있고
- Entitlements 파일에 키가 있으면
- `resources`가 비어있어도 심사 제출이 가능합니다

### 심사 제출을 위한 최소 요구사항:

1. ✅ `game.entitlements`에 `com.apple.developer.game-center` 키 있음
2. ✅ Xcode에서 Game Center Capability 추가됨
3. ✅ App Store Connect에서 Game Center 활성화됨

**Game Center Resources의 `resources`가 비어있어도 문제없습니다!**

## 문제 해결 체크리스트

- [ ] App Store Connect에서 Game Center 활성화 확인
- [ ] Xcode에서 Game Center Capability 추가 확인
- [ ] Apple Developer 계정 로그인 확인
- [ ] Xcode에서 Pull from App Store Connect 시도
- [ ] Archive 생성 테스트
- [ ] Entitlements 파일 확인

## 여전히 안 된다면

1. **Game Center를 사용하지 않는다면**
   - Game Center Capability를 제거해도 됩니다
   - Entitlements 파일에서도 제거 가능

2. **Game Center를 사용하려면**
   - App Store Connect에서 Game Center가 활성화되어 있는지 다시 확인
   - Xcode를 재시작하고 다시 시도

3. **최종 확인**
   - Archive를 생성하여 업로드
   - App Store Connect에서 빌드가 업로드되면 Game Center 설정이 올바른 것입니다
