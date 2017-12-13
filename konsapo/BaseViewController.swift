//
//  BaseViewController.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 2/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController{
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//self.tabBarController?.navigationItem.title = self.tabBarItem.title

	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
}

