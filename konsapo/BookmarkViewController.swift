//
//  BookmarkViewController.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 8/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit

class BookmarkViewController: WebBaseViewController {

	var targetURL : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if let filePath = Bundle.main.path(forResource: "Environment", ofType: "plist"){
			if let dictRoot = NSDictionary(contentsOfFile: filePath){
				let rootUrl = dictRoot["RootUrl"] as! String
				let extUrl = dictRoot["BookmarkUrl"] as! String
				targetURL = rootUrl + extUrl
			}
		}
		
		
		webView.uiDelegate = self;
//		webView.scrollView.delegate = self;
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

	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
