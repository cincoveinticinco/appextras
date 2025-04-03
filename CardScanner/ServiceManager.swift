//
//  ServiceManager.swift
//  CardScanner
//
//  Created by Frontend on 24/09/18.
//  Copyright © 2018 525. All rights reserved.
//

import UIKit
import SwiftyJSON


class ServiceManager: NSObject {
    let API_URL = GlobalData.sharedInstance.serverURL;
    static let sharedInstance = ServiceManager()
    
    func uploadImage(urlSign: String, image: Data, completion: @escaping(_ isComplete: Bool, _ error: Error?) -> ()){
           
          guard let validURL = URL(string: urlSign) else {
               print("URL creatinn failed")
               return
           }
           
           let config = URLSessionConfiguration.default
           config.waitsForConnectivity = true;
           config.timeoutIntervalForResource = 60*5
           
           var request = URLRequest(url: validURL)
           let boundary = "Boundary-\(UUID().uuidString)"
           request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           
           request.httpMethod = "PUT";
           
           let httpBody = NSMutableData()
           
           if !image.isEmpty{
               let mimeType = self.mimeType(for: image)
               let extensionData = self.extensionData(for: image)
               
               httpBody.append(convertFileData(
                                   fieldName: "img",
                                   fileName: "image\(extensionData)",
                                   mimeType: mimeType,
                                   fileData: image,
                                   using: boundary))
           }
           
           

           httpBody.append(Data("--\(boundary)--".utf8))
           request.httpBody = httpBody as Data
           
            URLSession(configuration: config).dataTask(with: request as URLRequest){
               (data, response, error) in
               
               if let httpresponse = response as? HTTPURLResponse {
                   print("API response status create image: \(httpresponse.statusCode)")
                   if httpresponse.statusCode == 403 {
                       let error = NSError(domain: "Forbiden Error", code: 403, userInfo: nil)
                       completion(false, error)
                       return
                   }

                   if httpresponse.statusCode == 404 {
                       let error = NSError(domain: "Not Found Error", code: 404, userInfo: nil)
                       completion(false, error)
                       return
                   }

                   if httpresponse.statusCode == 500 {
                       let error = NSError(domain: "Server Error", code: 500, userInfo: nil)
                       completion(false, error)
                       return
                   }
               }
               
               if let error = error {
                   print("Error on upload", error)
                   completion(false, error)
                   return
               }
               
               guard let data = data else{
                   let error = NSError(domain: "Network unavailable", code: 101, userInfo: nil)
                   completion(false, error)
                   return
               }
                
                print(data)
              completion(true, nil)
               
               
           }.resume()
           
       }
    

    
    func sendRequest(route:String, params: NSMutableDictionary,  onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url : String = API_URL + route;
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL);
        request.httpMethod = "POST";
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        params.addEntries(from: ["session_id" : GlobalData.token!])
        
        print(params)
        print(url)
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options:[]);
        
        let session = URLSession.shared;
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            }else{
                var result: Any
                if let returnData = String(data: data!, encoding: .utf8) {
                    if(route == "/app_release/assignment/"){
                        print(returnData)
                    }
                        
                }
                do {
                    result = try JSON(data: data!)
                    onSuccess(result as! JSON);
                } catch {
                    print("ERROR REQUEST", error)
                    
                }
            }
        })
        
        task.resume();
    }
    
    private func mimeType(for data: Data) -> String {

          var b: UInt8 = 0
          data.copyBytes(to: &b, count: 1)

          switch b {
          case 0xFF:
              return "image/jpeg"
          case 0x89:
              return "image/png"
          case 0x47:
              return "image/gif"
          case 0x4D, 0x49:
              return "image/tiff"
          case 0x25:
              return "application/pdf"
          case 0xD0:
              return "application/vnd"
          case 0x46:
              return "text/plain"
          default:
              return "application/octet-stream"
          }
      }
      
      private func extensionData(for data: Data) -> String {

          var b: UInt8 = 0
          data.copyBytes(to: &b, count: 1)

          switch b {
          case 0xFF:
              return ".jpeg"
          case 0x89:
              return ".png"
          case 0x47:
              return ".gif"
          case 0x4D, 0x49:
              return ".tiff"
          case 0x25:
              return ".pdf"
          case 0xD0:
              return ".vnd"
          case 0x46:
              return ".txt"
          default:
              return ""
          }
      }
      
      func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()

        //data.append(Data("--\(boundary)\r\n".utf8))
        //data.append(Data("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".utf8))
        //data.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        data.append(fileData)
        //data.append(Data("\r\n".utf8))

        return data as Data
      }
      
    
    
}
