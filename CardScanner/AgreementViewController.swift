//
//  AgreementViewController.swift
//  CardScanner
//
//  Created by Frontend on 1/10/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

protocol ReleaseScrollDelegate {
    func completeScroll(complete: Bool)
}

class AgreementViewController: UIViewController, YPSignatureDelegate {
    
    @IBOutlet weak var lblbCountpage: UILabel!
    @IBOutlet weak var lblStatusButton: UILabel!
    
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var buttonSign: UIButton!
    
    @IBOutlet weak var PDFWebView: WKWebView!
    
    @IBOutlet weak var viewPDF: PDFView!
    
    
    var activityView: UIActivityIndicatorView?
    var text: UILabel?;
    var releaseDone: Bool = false;
    var signDone: Bool = false;
    var isURLLoaded = false;
    
    var lastPage = 0;
    var currScrollPage:Int?  ;
    
    //var viewPDF: PDFView!;
    
    @IBOutlet var mainViewContent: UIView!
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewWillDisappear(_ animated: Bool){
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        
        
        setNeedsStatusBarAppearanceUpdate()
        signatureView.delegate = self
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityView?.color = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        activityView?.center = self.view.center
        
        text = UILabel(frame: CGRect(x: 60, y: 0, width: 70, height: 50))
        text?.center.x = self.view.center.x;
        text?.center.y = self.view.center.y + 30;
        text?.textColor = #colorLiteral(red: 0.9538540244, green: 0.2200518847, blue: 0.3077117205, alpha: 1)
        text?.textAlignment = .center;
        text?.text = "Loading"
        text?.isHidden = true;
        self.view.addSubview(text!)
     
        self.view.addSubview(activityView!)
        
        
        print("release");
        print(GlobalData.sharedInstance.releaseString);
        
        if GlobalData.sharedInstance.releaseString != "" {
            let url = URL(string: GlobalData.sharedInstance.releaseString);
            
            if let pdfDocument = PDFDocument(url: url!){
                viewPDF.autoScales = true;
                viewPDF.displayMode = .singlePageContinuous;
                viewPDF.displayDirection = .vertical;
                viewPDF.document = pdfDocument;
                
                lastPage = pdfDocument.pageCount;
            }
        }else{
            Utils.showMessage("Error", message: "There is no release for this role");
        }
        
        
        
        
       
    }

