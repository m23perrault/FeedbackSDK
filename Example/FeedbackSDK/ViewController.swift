//
//  ViewController.swift
//  FeedbackSDK
//
//  Created by aravindkumar on 04/02/2019.
//  Copyright (c) 2019 aravindkumar. All rights reserved.
//

import UIKit
import FeedbackSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func feedbackAction(_ sender: Any)
    {
        FeedbackSDKManager.sdkInstance.showFeedbackViewController()
    }
}

