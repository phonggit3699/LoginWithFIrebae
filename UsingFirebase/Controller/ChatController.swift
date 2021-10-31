//
//  ChatController.swift
//  UsingFirebase
//
//  Created by PHONG on 23/08/2021.
//

import UIKit

class ChatController: UIViewController {
    
    var currentUser: String {
        guard let curUser = UserDefaults.standard.string(forKey: "username") else {
            return ""
        }
        return curUser
    }
    
    var userId: String {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else {
            return ""
        }
        return userId
    }
    
    var friendRoom: RoomDetailModel = RoomDetailModel(roomID: "", name: "")
    
    @IBOutlet weak var textInput: UITextField!
    
    
    @IBAction func SendMess() {
        guard let mess = textInput.text else {
            return
        }
        if mess != ""{
            ChatViewModel.shared.sendMessage(chat: ChatModel(id: nil, name: currentUser, user: User(id: userId, name: currentUser), message: mess, date: Date()), room: friendRoom.roomID)
        }
        self.ChatViewTable.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        self.textInput.resignFirstResponder()
        textInput.text = ""
    }
    @IBOutlet weak var ChatViewTable: UITableView!
    
    
    
    var allChatMess: [ChatModel] = []
    
    @IBOutlet weak var lbTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatViewTable.delegate = self
        ChatViewTable.dataSource = self
        textInput.delegate = self
        
        ChatViewModel.shared.getMessage(room: friendRoom.roomID){ data in
            self.allChatMess = data
            self.ChatViewTable.reloadData()
            self.ChatViewTable.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        }
        //TODO: fix keyboard cover view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            view.frame.origin.y = -keyboardHeight           }
        
    }
    @objc func keyboardWillHide(notification: Notification){
        view.frame.origin.y = 0
    }
    
}
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allChatMess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.allChatMess.isEmpty{
            if self.allChatMess[indexPath.row].user.name == currentUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: "rightMess", for: indexPath) as! RightMessCell
                cell.configure(mess: self.allChatMess[indexPath.row].message)
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftMess", for: indexPath) as! LeftMessCell
                cell.configure(mess: self.allChatMess[indexPath.row].message)
                cell.selectionStyle = .none
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "leftMess", for: indexPath) as! LeftMessCell
            
            return cell
        }
    }
}

extension ChatController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textInput.resignFirstResponder()
        return true
    }
}

