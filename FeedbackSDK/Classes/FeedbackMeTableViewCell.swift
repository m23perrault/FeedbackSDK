//
//  FeedbackMeTableViewCell.swift
//  FeedbackSDK
//
//  Created by Aravind Kumar on 04/04/19.
//

import UIKit

class FeedbackMeTableViewCell: UITableViewCell {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.innerView.layer.cornerRadius = 5.0;
        self.innerView.clipsToBounds = true;
    }

    
}
