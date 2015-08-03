//
//  AppDelegate.swift
//  EALayoutLite
//
//  Created by splendourbell on 15/7/17.
//  Copyright (c) 2015年 easycoding. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        NSLog("\(UIScreen.mainScreen().bounds)")
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = ViewController()
        self.window!.makeKeyAndVisible()
        // Override point for customization after application launch.
        
        enableSkinDebug()
        return true
    }

    func enableSkinDebug()
    {
    #if DEBUG
        var debugWin = EADebugWindow.createDebugWindow()
        debugWin.hidden = false
        #if arch(i386) || arch(x86_64)
            debugWin.setSkinPath("Resources")
        #endif
    #endif
    }


}

