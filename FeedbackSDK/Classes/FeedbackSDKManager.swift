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
    var DEFAULT_TITLE = "Rate Me";
    var DEFAULT_RATE_TEXT = "Hi! If you like this App, can you please take a few minutes to rate it? It help so much when you do , thanks!";
    var DEFAULT_YES_RATE = "Yes";
    var DEFAULT_MAY_BE_LATER = "Maybe Later";
    var DEFAULT_NO_THANKS = "No, Thanks";
    var DEFAULT_DAYS_BEFORE_PROMPT = 3;
    var DEFAULT_LAUNCH_BEFORE_PROMPT = 7;
    
    
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
            let ud:UserDefaults = UserDefaults.standard
            
            if ud.object(forKey: "popupCount") != nil
            {
                if let popupCount : Int = ud.integer(forKey: "popupCount")
                {
                    if  popupCount >  FeedbackSDKManager.sdkInstance.DEFAULT_LAUNCH_BEFORE_PROMPT
                    {
                        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showAlert), userInfo: nil, repeats: false)
                    }else
                    {
                        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showAfterLunch), userInfo: nil, repeats: false)

                    }
                }else
                {
                    Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showAfterLunch), userInfo: nil, repeats: false)
                }
            }else
            {
         Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(showAfterLunch), userInfo: nil, repeats: false)
            }

            print( self.uniqId);
            
            // Do any additional setup after loading the view, typically from a nib.
            /** call 'showReviewView' method with desired launch counts needed. **/
          
            
            
            let param:[String:String] = ["app_id":self.sdk_app_id,"secret_key":self.sdk_secret_key,"device_token":self.uniqId,"device_type":"ios"];
            
            let network = NetworkManager.shared
            
            network.callServerWithRequest(urlString: StringContent.APP_DETAILS_API, type: "PUT", param: param, completion: { (json:[String:Any], err:Error?) in
                if err != nil
                {
                    //print("Some error came - ",err!)
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
    @objc public func showAfterLunch()
    {
        if #available(iOS 10.3, *) {
            FeedbackSDKReview().showReviewView(isShow: false)
        }else{
            // Review View is unvailable for lower versions. Please use your custom view.
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
    public func addRatingPopUInformation(DEFAULT_TITLE:String,DEFAULT_RATE_TEXT:String,DEFAULT_YES_RATE:String,DEFAULT_MAY_BE_LATER:String,DEFAULT_NO_THANKS:String,DEFAULT_DAYS_BEFORE_PROMPT:Int,DEFAULT_LAUNCH_BEFORE_PROMPT:Int)
    {
         self.DEFAULT_TITLE = DEFAULT_TITLE;
         self.DEFAULT_RATE_TEXT = DEFAULT_RATE_TEXT;
         self.DEFAULT_YES_RATE = DEFAULT_YES_RATE;
         self.DEFAULT_MAY_BE_LATER = DEFAULT_MAY_BE_LATER;
         self.DEFAULT_NO_THANKS = DEFAULT_NO_THANKS;
         self.DEFAULT_DAYS_BEFORE_PROMPT = DEFAULT_DAYS_BEFORE_PROMPT;
         self.DEFAULT_LAUNCH_BEFORE_PROMPT = DEFAULT_LAUNCH_BEFORE_PROMPT;
    }
    @objc func showAlert()
    {
        let alert = UIAlertController(title: "Error!", message: "Are you happy with app, Do you want to send feedback or rating for app?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            if #available(iOS 10.3, *)
            {
                FeedbackSDKReview().showReviewView(isShow: true)
            }else{
                // Review View is unvailable for lower versions. Please use your custom view.
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            if #available(iOS 10.3, *)
            {
                let ud:UserDefaults = UserDefaults.standard
                ud.set("1", forKey: "isNoThnks");
                ud.synchronize()
                
                self.showFeedbackViewController()
            }else{
                // Review View is unvailable for lower versions. Please use your custom view.
            }
            
        }))
         UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
       }
        
}
