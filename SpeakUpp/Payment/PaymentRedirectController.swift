//
//  PaymentRedirectController.swift
//  SpeakUpp
//
//  Created by Bright Ahedor on 13/02/2018.
//  Copyright © 2018 Bright Limited. All rights reserved.
//

import UIKit


class PaymentRedirectController: UIViewController,UIWebViewDelegate {
    
    var url = ""
    var homeCell: HomeCell?
    var pollsController: PollsController?
    var searchController: SearchController?
    var eventDetailController: EventDetailController?
    var pollVottingOptionController: PollVottingOptionController?
    private var hasFinishedLoading = false
    var eventCell: EventCell?
    var trendingCell: TrendingCell?
    var timer: Timer!
    
    let progressUIView: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.progress = 0
        progressBar.trackTintColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.tintColor = UIColor(red:0.0, green:0.6392, blue:0.0196, alpha:1.0)
        progressBar.backgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    lazy var webView: UIWebView = {
        let webV = UIWebView()
        webV.frame  = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        webV.delegate = self
        webV.translatesAutoresizingMaskIntoConstraints = false
        return webV
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setUpNavigationBar()
        
        self.view.addSubview(progressUIView)
        self.view.addSubview(webView)
        
        self.progressUIView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.progressUIView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.progressUIView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.progressUIView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.webView.topAnchor.constraint(equalTo: progressUIView.bottomAnchor, constant: 0).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
      
        
        let pageUrl = NSURL(string: url)
        if (pageUrl != nil){
            let request = NSURLRequest(url: pageUrl! as URL)
            self.webView.loadRequest(request as URLRequest)
        }
    }
    
    
    private func setUpNavigationBar()  {
        navigationItem.title = "Finalize Payment"
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = UIImage(named: "BackArrow")?.withRenderingMode(.alwaysOriginal)
        let menuBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = menuBack
        
    }
    
    @objc func handleCancel()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("ERROR \(error)")
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        hasFinishedLoading = false
        self.funcToCallWhenStartLoadingYourWebview()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.funcToCallCalledWhenUIWebViewFinishesLoading()
        if let link = webView.request?.url! {
            let check:String = link.relativeString
            if (check.contains(ApiUrl().callBack()) || check.contains(ApiUrl().speakUppCallBack())){
                //MARK - send calls to all handler
                self.homeCell?.callRefresh()
                self.pollsController?.callRefresh()
                self.eventCell?.callRefresh()
                self.eventDetailController?.callRefresh()
                self.trendingCell?.callRefresh()
                self.searchController?.setSearchType(type: SearchType.poll)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let _ = webView.request?.url! {
        }
        return true
    }
    
    func funcToCallWhenStartLoadingYourWebview() {
        self.progressUIView.progress = 0.0
        self.hasFinishedLoading = false
        self.timer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(PaymentRedirectController.timerCallback), userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.hasFinishedLoading = true
    }
    
    @objc func timerCallback() {
        if self.hasFinishedLoading {
            if self.progressUIView.progress >= 1 {
                self.progressUIView.isHidden = true
                self.timer.invalidate()
            } else {
                self.progressUIView.progress += 0.1
            }
        } else {
            self.progressUIView.progress += 0.05
            if self.progressUIView.progress >= 0.95 {
                self.progressUIView.progress = 0.95
            }
        }
    }
    
}
