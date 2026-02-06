# Game Center 설정 가이드

## 현재 상태
✅ `game.entitlements` 파일에 Game Center 권한이 이미 설정되어 있습니다:
```xml
<key>com.apple.developer.game-center</key>
<true/>
```

## Xcode에서 Game Center 활성화하기

### 방법 1: Xcode UI를 통한 설정 (권장)

1. **Xcode에서 프로젝트 열기**
   - `game.xcodeproj` 파일을 Xcode에서 엽니다

2. **프로젝트 네비게이터에서 프로젝트 선택**
   - 왼쪽 사이드바에서 최상단의 "game" 프로젝트를 클릭합니다

3. **타겟 선택**
   - 중앙 영역에서 "game" 타겟을 선택합니다

4. **Signing & Capabilities 탭 선택**
   - 상단 탭에서 "Signing & Capabilities"를 클릭합니다

5. **Capability 추가**
   - 왼쪽 상단의 "+ Capability" 버튼을 클릭합니다
   - 검색창에 "Game Center"를 입력합니다
   - "Game Center"를 선택하여 추가합니다

6. **확인**
   - Capabilities 목록에 "Game Center"가 추가되었는지 확인합니다
   - 체크박스가 활성화되어 있어야 합니다

### 방법 2: 이미 설정되어 있는 경우

현재 `game.entitlements` 파일에 이미 Game Center 권한이 설정되어 있으므로, 
Xcode에서 Capabilities 탭을 확인하면 이미 활성화되어 있을 수 있습니다.

만약 여전히 오류가 발생한다면:

1. **프로젝트 클린**
   - Xcode 메뉴: Product → Clean Build Folder (Shift + Cmd + K)

2. **프로젝트 재빌드**
   - Xcode 메뉴: Product → Build (Cmd + B)

3. **Xcode 재시작**
   - Xcode를 완전히 종료한 후 다시 열어보세요

## 추가 확인 사항

### 1. Apple Developer 계정 설정
- Xcode → Preferences → Accounts에서 Apple Developer 계정이 등록되어 있어야 합니다
- Development Team이 설정되어 있어야 합니다 (현재: 88J35QPT9J)

### 2. Bundle Identifier 확인
- 현재 Bundle ID: `com.googsu.game`
- App Store Connect에서 이 Bundle ID로 앱을 등록해야 합니다

### 3. Game Center 설정 (App Store Connect)
- [App Store Connect](https://appstoreconnect.apple.com)에 로그인
- 앱을 선택하고 "Game Center" 섹션으로 이동
- Game Center를 활성화합니다

## 코드에서 Game Center 사용하기

Game Center를 사용하려면 다음 코드를 추가할 수 있습니다:

```swift
import GameKit

// Game Center 인증
func authenticatePlayer() {
    let localPlayer = GKLocalPlayer.local
    
    localPlayer.authenticateHandler = { viewController, error in
        if let viewController = viewController {
            // 로그인 화면 표시
            // self.present(viewController, animated: true)
        } else if localPlayer.isAuthenticated {
            // 인증 성공
            print("Game Center 인증 성공")
        } else {
            // 인증 실패
            print("Game Center 인증 실패")
        }
    }
}
```

## 문제 해결

### 오류: "com.apple.developer.game-center 권한을 추가해야 합니다"

이 오류가 계속 발생한다면:

1. **Entitlements 파일 경로 확인**
   - 프로젝트 설정에서 `CODE_SIGN_ENTITLEMENTS`가 올바르게 설정되어 있는지 확인
   - 현재: `game/game.entitlements` ✅

2. **수동으로 Capability 추가**
   - Xcode UI를 통해 Game Center Capability를 다시 추가해보세요

3. **프로젝트 파일 확인**
   - `project.pbxproj` 파일에서 Game Center 관련 설정이 있는지 확인

## 참고 자료
- [Apple Developer - Game Center](https://developer.apple.com/documentation/gamekit)
- [Game Center Programming Guide](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/GameKit_Guide/)
