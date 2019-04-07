//
//  NetworkManager.swift
//  KeyboardExt
//
//  Created by Abhishek Bhardwaj on 22/2/18.
//  Copyright © 2018 Abhishek Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import StoreKit

let baseURL:String = "http://www.apptenium.com/index.php?r=api/v1/"


public class NetworkManager
{
    var popupObj : FeedbackSDKRatingPoupVC!
    static let shared = NetworkManager()
    typealias completionHandler = ([String:Any], Error?) -> Void
    private init() {
    }
    func callServerWithRequest(urlString:String, type:String, param:[String:String], completion: @escaping completionHandler)
    {
        let urlStr:String = baseURL + urlString
        let header:HTTPHeaders = ["Content-Type":"application/json"]
        
        if type == "POST"
        {
    
            Alamofire.request(urlStr, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
                if let data = response.data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                }
                switch response.result
                {
                case .success(let jsonFetched):
                    //    print(jsonFetched)
                    completion(jsonFetched as! [String:Any], nil)
                    break
                case .failure(let err):
                    //    print(err)
                    completion([:], err)
                    break
                }
            }
        }
       else  if type == "PUT"
        {
            
            Alamofire.request(urlStr, method: .put, parameters: param, encoding: URLEncoding.httpBody, headers: header).responseJSON { (response:DataResponse) in
                if let data = response.data {
                    print(String(data: data, encoding: String.Encoding.utf8)!)
                }
                switch response.result
                {
                case .success(let jsonFetched):
                    //    print(jsonFetched)
                    completion(jsonFetched as! [String:Any], nil)
                    break
                case .failure(let err):
                    //    print(err)
                    completion([:], err)
                    break
                }
            }
        }
        else
        {
            Alamofire.request(urlStr, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse) in
                switch response.result
                {
                case .success(let jsonFetched):
                    //    print(jsonFetched)
                    completion(jsonFetched as! [String:Any], nil)
                    break
                case .failure(let err):
                    //    print(err)
                    completion([:], err)
                    break
                }
            }
        }
    }
    func showAppleReview()
    {
            if #available(iOS 10.3, *)
            {
                SKStoreReviewController.requestReview()
                
            } else {
                // Fallback on earlier versions
                let alert = UIAlertController(title: "", message: "Please update your  app?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    
}
