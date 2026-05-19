import Flutter
import UIKit
import SafariServices
import AuthenticationServices

public class SwiftTwitterLoginPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding  {
    var session: Any? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "twitter_login/auth_browser",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftTwitterLoginPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "authentication":
                authentication(call, result: result)
            default:
                result(nil)
                return
        }
    }

    public func authentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? NSDictionary,
              let urlString = args["url"] as? String,
              let authURL = URL(string: urlString) else {
            result(FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or invalid url for authentication",
                details: nil
            ))
            return
        }
        let urlScheme = args["redirectURL"] as? String

        // iOS12以降
        if #available(iOS 12.0, *) {
            var authSession: ASWebAuthenticationSession?
            authSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: urlScheme
            ) { url, _ in
                result(url?.absoluteString)
                authSession?.cancel()
                self.session = nil
            }
            self.session = authSession
            if #available(iOS 13.0, *) {
                authSession?.presentationContextProvider = self
            }
            guard authSession?.start() == true else {
                self.session = nil
                result(FlutterError(
                    code: "AUTH_SESSION_START_FAILED",
                    message: "Failed to start ASWebAuthenticationSession",
                    details: nil
                ))
                return
            }
        // iOS11のみ
        } else if #available(iOS 11.0, *) {
            var authSession: SFAuthenticationSession?
            authSession = SFAuthenticationSession(
                url: authURL,
                callbackURLScheme: urlScheme
            ) { url, _ in
                result(url?.absoluteString)
                authSession?.cancel()
                self.session = nil
            }
            self.session = authSession
            guard authSession?.start() == true else {
                self.session = nil
                result(FlutterError(
                    code: "AUTH_SESSION_START_FAILED",
                    message: "Failed to start SFAuthenticationSession",
                    details: nil
                ))
                return
            }
        } else {
            // iOS10以前は未対応
            result("")
            return
        }
    }

    private static func presentationWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .sorted { lhs, rhs in
                    let lhsActive = lhs.activationState == .foregroundActive
                    let rhsActive = rhs.activationState == .foregroundActive
                    if lhsActive != rhsActive { return lhsActive }
                    return false
                }
            for scene in scenes {
                if let window = scene.windows.first(where: { $0.isKeyWindow }) {
                    return window
                }
                if let window = scene.windows.first {
                    return window
                }
            }
        }
        if let window = UIApplication.shared.delegate?.window ?? nil {
            return window
        }
        if let window = UIApplication.shared.keyWindow {
            return window
        }
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            ?? UIApplication.shared.windows.first
    }

    @available(iOS 12.0, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let window = Self.presentationWindow() else {
            fatalError("No window available for ASWebAuthenticationSession presentation.")
        }
        return window
    }
}
