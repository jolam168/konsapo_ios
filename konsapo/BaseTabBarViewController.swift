//
//  BaseTabBarViewController.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 22/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit
protocol BaseTabBarDelegate: class {
	func tabBarSelected(viewControllerName : String)

}

class BaseTabBarViewController: UITabBarController,UITabBarControllerDelegate {

	var baseDelegate:BaseTabBarDelegate?
	var searchDelegate:BaseTabBarDelegate?
	var newsDelegate:BaseTabBarDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.delegate = self
        self.navigationItem.title = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
		self.navigationController?.navigationBar.titleTextAttributes =  [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName:UIColor.white]
        // Do any additional setup after loading the view.

    }
	override func viewWillAppear(_ animated: Bool) {
//		if let barItem = tabBar.items {
//			let value = UIApplication.shared.applicationIconBadgeNumber
//			if value > 0 {
//				barItem[3].badgeValue = String(value)
//			}
//		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
	}

	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		print(String(describing: viewController.self))
		let index = tabBarController.viewControllers?.index(of: viewController)
		if (index == 0) {
			baseDelegate?.tabBarSelected(viewControllerName: String(describing: viewController.self))
		}else if(index == 1){
			searchDelegate?.tabBarSelected(viewControllerName: String(describing: viewController.self))
		}else if(index == 2){
			newsDelegate?.tabBarSelected(viewControllerName: String(describing: viewController.self))
		}
		
	}
	
    func titleView() -> UIView {
        let title = UIView()
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView.init(image: UIImage.init(named: "AppIcon"))
        
        let label = UILabel()
        label.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .red
        
        let views = ["icon" : icon, "label" : label]
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
            title.addSubview(view)
        }
        title.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[icon]-[label]-|", options: .alignAllTop, metrics: nil, views: views))
        title.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[icon]-|", options: .alignAllTop, metrics: nil, views: views))
        title.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: .alignAllTop, metrics: nil, views: views))
        
        return title
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