    @IBAction func OnClearSign(_ sender: Any) {
        self.signatureView.clear()
        signDone = false;
        finishRelease();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Signing Delegate
    func didStart() {
        print("Started Drawing")
    }
    
    func didFinish() {
        signDone = true;
        finishRelease();
    }
    
    func releaseScroll(complete:Bool){
        releaseDone = complete;
        finishRelease();
    }
    
    func finishRelease(){
        
        print("Sign: \(signDone) Release \(releaseDone) Button \(buttonSign.isEnabled)")
        print(releaseDone)
        
        //if((currScrollPage) != nil){
          //  releaseDone = currScrollPage! >= lastPage
       // }
        
        
        if(signDone && releaseDone){
            buttonSign.isEnabled = true
            buttonSign.alpha = 1
        }else{
            buttonSign.isEnabled = false
            buttonSign.alpha = 0.45
        }
        
        lblStatusButton.text = "Sign: \(signDone) Release \(releaseDone) Button \(buttonSign.isEnabled)"
        
    }
    
    func uploadSign(fileName: String, onSucces: @escaping(String) -> Void){
      if let signatureImage = self.signatureView.getSignature(scale: 10) {
          let s3Controller = GlobalData.sharedInstance._S3Controller;
        s3Controller?.addImage(image: signatureImage, fileName: fileName+".jpg")
        s3Controller?.uploadFile(
                onSuccess:{
                    url in
                    print("uploadSign url", url)
                    onSucces(url);
                    self.signatureView.clear()
                    
            },
                onFailure:{
                    error in
                    print(error.localizedDescription);
            })
        }
    }
    
    func upladoWithoutSign(){
        let person = GlobalData.sharedInstance.person;
        var characters_name = "";
        
        if(person?.isStored)!{
            activityView?.startAnimating()
            mainViewContent.isHidden = true;
            
            
            person?.dailyPlan = GlobalData.sharedInstance.dailyPlan
            //person?.characterHasId = GlobalData.sharedInstance.characterHasId;
            person?.characterId = GlobalData.sharedInstance.characterId
            person?.storedPerson(
                isApprove: (person?.isApproved)!,
                onSuccess: {
                    json in
                    DispatchQueue.main.async {
                        print(json)
                        if(json["error"].bool == false){
                            self.activityView?.hidesWhenStopped = true;
                            self.activityView?.stopAnimating();
                            self.performSegue(withIdentifier: "arriveSegue", sender: self);
                        }else{
                            for character in json["characters"].arrayValue{
                                characters_name += "\(character["character_name"]), "
                            }
                            GlobalData.sharedInstance.characterNamePrevius = characters_name;
                            
                            
                            GlobalData.sharedInstance.alertPersons.append(person!)
                            self.performSegue(withIdentifier: "alertArriveSegue", sender: self)
                            NotificationCenter.default.post(name: .alertCount, object: nil)
                        }
                    }
            }, onFailure: {
                error in
                print(error.localizedDescription);
                //self.performSegue(withIdentifier: "arriveSegue", sender: self);
            })
        }
        
        
    }
    @IBAction func OnCancelRelease(_ sender: Any) {
        performSegue(withIdentifier: "unwindToListCharacter", sender: self)
    }
    
    @IBAction func OnSignRelease(_ sender: Any) {
        let person = GlobalData.sharedInstance.person;
        var characters_name = "";
        
        print("UPLOAD")
    
        activityView?.startAnimating()
        mainViewContent.isHidden = true;
        text?.isHidden = false;
        
        
        
        self.uploadSign(fileName: "" ,onSucces: {
            urlSignature in
                person?.imageSignature = urlSignature
            
            print("urlSignature", urlSignature)
            
            if(urlSignature != "fail_s3"){
                person?.dailyPlan = GlobalData.sharedInstance.dailyPlan
                person?.characterHasId = GlobalData.sharedInstance.characterHasId
                person?.characterId = GlobalData.sharedInstance.characterId
                person?.storedPerson(
                    onSuccess: {
                        json in
                        DispatchQueue.main.async {
                            print("LA JSON")
                            print(json)
                            if(json["error"].bool == false){
                                self.activityView?.hidesWhenStopped = true;
                                self.activityView?.stopAnimating();
                                self.performSegue(withIdentifier: "arriveSegue", sender: self);
                            }else{
                                print("la LA JSON")
                                print(json)
                                print("error json")
                                self.performSegue(withIdentifier: "alertArriveSegue", sender: self)
                                
                                for character in json["characters"].arrayValue{
                                    characters_name += "\(character["character_name"]), "
                                }
                                
                                GlobalData.sharedInstance.characterNamePrevius = characters_name;
                                GlobalData.sharedInstance.alertPersons.append(person!)
                                NotificationCenter.default.post(name: .alertCount, object: nil)
                            }
                        
                        }
                }, onFailure: {
                    error in
                    print(error.localizedDescription);
                    //self.performSegue(withIdentifier: "arriveSegue", sender: self);
                })
            }else{
                let alert : UIAlertController  =
                    UIAlertController(
                        title: "Error",
                        message: "Error uploading signature, try again",
                        preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
                    alert in
                        self.activityView?.stopAnimating()
                        self.mainViewContent.isHidden = false;
                        self.text?.isHidden = true;
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            
            
           
            
            
        })
    }
    
    @IBAction func _OnSignRelease(_ sender: Any) {
        performSegue(withIdentifier: "arriveSegue", sender: self);
    }
    
    @objc private func handlePageChange(notification: Notification)
    {
        let currPage = viewPDF.currentPage?.pageRef?.pageNumber
        
        print(lastPage)
        print(currPage!)
        if(currScrollPage == nil){
            currScrollPage = currPage!
        }
        
        lblbCountpage.text = "lastPage \(lastPage) currpage \(currPage!)"
        
        if(lastPage > 0 && currPage! >= lastPage - 1){
            print("aqui entro")
            self.releaseDone = true;
            self.finishRelease()
        }
        
    }
}

extension AgreementViewController: ReleaseScrollDelegate{
    func completeScroll(complete: Bool) {
        self.releaseScroll(complete: complete)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EmbedSegue"{
            let vc = segue.destination as! ReleaseTextViewController
            vc.delegateRelease = self;
        }
    }
    
    
}



