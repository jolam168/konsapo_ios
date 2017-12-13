//
//  ViewController.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 1/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit

class ViewController: BaseViewController,BaseTabBarDelegate {
	
	
	
	var targetURL : String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
		let base = self.tabBarController as! BaseTabBarViewController
		base.baseDelegate = self
		
       if let filePath = Bundle.main.path(forResource: "Environment", ofType: "plist"){
		if let dictRoot = NSDictionary(contentsOfFile: filePath){
			targetURL = dictRoot["RootUrl"] as! String
			}
        }
        
        webView.uiDelegate = self;
		webView.navigationDelegate = self;
		webView.scrollView.delegate = self;
		
		loadAddressURL()
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
    }
	
    func loadAddressURL() {
		loadCookies()
		SVProgressHUD.show()
        let req = URLRequest(url: URL(string: targetURL)!)
		webView.load(req)
    }
	
	func tabBarSelected(viewControllerName: String) {
		let v = String(describing: self)
		print(v)
		if v == viewControllerName{
			loadAddressURL()
		}
	}
}

