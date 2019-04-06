//
//  FeedbackSDKReview.swift
//  FeedbackSDK
//
//  Created by Aravind Kumar on 04/04/19.
//


import UIKit
import StoreKit

class FeedbackSDKReview {
    
    
    func isReviewViewToBeDisplayed() -> Bool {
        
       //case for date
        let ud:UserDefaults = UserDefaults.standard
        if let lastPopUpDate = ud.object(forKey: "lastPopUpDate")
        {
            print(lastPopUpDate)
            return true

           
            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: lastPopUpDate as! Date, to: Date());
            
            if let day = difference.day
            {
                print(day);
                
            if day > FeedbackSDKManager.sdkInstance.DEFAULT_DAYS_BEFORE_PROMPT
            {
                return true
                }else
            {
                return false
                }
            }

            
            return false
        }else
        {
            let date = Date()
            ud.set(date, forKey: "lastPopUpDate");
            return false
        }
    }
    
    /** This method is called from any class with minimum launch count needed. **/
    
    func showReviewView(){
          if #available(iOS 9.0, *)
          {
        var resourcesBundle : Bundle? = nil;
        let containingBundle = Bundle(for: FeedbackSDKViewController.self)
        let resourcesBundleURL =  containingBundle.url(forResource: "FeedbackSDKResources", withExtension: "bundle");
        if let bb  : URL = resourcesBundleURL
        {
            resourcesBundle =  Bundle(url: bb)
        }
        let viewCOntroller  = FeedbackSDKRatingPoupVC(nibName: "FeedbackSDKRatingPoupVC", bundle: resourcesBundle)
        UIApplication.shared.keyWindow?.addSubview(viewCOntroller.view)
        
        return;
        
        if(self.isReviewViewToBeDisplayed()){
            if #available(iOS 10.3, *)
            {
                SKStoreReviewController.requestReview()
                
            } else {
                // Fallback on earlier versions
            }
        }
    }
    }
}

