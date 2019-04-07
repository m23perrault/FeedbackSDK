//
//  FeedbackSDKRatingPoupVC.swift
//  FeedbackSDK
//
//  Created by Aravind Kumar on 06/04/19.
//

import UIKit

class FeedbackSDKRatingPoupVC: UIViewController {

    @IBOutlet weak var noTnksbtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var despLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setOverideText()
    }

    func setOverideText()
    {
        titleLbl.text =  FeedbackSDKManager.sdkInstance.DEFAULT_TITLE
        
        despLbl.text =  FeedbackSDKManager.sdkInstance.DEFAULT_RATE_TEXT
        
        yesBtn.setTitle(FeedbackSDKManager.sdkInstance.DEFAULT_YES_RATE, for: .normal)
        nextBtn.setTitle(FeedbackSDKManager.sdkInstance.DEFAULT_MAY_BE_LATER, for: .normal)
        noTnksbtn.setTitle(FeedbackSDKManager.sdkInstance.DEFAULT_NO_THANKS, for: .normal)
        
    }
    @IBAction func yesBtnAction(_ sender: Any) {
    }
    @IBAction func nextTimeAction(_ sender: Any) {
    }
    @IBAction func noTnksAction(_ sender: Any) {
    }
    @IBAction func hidePopUpAction(_ sender: Any) {
    }
}
