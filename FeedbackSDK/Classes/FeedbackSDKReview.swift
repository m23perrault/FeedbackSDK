//
//  FeedbackSDKReview.swift
//  FeedbackSDK
//
//  Created by Aravind Kumar on 04/04/19.
//


import UIKit
class FeedbackSDKReview {
    
    
    func isReviewViewToBeDisplayed() -> Bool {
       //case for date
        let ud:UserDefaults = UserDefaults.standard
        if ud.object(forKey: "isNoThnks") != nil
        {
              return false
        }
        if ud.object(forKey: "popupCount") != nil
        {
            if let popupCount : Int = ud.integer(forKey: "popupCount")
        {
           if  popupCount >  FeedbackSDKManager.sdkInstance.DEFAULT_LAUNCH_BEFORE_PROMPT
                {
                    return false
            }
        }
        }
        if let lastPopUpDate = ud.object(forKey: "lastPopUpDate")
        {
            print(lastPopUpDate)
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
            ud.synchronize()
            return false
        }
    }
    
    /** This method is called from any class with minimum launch count needed. **/
    
    func showReviewView(isShow:Bool)
    {
         if(self.isReviewViewToBeDisplayed() || isShow)
         {
            if(isShow)
            {
                let ud:UserDefaults = UserDefaults.standard
                ud.set(1, forKey: "popupCount");
                ud.synchronize()
            }
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
            NetworkManager.shared.popupObj = viewCOntroller;
            viewCOntroller.view.frame = UIApplication.shared.keyWindow!.bounds
            viewCOntroller.view.backgroundColor =  UIColor.clear
            UIApplication.shared.keyWindow?.addSubview(viewCOntroller.view);
        }
        return;
    }
    }
}

