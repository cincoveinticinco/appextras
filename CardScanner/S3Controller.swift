//
//  S3Controller.swift
//  CardScanner
//
//  Created by Frontend on 28/09/18.
//  Copyright © 2018 525. All rights reserved.
//
import Foundation

import AWSS3
import Photos
import SwiftyJSON

// MARK: - S3 Definition

class S3 {
    
    private var accessKey: String?
    private var secretKey: String?
    private var identityPool: String?
    private var S3BucketName: String?
    private var assets: [PHAsset]?
    private var image: UIImage?
    private var locationId: Int?
    private var token: String?
    private var localName: String?
    private var dataConfig: Data?
    private var firstPhotoName: String?
    
    init(accessKey: String, secretKey: String, identityPool: String, bucketName: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.identityPool = identityPool
        self.S3BucketName = bucketName
        //self.assets = assets
    }
    
    // MARK: - Configuration
    func getPutSignUrl(filename: String, folder: String, onSuccess: @escaping(String) -> Void, onFailure: @escaping(String) -> Void){
        let params: NSMutableDictionary = [
            "filename": filename,
            "bucket": folder,
       ];
       
       ServiceManager.sharedInstance.sendRequest(route: "continuities/getPresignedUrlService", params: params, onSuccess:
           {
               json in
               DispatchQueue.main.sync {
                   onSuccess(json["url"].stringValue)
               }
               
       }, onFailure: {
           error in
           print(error.localizedDescription);
           onFailure(error.localizedDescription)
       }
       )
    }
    
    
    func addImage(assets: [PHAsset]){
        self.assets = assets;
        self.configureS3();
    }
    
    func addImage(image: UIImage, fileName: String){
        self.image = image
        self.localName = fileName
        self.dataConfig = UIImageJPEGRepresentation(image, 0.9)
        
//        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
//        AWSDDLog.sharedInstance.logLevel = .verbose
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: identityPool!)
//        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func configureS3() {
        print("Aqui estoiy en es S3")
        var localFileName: String?
        var data: Data?
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        var targetSize = CGSize()
        
