import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var navigationController: UINavigationController!

     override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        let controller = self.window.rootViewController as! FlutterViewController
        linkNativeCode(controller: controller)
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {

    func linkNativeCode(controller: FlutterViewController) {
        nativeMethod(controller: controller)
    }

    private func nativeMethod(controller: FlutterViewController) {

        let nativeMethod = FlutterMethodChannel.init(name: "com.example.test_project/native", binaryMessenger: controller as! FlutterBinaryMessenger)

        nativeMethod.setMethodCallHandler { (call, result) in
          print("nativeLog", "this method is running")
          print("nativeLog", "method name:" + call.method)
          result(502)
        }
    }
}
