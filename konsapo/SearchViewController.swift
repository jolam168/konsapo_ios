//
//  SearchViewController.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 8/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit

class SearchViewController: WebBaseViewController,BaseTabBarDelegate {

	var targetURL : String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let base = self.tabBarController as! BaseTabBarViewController
		base.searchDelegate = self
		
		if let filePath = Bundle.main.path(forResource: "Environment", ofType: "plist"){
			if let dictRoot = NSDictionary(contentsOfFile: filePath){
//				let rootUrl = dictRoot["RootUrl"] as! String
				let extUrl = dictRoot["SearchUrl"] as! String
				targetURL = extUrl
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
		let req = URLRequest(url: URL(string: targetURL)!)
		webView.load(req)
		
	}
	
	func tabBarSelected(viewControllerName: String) {
		let v = String(describing: self)
		let currentURL = webView.url?.absoluteString
		if (v == viewControllerName && currentURL != targetURL){
			loadAddressURL()
		}else if currentURL == targetURL{
//			webView.scrollView.setContentOffset(CGPoint(x: 0.0, y:  -scrollToTop ), animated: true)
			webView.reload()
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
