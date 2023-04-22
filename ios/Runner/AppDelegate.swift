import UIKit
import SwiftUI
import Flutter
import Dreacotdeliverylibagent

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, DreacotdeliverylibagentConnectionListenerProtocol {
    func onConnected() {
        print("connected")
    }
    
    func onConnectionEnded(_ willReconnect: Bool) {
        print("connection ended")
    }
    
    func onConnectionStarted() {
        print("connection started")
    }
    
    
    var agent: DreacotdeliverylibagentAgent?
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //   GeneratedPluginRegistrant.register(with: self)
      
      initDreacotdeliveryagent()
       do {
          try SingleInstance.shared.agent!.add(self, uniqueIdentifier: "\(self)")
      } catch {
          print(error.localizedDescription)
      }
      let controller = FlutterViewController(project: nil, nibName: nil, bundle: nil)
       self.window?.rootViewController = controller 
       let flutterchannel = FlutterMethodChannel(name:"androidtest2/firstpot",
                                              binaryMessenger: controller.binaryMessenger)
     
        flutterchannel.setMethodCallHandler({
         (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // This method is invoked on the UI thread.
        if call.method == "login" {
            self.connect(vc: nil)
         DispatchQueue.global(qos: .background).async {
            do {
                let user: DreacotdeliverylibagentUser = try (SingleInstance.shared.agent?.login("johndoe@gmail.com", password: "1234"))!
               var username=user.email
                result(username)
                // self.showToast(message: user.email, font: .systemFont(ofSize: 12.0))
                    
            } catch {
                result(FlutterError(code: "login error", message:error.localizedDescription as String, details:nil))
                print("\(error)")
            }
        }
       
        }else{
          print("got to ios platform but error occurred")
           result(FlutterMethodNotImplemented)
        }     
        })
        // for event channels===============================
      FlutterEventChannel(name: "androidtest2/firstpot/events", binaryMessenger: controller.binaryMessenger).setStreamHandler(
            colourchange()
            )

      GeneratedPluginRegistrant.register(with: self)
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

 func login(result: @escaping FlutterResult) {
       // DispatchQueue.global(qos: .background).async {
           // do {
              //  let user: DreacotdeliverylibagentUser = try (SingleInstance.shared.agent?.login("johndoe@gmail.com", password: "1234"))!
               // return result(String(user))
                // self.showToast(message: user.email, font: .systemFont(ofSize: 12.0))
                    
          //  }
         //   }
    }
}

public class SingleInstance {
    
    static var connected: Bool = false
    static var authenticated: Bool = false
    var agent: DreacotdeliverylibagentAgent?

    public class var shared: SingleInstance {
        struct Static {
            static let instance: SingleInstance = SingleInstance()
        }
        return Static.instance
    }
}

