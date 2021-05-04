//
//  AppDelegate.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/10/21.
//

import UIKit
import MapperNativeSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    public let mapperSDK = MapperSDK.initialize()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:])
    -> Bool {
        guard let scheme = url.scheme, scheme == "ups" else {
            return false
        }
        
        guard let host = url.host, host == "halyk" else {
            return false
        }
        
        var notification: Notification = .identificationSucceeded
        notification.object = url

        NotificationCenter.default.post(notification)
        return true
    }
}

extension Notification.Name {
    static let identificationSucceeded = Notification.Name("identificationSucceeded")
}

extension Notification {
    static let identificationSucceeded = Notification(name: .identificationSucceeded)
}
