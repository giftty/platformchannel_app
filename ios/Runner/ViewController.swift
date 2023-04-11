//
//  ViewController.swift
//  frameworktest
//
//  Created by Kennedy Izuegbu on 06/04/2023.
//

import UIKit
import Dreacotdeliverylibagent

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.connect()
    }
    
    func showToast(message : String, font: UIFont) {
        DispatchQueue.main.async {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 2, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.login()
    }
    
    func login() {
        DispatchQueue.global(qos: .background).async {
            do {
                let user: DreacotdeliverylibagentUser = try (SingleInstance.shared.agent?.login("johndoe@gmail.com", password: "1234"))!
                
                self.showToast(message: user.email, font: .systemFont(ofSize: 12.0))
                    
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func connect() {
        AppDelegate.shared.connect(vc: self) { result in
            if !result {
                print("Failed to establish a connection to the server")
            }
        }
    }


}

