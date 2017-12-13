//
//  NoticeViewController.swift
//  konsapo
//
//  Created by Yiu Cho Lam on 8/9/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit
import TBEmptyDataSet
import Alamofire
import SwiftyJSON

class NoticeViewController: UITableViewController {
	
//	var indexPath = IndexPath()
	var arrRes = [[String:AnyObject]]()
	var timer: Timer!
	
	func dateFormatter(_ timeStamp:Int) -> String{
		let timeInterval:TimeInterval = TimeInterval(timeStamp)
		let date = Date(timeIntervalSince1970: timeInterval)
		let dformatter = DateFormatter()
		dformatter.dateFormat = "yyyy/MM/dd"
		return dformatter.string(from: date)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrRes.filter({ (x) -> Bool in
			let timeStamp : Int = x["send_after"]! as! Int
			let timeInterval:TimeInterval = TimeInterval(timeStamp)
			let date = Date(timeIntervalSince1970: timeInterval)
			return x["canceled"] as! Bool == false && x["isIos"] as! Bool == true && ( date.compare(Date()) == .orderedAscending )
		}).count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "cell",
			for: indexPath)
		let jsonCell = self.arrRes.filter({ (x) -> Bool in
			let timeStamp : Int = x["send_after"]! as! Int
			let timeInterval:TimeInterval = TimeInterval(timeStamp)
			let date = Date(timeIntervalSince1970: timeInterval)
			return x["canceled"] as! Bool == false && x["isIos"] as! Bool == true && ( date.compare(Date()) == .orderedAscending )
		})[indexPath.row]
		let dict = jsonCell["contents"] as? NSDictionary
		cell.textLabel?.text = dict?.object(forKey: "en") as? String
//		let timeStamp : Int = jsonCell["send_after"]! as! Int
//		let timeInterval:TimeInterval = TimeInterval(timeStamp)
//		let date = Date(timeIntervalSince1970: timeInterval)
//		let dformatter = DateFormatter()
//		dformatter.dateFormat = "yyyy/MM/dd"
//		cell.detailTextLabel?.text = dformatter.string(from: date)
		cell.detailTextLabel?.text = self.dateFormatter(jsonCell["send_after"]! as! Int)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let jsonCell = self.arrRes.filter({ (x) -> Bool in
			let timeStamp : Int = x["send_after"]! as! Int
			let timeInterval:TimeInterval = TimeInterval(timeStamp)
			let date = Date(timeIntervalSince1970: timeInterval)
			return x["canceled"] as! Bool == false && x["isIos"] as! Bool == true && ( date.compare(Date()) == .orderedAscending )
		})[indexPath.row]
		let urlString  = jsonCell["url"] as! String
 		let controller = TOWebViewController()
		controller.url = URL(string: urlString)
		controller.buttonTintColor = UIColor.white
		controller.showUrlWhileLoading = false
		controller.loadingBarTintColor = UIColor.white
		controller.showUrlWhileLoading = false
		
		self.navigationController?.toolbar.barTintColor = UIColor("#F49AAF")
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		// Do any additional setup after loading the view.
		
