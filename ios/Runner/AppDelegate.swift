import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "uni_app/channel", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call, result) in
            if call.method == "getInstalledApps" {
                self.getInstalledApps(result: result)
            } else if call.method == "uninstallApp" {
                if let args = call.arguments as? [String: Any], let packageName = args["packageName"] as? String {
                    self.uninstallApp(packageName: packageName, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Package name is null", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getInstalledApps(result: FlutterResult) {
        // iOS'ta uygulama listesine erişim mümkün değildir.
        // Bu nedenle, simüle edilmiş bir liste dönebilirsiniz.
        let apps = [
            [
                "name": "App 1",
                "iconPath": "",
                "size": "10MB",
                "lastUsed": "2023-10-01T00:00:00Z",
                "packageName": "com.example.app1"
            ],
            [
                "name": "App 2",
                "iconPath": "",
                "size": "20MB",
                "lastUsed": "2023-10-01T00:00:00Z",
                "packageName": "com.example.app2"
            ]
        ]
        result(apps)
    }
    
    private func uninstallApp(packageName: String, result: FlutterResult) {
        // iOS'ta uygulama kaldırma işlemi mümkün değildir.
        // Bu nedenle, bu işlemi simüle edebilirsiniz.
        print("Simulated uninstall for package: \(packageName)")
        result(nil)
    }
}