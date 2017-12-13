//
//  NotificationViewController.swift
//  NotificationExtension
//
//  Created by Yiu Cho Lam on 18/10/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

	
	@IBOutlet weak var imageView: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
		if let attachment = notification.request.content.attachments.first {
			if attachment.url.startAccessingSecurityScopedResource() {
				if let data = NSData(contentsOfFile: attachment.url.path) as Data? {
					self.imageView.image = UIImage(data: data)
					attachment.url.stopAccessingSecurityScopedResource()
				}
			}
		}
		
    }

}
