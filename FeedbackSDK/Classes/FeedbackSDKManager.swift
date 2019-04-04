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
        self.sdk_app_id = SDK_APP_SECRET_KEY;

        print(SDK_APP_ID);
        print(SDK_APP_SECRET_KEY);
    }

    }

}
