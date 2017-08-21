//
//  RDHomeDayThingsTableViewCell.swift
//  fakeLekeHomePage
//
//  Created by sseen on 2017/8/21.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit

class RDHomeDayThingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btDelete: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSubTime: UILabel!
    @IBOutlet weak var lblSubAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imvIcon.backgroundColor = RD.Color.bgGray
        lblTitle.font = UIFont(custSize: .fontMiddle)
        lblTitle.textColor = RD.Color.titleBlack
        lblSubTitle.font = UIFont(.SystemRegular, size: .fontLarge)
        lblSubTitle.textColor = RD.Color.titleBlack
        
        lblTime.textColor = RD.Color.titleGray
        lblTime.font = UIFont(.SystemRegular, size: .fontSmall)
        lblSubTime.textColor = RD.Color.titleGray
        lblSubTime.font = UIFont(custSize: .fontSmall)
        lblSubAddress.textColor = RD.Color.titleGray
        lblSubAddress.font = UIFont(custSize: .fontSmall)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
