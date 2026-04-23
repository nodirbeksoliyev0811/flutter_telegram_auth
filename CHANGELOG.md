## 0.0.5

* Added `photoUri` getter to `TelegramUser` model.
* Added `isTokenExpired()` utility method to check token validity.
* Cleaned up documentation and updated dependency versions in README.

## 0.0.4

* Added `getLocalUserFromToken()` utility method to easily decode the JWT payload in Dart without backend logic.

## 0.0.3

* Fixed iOS Universal Links support (`continueUserActivity`).
* Improved README.md documentation with clickable URLs and explicit platform support badges.

## 0.0.2

* Bundled Android `login-sdk.aar` directly into the plugin to remove the requirement for GitHub Packages authentication.
* Simplified Android App Links intent-filter for better compatibility with strict Android versions (like Xiaomi/MIUI).
* Cleaned up README.md instructions.

## 0.0.1

* Initial release.
* Support for Android Native Telegram Login.
* Support for iOS Native Telegram Login.
