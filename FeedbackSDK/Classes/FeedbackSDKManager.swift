//
//  FeedbackSDKManager.swift
//  FeedbackSDK
//
//  Created by Aravind Kumar on 04/04/19.
//

import UIKit
import Foundation

public class FeedbackSDKManager
{
    var sdk_app_id =  ""
    var sdk_secret_key =  ""
    var uniqId =  "";
    public typealias completionHandler = (Bool, Error?) -> Void
    
    public static let sdkInstance = FeedbackSDKManager()
    
    public  func initSDKWithAppId_SecretKey(SDK_APP_ID:String, SDK_APP_SECRET_KEY:String, completionHandler: @escaping completionHandler)
    {
        if SDK_APP_ID.isEmpty
        {
            return completionHandler(false,   NSError.init(domain: "com.feedBackSDK", code: 121, userInfo: ["info":"SDK_APP_ID id is empty"]))
        }else if SDK_APP_SECRET_KEY.isEmpty
        {
            return completionHandler(false,   NSError.init(domain: "com.feedBackSDK", code: 121, userInfo: ["info":"SDK_APP_SECRET_KEY id is empty"]))
        }
        else
        {
            self.sdk_app_id = SDK_APP_ID;
            self.sdk_secret_key = SDK_APP_SECRET_KEY;
            self.uniqId = UIDevice.current.identifierForVendor!.uuidString

            print( self.uniqId);
            
            let param:[String:String] = ["app_id":self.sdk_app_id,"secret_key":self.sdk_secret_key,"device_token":self.uniqId,"device_type":"ios"];
            
            let network = NetworkManager.shared
            
            network.callServerWithRequest(urlString: StringContent.APP_DETAILS_API, type: "PUT", param: param, completion: { (json:[String:Any], err:Error?) in
                if err != nil
                {
                    print("Some error came - ",err!)
                    return completionHandler(false,   NSError.init(domain: "com.feedBackSDK", code: 123, userInfo: ["info":err?.localizedDescription ?? ""]))

                }
                DispatchQueue.main.async {
                    print(json);
                    
                    if let status:NSInteger = json["status"] as? NSInteger
                    {
                        if status == 200 ||  status == 409
                        {
                            return completionHandler(true, nil)
                        }else
                        {
                            return completionHandler(false,   NSError.init(domain: "com.feedBackSDK", code: status, userInfo: ["info": json["message"] ?? ""]))
                        }
                    }
                }
            })
            
            print(SDK_APP_ID);
            print(SDK_APP_SECRET_KEY);
        }
        
    }
    public func showFeedbackViewController()
    {
        if self.sdk_app_id.isEmpty
            {
              print("Please inizilize app with secret key")
            }
        if self.sdk_secret_key.isEmpty
        {
            print("Please inizilize app with secret key ")
        }else
        {
        if #available(iOS 9.0, *) {
            
            var resourcesBundle : Bundle? = nil;
            let containingBundle = Bundle(for: FeedbackSDKViewController.self)
            let resourcesBundleURL =  containingBundle.url(forResource: "FeedbackSDKResources", withExtension: "bundle");
            if let bb  : URL = resourcesBundleURL
            {
                resourcesBundle =  Bundle(url: bb)
            }
            let viewCOntroller  = FeedbackSDKViewController(nibName: "FeedbackSDKViewController", bundle: resourcesBundle)
            UIApplication.shared.keyWindow?.rootViewController?.present(viewCOntroller, animated: true, completion: nil)
            
        }
        }
    }
    
}
