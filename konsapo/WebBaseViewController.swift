//
//  WebBaseViewController.swift
//  konkatsuten
//
//  Created by Yiu Cho Lam on 19/10/2017.
//  Copyright © 2017年 Yiu Cho Lam. All rights reserved.
//

import UIKit
import LKAlertController
import WebKit
import SafariServices
import UIColor_Hex_Swift

class WebBaseViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,SFSafariViewControllerDelegate {
	
	
	//	@IBOutlet weak var webView: UIWebView!
	
	var webView : WKWebView!
	var progressView : UIProgressView!
	var scrollToTop : CGFloat = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		scrollToTop = (self.navigationController?.navigationBar.frame.size.height)!-UIApplication.shared.statusBarFrame.size.height;
		
		progressView = UIProgressView(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height - 2, width: self.view.frame.size.width, height: 10))
		progressView.progressViewStyle = .bar
		self.navigationController?.navigationBar.addSubview(progressView)
		
		
		let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
		let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		let wkUController = WKUserContentController()
		wkUController.addUserScript(userScript)
		if let cookies = HTTPCookieStorage.shared.cookies{
			print("viewDidLoad :\(cookies)")
			let script = getJSCookiesString(cookies: cookies)
			let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
			wkUController.addUserScript(cookieScript)
		}
		let wkWebConfig = WKWebViewConfiguration()
		wkWebConfig.processPool = WKProcessPool()
		wkWebConfig.userContentController = wkUController
		
		self.webView = WKWebView(frame: self.view.bounds, configuration: wkWebConfig)
		self.webView.scrollView.showsHorizontalScrollIndicator = false
		self.view = self.webView
		self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
		
		
		//        checkNetworkConntectivity()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//		let cookies = HTTPCookieStorage.shared.cookies
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setUp(){
		
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return nil
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
			scrollView.contentOffset.x = 0
		}
	}
	
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		self.progressView.isHidden = false
		
	}
	
	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		self.progressView.isHidden = true
	}
	
	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let method = challenge.protectionSpace.authenticationMethod
		if method == NSURLAuthenticationMethodServerTrust || method == NSURLAuthenticationMethodHTTPBasic{
			let credential = URLCredential(user: "asuha", password: "asuha0602", persistence: URLCredential.Persistence.forSession)
			completionHandler(.useCredential, credential)
		}else{
			completionHandler(.cancelAuthenticationChallenge, nil);
		}
		
	}
	
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
		webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
		self.progressView.isHidden = true
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		if(navigationAction.targetFrame == nil) {
			
			if #available(iOS 9.0, *) {
				let safariVC = SFSafariViewController(url:navigationAction.request.url!, entersReaderIfAvailable: false)
				safariVC.delegate = self
				
				self.present(safariVC, animated: true, completion: nil)
			} else {
				// Fallback on earlier versions
				UIApplication.shared.openURL(navigationAction.request.url!)
			}
		}
		return nil
		
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if let queryResult = navigationAction.request.url?.query {
			if (queryResult.range(of: "app_controller=info&type=mid&id=") != nil){
				decisionHandler(WKNavigationActionPolicy.cancel)
				pushController(url: navigationAction.request.url!)
				
				return
			}
		}
		
		decisionHandler(WKNavigationActionPolicy.allow)
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		let response = navigationResponse.response as! HTTPURLResponse
		let headFields = response.allHeaderFields as! [String:String]
		let cookies = HTTPCookie.cookies(withResponseHeaderFields: headFields, for: response.url!)
		print("navigationResponse :\(cookies)")
		HTTPCookieStorage.shared.setCookies(cookies, for: response.url, mainDocumentURL: URL(string:AppDelegate().serverBaseUrl))
		decisionHandler(WKNavigationResponsePolicy.allow)
	}
	
	func pushController(url: URL){
		let controller = TOWebViewController()
		controller.url = url
		controller.buttonTintColor = UIColor.white
		controller.showUrlWhileLoading = false
		controller.loadingBarTintColor = UIColor.white
		controller.showUrlWhileLoading = false
		
		self.navigationController?.toolbar.barTintColor = UIColor("#F49AAF")
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress"{
			//estimatedProgressが変更されたときに、setProgressを使ってプログレスバーの値を変更する。
			self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
		}else if keyPath == "loading"{
			UIApplication.shared.isNetworkActivityIndicatorVisible = self.webView.isLoading
			if self.webView.isLoading {
				self.progressView.setProgress(0.1, animated: true)
			}else{
				//読み込みが終わったら0に
				self.progressView.setProgress(0.0, animated: false)
			}
		}
	}
	
	deinit{
		//消さないと、アプリが落ちる
		self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
		self.webView.removeObserver(self, forKeyPath: "loading")
	}
	
	
	func getJSCookiesString(cookies: [HTTPCookie]) -> String {
		var result = ""
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
		dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
		
		for cookie in cookies {
			result += "document.cookie='/(cookie.name)=/(cookie.value); domain=/(cookie.domain); path=/(cookie.path); "
			if cookie.expiresDate != nil {
				result += "expires=/(dateFormatter.string(from: date)); "
			}
			if (cookie.isSecure) {
				result += "secure; "
			}
			result += "'; "
		}
		return result
	}
	
	
}



