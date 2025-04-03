//
//  WebLoginViewController.swift
//  CardScanner
//
//  Created by Frontend on 18/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class WebLoginViewController: UIViewController {
    
    @IBOutlet weak var wkWebViewLogin: WKWebView!
    @IBOutlet weak var webViewLogin: UIWebView!
    @IBOutlet weak var closeButton: UIButton!
    
    var activityView: UIActivityIndicatorView?
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GlobalData.logOut {
            print(GlobalData.token ?? "NO TOK")
            if((GlobalData.token) != nil){
                loadWeb(_url: Urls.LogOut + GlobalData.token!);
            }
            
        }else{
            if((GlobalData.token) != nil){
                loadWeb(_url: Urls.Login);
            }else{
                loadWeb(_url: Urls.Login);
                GlobalData.sharedInstance.loginUser = true;
            }
        }
        
        
        
    }
    
    func loadWeb(_url: String){
        //Utils.showMessage("FINISH.CONNECTED", message: "\(_url)")
        let url = URL(string: _url);
        let request = URLRequest(url: url!);
        
        print("Load-web url:")
        print(_url)
        
        closeButton.isHidden = true;
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        activityView?.startAnimating()
        self.view.addSubview(activityView!)
        
        wkWebViewLogin.navigationDelegate = self
        wkWebViewLogin.load(request)
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseButton(_ sender: Any) {
        performSegue(withIdentifier: Identifier.GoBack, sender: self);
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

// MARK: - WK Web View Delegate
extension WebLoginViewController:WKNavigationDelegate{
    
    func wkGetUserToken(webView: WKWebView){
        if let url = webView.url?.absoluteString{
                   print("LOGOUT")
                   print(GlobalData.logOut)
                   print("URL TOKEN:")
                   print(url)
                   print("------++------")
            
            
                   if GlobalData.logOut{
                       GlobalData.sharedInstance.dispose();
                       GlobalData.logOut = false;
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                       WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
                       performSegue(withIdentifier: Identifier.GoBack, sender: self);
                       
                   }else{
                       
                  if url.contains("/user/"){
                         print("CONTAIN TOKEN:" + url)
                           let index = url.range(of: "/user/")
                           let convertedToken = url[(index?.upperBound)!..<url.endIndex]
                           print("TOKEN:" + convertedToken)
                           
                           token = String(convertedToken) //"77c6f62af411065aaea5b864def0ddbb2153f92a" //
                           GlobalData.token = token;
                           
                           performSegue(withIdentifier: "seguePassword", sender: self);
                        
                    }else{
                           if !url.contains("/home"){
                               GlobalData.token = nil;
                           }else{
                               
                               print("RENDER HOME")
                               
                               if (GlobalData.token == nil){
                                   webView.getCookies(){ cookies in
                                       if let accionTok = cookies["accionTok"] as? [String: Any]{
                                           if let convertedToken = accionTok["Value"] as? String  {
                                               print("COOKIE USER",convertedToken)
                                               
                                               self.token = convertedToken  //"77c6f62af411065aaea5b864def0ddbb2153f92a" //
                                               GlobalData.token = self.token;
                                               self.performSegue(withIdentifier: "seguePassword", sender: self);
                                           }
                                           
                                       }
                                   }
                                   
                                   
                               }
                               
                               
                               
                           }
                      }
                   }
               }
           
       }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if webView.isLoading{
            closeButton.isHidden = true;
            webView.isHidden = true;
            activityView?.startAnimating();
            wkGetUserToken(webView: webView)
            
            return;
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("FINISH")
    

        webView.isHidden = false;
        closeButton.isHidden = false;
        
        wkGetUserToken(webView: webView)
        
        self.activityView?.hidesWhenStopped = true;
        self.activityView?.stopAnimating();  
    }
}

// MARK: - Web View Delegate
extension WebLoginViewController: UIWebViewDelegate{
    
    func getUserToken(webView: UIWebView){
        if let url = webView.request?.url?.absoluteString{
                   print("LOGOUT")
                   print(GlobalData.logOut)
                   print("URL TOKEN:")
                   print(url)
                   print("------++------")
            
            if let bundleId = Bundle.main.bundleIdentifier{
                let cookies = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: bundleId)
                print(cookies)
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies{ cookies in
                    print(cookies)
                }
            }
                   if GlobalData.logOut{
                       GlobalData.sharedInstance.dispose();
                       GlobalData.logOut = false;
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                       performSegue(withIdentifier: Identifier.GoBack, sender: self);
                       
                   }else{
                       if url.contains("/user/"){
                           print("CONTAIN TOKEN:" + url)
                           let index = url.range(of: "/user/")
                           let convertedToken = url[(index?.upperBound)!..<url.endIndex]
                           print("TOKEN:" + convertedToken)
                           
                           token = String(convertedToken) //"77c6f62af411065aaea5b864def0ddbb2153f92a" //
                           GlobalData.token = token;
                           
                           performSegue(withIdentifier: "seguePassword", sender: self);
                        
                       }else{
                           if !url.contains("/home"){
                               GlobalData.token = nil;
                           }else{
                               print(GlobalData.token)
             //                  loadWeb(_url: Urls.Login);
               //                GlobalData.sharedInstance.loginUser = true ;
                               
                               
                               //performSegue(withIdentifier: "seguePassword", sender: self);
                           }
                       }
                   }
               }
           
       }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //sleep(2)
        if webView.isLoading{
            closeButton.isHidden = true;
            webView.isHidden = true;
            activityView?.startAnimating();
            getUserToken(webView: webView)
            
            return;
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        print("FINISH")
    
        //Utils.showMessage("FINISH.CONNECTED", message: "--")
        webView.isHidden = false;
        closeButton.isHidden = false;
        
        getUserToken(webView: webView)
        
       
        
        
        //token = "11"
        // GlobalData.token = token;
        //performSegue(withIdentifier: "seguePassword", sender: self);
        //
        self.activityView?.hidesWhenStopped = true;
        self.activityView?.stopAnimating();
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        print(error);
    }
}

// MARK: - Navigation
extension WebLoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.Home {
            GlobalData.token = token;
            UserDefaults.standard.set(token!, forKey: Identifier.Token)
            UserDefaults.standard.synchronize()
        }
    }
}

// MARK: - Extension

extension WebLoginViewController {
    
    struct Identifier {
        static let GoBack = "unWindToLoginView"
        static let Menu = "Show Menu"
        static let Home = "WelcomeViewSegue"
        static let Token = "app_token"
    }
    
    struct Urls {
        static let Login =  GlobalData.sharedInstance.serverURL + "/saml/init"
        static let LogOut =  GlobalData.sharedInstance.serverURL + "/saml/logout/1/"
    }
}


// MARK: - GET COOKIES WEB VIEW
extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}
