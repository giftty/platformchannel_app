//
//  SingleInstance.swift
//  frameworktest
//
//  Created by Kennedy Izuegbu on 07/04/2023.
//

import Foundation
import Dreacotdeliverylibagent

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

