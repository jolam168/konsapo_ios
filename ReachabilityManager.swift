//
//  ReachabilityManager.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 5/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit
import Alamofire

class ReachabilityManager: NSObject {

	static let shared = NetworkReachabilityManager()
	
	var isNetworkAvailable : Bool {
		return reachabilityStatus != .notReachable
	}
	
	var reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .notReachable
	
	let reachability = NetworkReachabilityManager()!
	
	func reachabilityChanged(notification: Notification) {
		let reachability = notification.object as! NetworkReachabilityManager
		switch reachability.networkReachabilityStatus {
		case .notReachable:
			debugPrint("Network became unreachable")
		case .reachable(.ethernetOrWiFi):
			debugPrint("Network reachable through WiFi")
		case .reachable(.wwan):
			debugPrint("Network reachable through Cellular Data")
		case .unknown:
			debugPrint("It is unknown whether the network is reachable")
		}
		
	}
	
	func startMonitoring() {
			reachability.startListening()
	}
	
	func stopMonitoring(){
		reachability.stopListening()
	}

}
