//
//  RightMessCell.swift
//  UsingFirebase
//
//  Created by PHONG on 27/08/2021.
//

import UIKit

class RightMessCell: UITableViewCell {

    @IBOutlet weak var rightMess: UILabel!
    
    @IBOutlet weak var VstackRightMess: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        VstackRightMess.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(mess: String){
        self.rightMess.text = mess
    }

}
