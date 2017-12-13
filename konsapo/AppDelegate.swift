//
//  AppDelegate.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 1/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	let serverBaseUrl = "konkatsu10.com"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		   Fabric.with([Crashlytics.self])
			restoreCookies()
		
		
		let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
		
		// Replace 'YOUR_APP_ID' with your OneSignal App ID.
		OneSignal.initWithLaunchOptions(launchOptions,
		                                appId: "d5f14639-242c-421a-bc5f-76bf2841601e",
		                                handleNotificationAction: nil,
		                                settings: onesignalInitSettings)
		
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
		
		// Recommend moving the below line to prompt for push after informing the user about
		//   how your app will use them.
		OneSignal.promptForPushNotifications(userResponse: { accepted in
			print("User accepted notifications: \(accepted)")
		})
		
		// Sync hashed email if you have a login system or collect it.
		//   Will be used to reach the user at the most optimal time of day.
		// OneSignal.syncHashedEmail(userEmail)
		
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		storeCookies()
		UserDefaults.standard.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
		ReachabilityManager.shared?.startListening()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		ReachabilityManager.shared?.stopListening()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		storeCookies()
		UserDefaults.standard.synchronize();
    }
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		
		
		// Print full message.
		print(userInfo)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		
		completionHandler(UIBackgroundFetchResult.newData)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Unable to register for remote notifications: \(error.localizedDescription)")
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
		print("APNs token retrieved: \(token)")
	}
	
	func storeCookies() {
		let cookiesStorage = HTTPCookieStorage.shared
		let userDefaults = UserDefaults.standard
		
		let serverBaseUrl = self.serverBaseUrl
		var cookieDict = [String : AnyObject]()
		
		for cookie in cookiesStorage.cookies(for: NSURL(string: serverBaseUrl)! as URL)! {
			cookieDict[cookie.name] = cookie.properties as AnyObject?
		}
		
		userDefaults.set(cookieDict, forKey: "cookiesKey")
		
	}

	
	func restoreCookies() {
		let cookiesStorage = HTTPCookieStorage.shared
		let userDefaults = UserDefaults.standard
		
		if let cookieDictionary = userDefaults.dictionary(forKey: "cookiesKey") {
			
			for (_, cookieProperties) in cookieDictionary {
				if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
					cookiesStorage.setCookie(cookie)
				}
			}
		}
	}
/*
	func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
		let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
		let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
		if (updatedBadgeNumber > -1) {
			UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
		}
	}
*/

}



