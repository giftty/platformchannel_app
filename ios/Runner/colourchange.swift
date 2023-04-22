//
//  File.swift

class colourchange: NSObject, FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
       
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            let randomNumber = Int.random(in: 1...20)
           let number = Int.random(in:222222...888888)
           
            events(number)
//            if randomNumber == 10 {
//                timer.invalidate()
//                return
//            }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
