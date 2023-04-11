import UIKit
import Flutter
import Dreacotdeliverylibagent

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, DreacotdeliverylibagentConnectionListenerProtocol {
    func onConnected() {

    }
    
    func onConnectionEnded(_ willReconnect: Bool) {
        
    }
    
    func onConnectionStarted() {
        
    }
    
    
    var agent: DreacotdeliverylibagentAgent?
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      initDreacotdeliveryagent()
       let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
       let flutter_Mchannel = FlutterMethodChannel(name: "androidtest2/firstpot",
                                              binaryMessenger: controller.binaryMessenger)
      do {
          try SingleInstance.shared.agent!.add(self, uniqueIdentifier: "\(self)")
      } catch {
          print(error.localizedDescription)
      }
        flutter_Mchannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        // This method is invoked on the UI thread.
        guard call.method == "login" else {
            result(FlutterMethodNotImplemented)
            return
        }
        self?.login(result:result)
        })

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
func initDreacotdeliveryagent() {
    let appDataDir = NSHomeDirectory() + "/Documents/dreacotdeliverylibagent"
    var initError: NSError?
    
    agent = DreacotdeliverylibagentNewDreacotDeliveryAgent(appDataDir, &initError)
    
    if initError != nil{
        print(initError!)
        return
    }
    SingleInstance.shared.agent = agent
}

func connect(vc: UIViewController?, completion: ((Bool) -> Void)? = nil) {
    print("connect function")
    DispatchQueue.global(qos: .background).async {
        do {
            if !SingleInstance.shared.agent!.isConnected() {
                try SingleInstance.shared.agent?.connect("178.79.143.134:6061")
                SingleInstance.connected = true
                SingleInstance.authenticated = true
            } else {
                SingleInstance.connected = true
            }
        } catch {
            DispatchQueue.main.async {
                completion?(false)
            }
            print("cannot connect \(error)")
        }
    }
}

 func login(result: FlutterResult) {
        DispatchQueue.global(qos: .background).async {
            do {
                let user: DreacotdeliverylibagentUser = try (SingleInstance.shared.agent?.login("johndoe@gmail.com", password: "1234"))!
                return result(user)
                // self.showToast(message: user.email, font: .systemFont(ofSize: 12.0))
                    
            } catch {
                print("\(error)")
            }
        }
    }
}
