//
//  ListChatCell.swift
//  UsingFirebase
//
//  Created by PHONG on 25/08/2021.
//

import UIKit

class ListChatCell: UITableViewCell {
    typealias ChooseChatAction = () -> Void
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var action: ChooseChatAction?

    @IBOutlet weak var nameChat: UIButton!
    
    @IBAction func ChooseChat() {
        self.action?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(namechat: String, action: @escaping ChooseChatAction) {
        self.nameChat.setTitle(namechat, for: .normal)
        self.action = action
    }
    
}