        for (index, assetImage) in assets!.enumerated() {
            if assetImage.pixelHeight == assetImage.pixelWidth {
                targetSize = CGSize(width: 1024.0, height: 1024.0)
            } else if (assetImage.pixelHeight) > (assetImage.pixelWidth) {
                targetSize = CGSize(width: 768.0, height: 1024.0)
            } else {
                targetSize = CGSize(width: 1024.0, height: 768.0)
            }
            print(targetSize)
            
            PHImageManager.default().requestImage(for: (assetImage), targetSize: targetSize , contentMode: .aspectFill, options: options) { (image, array) in
                localFileName = assetImage.value(forKey: "filename") as? String
                let extensionFile = String(localFileName!.dropFirst(localFileName!.endIndex.encodedOffset - 3))
                print("Extension -> \(extensionFile) for file -> \(localFileName!)\n")
                localFileName = String(localFileName!.dropLast(3))
                localFileName = localFileName! + extensionFile
                data = UIImageJPEGRepresentation(image!, 0.7)
            }
            if index == 0 {
                firstPhotoName = localFileName
            }
            
            if localFileName == nil {
                return
            }
            print("             Local File Name:    \(localFileName!)")
//            AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
//            AWSDDLog.sharedInstance.logLevel = .verbose
//            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId: identityPool!)
//            let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
//            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            localName = localFileName!
            dataConfig = data;
            /*let uploadRequest = AWSS3TransferManagerUploadRequest()!
            uploadRequest.body = generateImageUrl(fileName: remoteName, data: data) as URL //selectedImageURL!
            uploadRequest.key = remoteName
            uploadRequest.bucket = S3BucketName
            uploadRequest.contentType = "image/jpg"
            
            print("\n\nuploadRequest?.body      \(uploadRequest.body)")
            print("uploadRequest?.key      \(uploadRequest.key!) \n\n")
            let transferManager = AWSS3TransferManager.default()*/
           
            // s3.amazonaws.com
            //performFileUpload(withTransferManager: transferManager, request: uploadRequest)
        }
    }
    
    func uploadFile(onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void) -> Void{
        let remoteName = ("\(abs(Date().hashValue))" + localName!).replacingOccurrences(of: "-", with: "")
        
        print("uploadFile - remoteName ", remoteName)
        print("BUCKET ", S3BucketName)
        
        self.getPutSignUrl(filename: remoteName, folder: S3BucketName!, onSuccess: {
            url in
            print("SIGN URL", url)
            ServiceManager.sharedInstance.uploadImage(urlSign: url, image: self.dataConfig! ){
                success, error in
                print("SUCCESS", success)
                print("ERROR", error)
                if(success){
                    print("https://s3.amazonaws.com/\(self.S3BucketName!)/\(remoteName)")
                   let s3URL = URL(string: "https://s3.amazonaws.com/\(self.S3BucketName!)/\(remoteName)")
                   dump(s3URL)
                   onSuccess("https://s3.amazonaws.com/\(self.S3BucketName!)/\(remoteName)");  
                }else{
                    onSuccess("fail_s3");
                    print("Empty result")
                }
                
            }
        }, onFailure: {
            error in
        })
        
//        let uploadRequest = AWSS3TransferManagerUploadRequest()!
//            uploadRequest.body = generateImageUrl(fileName: remoteName, data: dataConfig) as URL //selectedImageURL!
//            uploadRequest.key = remoteName
//            uploadRequest.bucket = S3BucketName
//            uploadRequest.contentType = "image/jpg"
//
//        print("\n\nuploadRequest?.body      \(uploadRequest.body)")
//        print("uploadRequest?.key      \(uploadRequest.key!) \n\n")
//
//        let transferManager = AWSS3TransferManager.default()
//
//        transferManager.upload(uploadRequest).continueWith(block: {
//            task -> AnyObject? in
//            DispatchQueue.main.async {
//                if let error = task.error{
//                    onFailure(error);
//                }
//
//                if task.result != nil{
//                    print("https://s3.amazonaws.com/\(self.S3BucketName!)/\(uploadRequest.key!)")
//                    let s3URL = URL(string: "https://s3.amazonaws.com/\(self.S3BucketName!)/\(uploadRequest.key!)")
//                    dump(s3URL)
//                    onSuccess("https://s3.amazonaws.com/\(self.S3BucketName!)/\(uploadRequest.key!)");
//                }else{
//                    onSuccess("fail_s3");
//                    print("Empty result")
//                }
//            }
//
//            return nil;
//
//        })
        
        
    }
    
    func performFileUpload(withTransferManager manager: AWSS3TransferManager, request: AWSS3TransferManagerUploadRequest) {
        manager.upload(request).continueWith(block: { (task) -> AnyObject? in
            
            DispatchQueue.main.async {
                //
            }
            
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
            }
            
            if task.result != nil {
                
                //self.createImages(for: request.key!, withLocationId: self.locationId!)
                let s3URL = URL(string: "https://s3.amazonaws.com/\(self.S3BucketName!)/\(request.key!)")
                print("    Uploaded to:\n\(s3URL!)")
                // Remove locally stored file
                self.remoteImageWithUrl(fileName: request.key!)
                
                DispatchQueue.main.async() {
                    print("uploaded")
                }
                
            }
            else {
                print("Unexpected empty result.")
            }
            return nil
        })
    }
    
    func generateImageUrl(fileName: String, data: Data?) -> URL {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        let data = data
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(localName!)
        print("\n path: \(localName!)")
        let image = UIImage(data: data!)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.9)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        
        do {
            try data!.write(to: fileURL, options: [.atomicWrite])
        } catch {
            print("Error while generation image -------------> \(error)")
        }
        
        return fileURL
    }
    
    
    func remoteImageWithUrl(fileName: String) {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        do {
            try FileManager.default.removeItem(at: fileURL as URL)
        } catch {
            print(error)
        }
    }
    
    func createImages(for image: String, withLocationId locationId: Int){
        var request = URLRequest(url: URL(string:  GlobalData.sharedInstance.serverURL + "/location_modules/create_images")!)
        request.httpMethod = "POST"
        
        var cover = 0
        if image.range(of:firstPhotoName!) != nil {
            cover = 1
        }
        let params = ["session_id": token!,
                      "id_location": locationId,
                      "comment": "",
                      "location_images": ["0": ["cover": cover, "route": image]]
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("     -- ----      ---- --")
        print("     -- ----    CREATING IMAGES  ---- --")
        print(String(data: jsonData!, encoding: .utf8)!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(httpStatus)")
            }
            
            var json: Any
            
            do {
                json = try JSON(data: data)
                print(json)
            } catch _ {
                
            }
            
            
            
        }
        task.resume()
    }
}
