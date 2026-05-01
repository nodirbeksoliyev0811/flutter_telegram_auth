## 0.1.3

* **iOS Fix**: Resolved Swift concurrency build errors (`ActorIsolatedCall`) by marking the plugin as `@MainActor`.

## 0.1.2

* **iOS Fix**: Embedded the `TelegramLogin` source code directly into the plugin. This removes the external Swift Package Manager (SPM) requirement and fixes dependency resolution issues on all Flutter and CocoaPods versions.
* **Simplification**: iOS setup is now fully automatic (no more manual "Add Packages" step in Xcode).
* **Doctor Tool**: Updated the diagnostic tool to reflect the self-contained iOS architecture.

## 0.1.1

* **Improvement**: Refined the diagnostic `doctor` tool to detect missing iOS Swift Package Manager (SPM) dependencies.
* **Documentation**: Enhanced README instructions for iOS setup in Xcode.
* **Maintenance**: Minor internal improvements and version bump.

## 0.1.0

* **New Feature**: Added complete support for **Flutter Web** using a secure popup window approach.
* **Diagnostic Tool**: Introduced `dart run flutter_telegram_auth:doctor` to help developers verify their platform-specific configurations (Manifest, Info.plist, etc.) automatically.
* **Platform Updates**: Added Swift Package Manager (SPM) support for iOS to comply with new pub.dev platform requirements (160/160 pub points).
* **Documentation**: Updated `README.md` with comprehensive web integration instructions and a cleaner, more focused setup guide.

## 0.0.9

* Enhanced Telegram app discovery on Android by adding intent-based queries and expanding package visibility.
* Fixed edge cases where the SDK would fallback to the browser even when Telegram was installed.
* Updated documentation with troubleshooting tips for App Links and SHA-256 fingerprint verification.

## 0.0.8

* Fixed `login-sdk.aar` resolution issue when the plugin is used as a dependency in other projects.
* Improved Android build configuration by implementing `rootProject` repository injection for seamless AAR discovery.
* Updated documentation and example app to reflect the latest stable build.

## 0.0.7

* Fixed `login-sdk.aar` resolution issue when the plugin is used as a dependency in other projects.

## 0.0.6

* Fixed Gradle build error (NullPointerException) in host applications by restoring `android/build.gradle`.
* Improved Android build configuration for better compatibility with AGP 8+.

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