		tableView.emptyDataSetDataSource = self
		tableView.emptyDataSetDelegate = self
		self.tableView.tableFooterView = UIView()
		self.refreshControl = UIRefreshControl()
		self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		self.refreshControl?.attributedTitle = NSAttributedString(string: "引っ張って更新")
//		self.loadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.loadData()
//		self.tabBarController?.navigationItem.title = self.tabBarItem.title
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func refreshData() {
		timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(NoticeViewController.endOfWork), userInfo: nil, repeats: true)
		
	}
	
	func endOfWork() {
		
		timer.invalidate()
		timer = nil
		self.loadData()
	}
	
	func loadData(){
		let password = "ZjllZWFkMTYtNmEwMy00ZGQxLWI5OTItNDg1YTU3ODgwMTYy"
//		let password = Bundle.main.object(forInfoDictionaryKey: "OneSignalSetting") as! String
		//		let credentialData = "authorization:\(password)".data(using: String.Encoding.utf8)!
		//		let base64Credentials = credentialData.base64EncodedString(options: [])
		let headers = ["Authorization": "Basic \(password)"]
		let requestURL = URL(string: "https://onesignal.com/api/v1/notifications?app_id=d5f14639-242c-421a-bc5f-76bf2841601e&limit=50&offset=0")
//		let mutableURLRequest = NSMutableURLRequest(url: URL(string: "https://onesignal.com/api/v1/notifications?app_id=d5f14639-242c-421a-bc5f-76bf2841601e&limit=50&offset=0")!)
//		mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
		
		Alamofire.request(requestURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate().responseJSON {
			response in
			
			switch response.result{
			case .success(let value):
				var jsonData = JSON(value)
				debugPrint("Total Count : \(jsonData["total_count"])")
				if let resData = jsonData["notifications"].arrayObject{
					self.arrRes = resData as! [[String:AnyObject]]
					debugPrint(self.arrRes)
					URLCache.shared.removeAllCachedResponses()
					DispatchQueue.main.async{
						self.tableView.reloadData()
						self.refreshControl?.endRefreshing()
					}
					
				}
				
				//					for temp in jsonData["notifications"].arrayValue{
				//						if temp["isIOS"].boolValue {
				//							debugPrint(temp["headings"]["en"])
				//							debugPrint(temp["contents"]["en"])
				//							debugPrint(temp["id"])
				//
				//						}
				//					}
				//					debugPrint(jsonData["notifications"][0]["id"])
				//					debugPrint(jsonData["notifications"][0]["isIos"])
				//					debugPrint(jsonData["notifications"][0]["headings"]["en"])
				//					debugPrint(jsonData["notifications"][0]["contents"]["en"])

			case .failure(let error):
				debugPrint(error)
				self.refreshControl?.endRefreshing()
			}
			
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

extension NoticeViewController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
	
	struct EmptyData {
//		static let images = [#imageLiteral(resourceName: "icon-empty-photos"), #imageLiteral(resourceName: "icon-empty-events"), #imageLiteral(resourceName: "icon-empty-message")]
//		static let titles = ["无照片", "无日程", "无新消息"]
//		static let descriptions = ["你可以添加一些照片哦，让生活更精彩！", "暂时没有日程哦，添加一些日程吧！", "没有新消息哦，去找朋友聊聊天吧!"]
		static let description = "お知らせはありません"
		static let title = "お知らせ"
	}
	// MARK: - TBEmptyDataSet data source
	func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
		return nil;
	}
	
	func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
		let title = EmptyData.title
//		let attributes: [NSAttributedStringKey: Any]?
//		if indexPath.row == 1 {
//			attributes = [.: UIFont.systemFont(ofSize: 22),
//			              .foregroundColor: UIColor.gray]
//		} else if indexPath.row == 2 {
//			attributes = [.font: UIFont.systemFont(ofSize: 24),
//			              .foregroundColor: UIColor.gray]
//		}
		return NSAttributedString(string: title, attributes: nil)
	}
	
	func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
		let description = EmptyData.description
//		let attributes: [NSAttributedStringKey: Any]?
//		if indexPath.row == 1 {
//			attributes = [.font: UIFont.systemFont(ofSize: 17),
//			              .foregroundColor: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
//		} else if indexPath.row == 2 {
//			attributes = [.font: UIFont.systemFont(ofSize: 18),
//			              .foregroundColor: UIColor.purple]
//		}
		return NSAttributedString(string: description, attributes: nil)
	}
	
	func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
		if let navigationBar = navigationController?.navigationBar {
			return -navigationBar.frame.height * 0.75
		}
		return 0
	}
	
	func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
		return [25, 8]
	}
	
	func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
//		if isLoading {
//			let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//			activityIndicator.startAnimating()
//			return activityIndicator
//		}
		return nil
	}
	
	// MARK: - TBEmptyDataSet delegate
	func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
		return true
	}
	
	func emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool {
		return true
	}
	
	func emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool {
		return true
	}
	
	func emptyDataSetDidTapEmptyView(in scrollView: UIScrollView) {
		/*let alert = UIAlertController(title: nil, message: "Did Tap EmptyDataView!", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)*/
	}
	
	func emptyDataSetWillAppear(in scrollView: UIScrollView) {
//		print("EmptyDataSet Will Appear!")
	}
	
	func emptyDataSetDidAppear(in scrollView: UIScrollView) {
//		print("EmptyDataSet Did Appear!")
	}
	
	func emptyDataSetWillDisappear(in scrollView: UIScrollView) {
//		print("EmptyDataSet Will Disappear!")
	}
	
	func emptyDataSetDidDisappear(in scrollView: UIScrollView) {
//		print("EmptyDataSet Did Disappear!")
	}
}
