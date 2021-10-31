//
//  LeftMessCell.swift
//  UsingFirebase
//
//  Created by PHONG on 27/08/2021.
//

import UIKit

class LeftMessCell: UITableViewCell {

    @IBOutlet weak var leftMess: UILabel!
    
    @IBOutlet weak var VStackLeftMess: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        VStackLeftMess.layer.cornerRadius = 15

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(mess: String){
        self.leftMess.text = mess
    }
}


