//
//  LoginViewController.swift
//  Hackin.at
//
//  Created by Prateek on 12/17/14.
//  Copyright (c) 2014 Prateek Dayal. All rights reserved.
//
//
//  LoginViewController.swift
//  Github Auth
//
//  Created by Prateek on 11/3/14.
//  Copyright (c) 2014 Prateek. All rights reserved.
//

import UIKit
import WebKit

protocol LoginViewDelegate {
    
    func hackerLoggedIn()
    
}

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var containerView: UIView!
    var webView: WKWebView?
    var delegate: LoginViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView?.frame = CGRect(x: 0,y: 0,width: 0,height: 0)
        webView?.navigationDelegate = self
        
        self.view.addSubview(self.webView!)
        
        var url = NSURL(string: Hackinat.sharedInstance.githhubAuthURL)
        var req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        println("So you want to login with Github?")
            self.view = self.webView!
    }
    
    
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        // If the URL has afterauth, extract auth_token and other info from it
        let url: NSURL = webView.URL!
        println("Finished navigating to url \(url)")
        if url.absoluteString?.rangeOfString("afterauth") != nil{
            let queryString = url.query
            
            queryString?.componentsSeparatedByString("&").map {
                (keyValuePair: String) -> Void in
                let keyValue = keyValuePair.componentsSeparatedByString("=")
                let key = keyValue[0]
                let value = keyValue[1]
                
                if(key == "login"){ CurrentHacker.login = value }
                if(key == "auth_key"){ CurrentHacker.authKey = value }
                
                self.delegate?.hackerLoggedIn()
            }
            
        }
        
    }
    
}