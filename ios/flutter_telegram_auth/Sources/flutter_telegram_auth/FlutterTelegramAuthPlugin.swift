import Flutter
import UIKit

@MainActor
public class FlutterTelegramAuthPlugin: NSObject, FlutterPlugin {
  private var expectedHost: String?

  @MainActor
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_telegram_auth", binaryMessenger: registrar.messenger())
    let instance = FlutterTelegramAuthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
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
  }

  public func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if url.host == expectedHost {
      TelegramLogin.handle(url)
      return true
    }
    return false
  }

  public func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([Any]) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL,
       url.host == expectedHost {
      TelegramLogin.handle(url)
      return true
    }
    return false
  }
}
