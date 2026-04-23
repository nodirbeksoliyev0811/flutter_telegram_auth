import Flutter
import UIKit
#if canImport(TelegramLogin)
import TelegramLogin
#endif

public class FlutterTelegramAuthPlugin: NSObject, FlutterPlugin {
  private var expectedHost: String?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_telegram_auth", binaryMessenger: registrar.messenger())
    let instance = FlutterTelegramAuthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    #if canImport(TelegramLogin)
    switch call.method {
    case "init":
      guard let args = call.arguments as? [String: Any],
            let clientId = args["clientId"] as? String,
            let redirectUri = args["redirectUri"] as? String else {
        result(FlutterError(code: "INVALID_ARG", message: "Missing arguments", details: nil))
        return
      }
      
      let scopes = args["scopes"] as? [String] ?? ["profile", "phone"]
      self.expectedHost = URL(string: redirectUri)?.host
      
      TelegramLogin.configure(clientId: clientId, redirectUri: redirectUri, scopes: scopes)
      result(nil)
      
    case "login":
      TelegramLogin.login { authResult in
        switch authResult {
        case .success(let loginData):
          result(loginData.idToken)
        case .failure(let error):
          result(FlutterError(code: "AUTH_ERROR", message: error.localizedDescription, details: nil))
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
    #else
    result(FlutterError(code: "NOT_INSTALLED", message: "TelegramLogin framework not found. Please install the SPM package in your iOS project.", details: nil))
    #endif
  }

  public func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    #if canImport(TelegramLogin)
    if url.host == expectedHost {
      TelegramLogin.handle(url)
      return true
    }
    #endif
    return false
  }
}
