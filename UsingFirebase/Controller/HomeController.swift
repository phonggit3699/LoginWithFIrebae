//
//  HomeController.swift
//  UsingFirebase
//
//  Created by PHONG on 19/08/2021.
//

import UIKit


class HomeController: UIViewController {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var userId: String {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else {
            return ""
        }
        return userId
    }
    var avatarImg: UIImage?
    
    var avatarURL: URL? {
        return UserDefaults.standard.url(forKey: "photoUrl")
    }
    
    var rightBarButton: UIButton {
        let button = UIButton()
        setupButton(button: button)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        return button
    }
    
    @IBOutlet weak var ListChat: UITableView!
    
    
    @IBAction func Logout() {
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginController
        AuthViewModel.shared.logout()
        dismiss(animated: true, completion: nil)
        present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListChat.delegate = self
        ListChat.dataSource = self
        self.title = "Chat Chit"
        
        let leftBarButton = UIButton()
        setupButton(button: leftBarButton)
        leftBarButton.addTarget(self, action: #selector(self.pushProfile), for: .touchUpInside)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        StorageViewModel.shared.getImageProfile(url: avatarURL) { img in
            leftBarButton.setImage(img, for: .normal)
            self.avatarImg = img
        }
        
        
        
    }
    
    func setupButton(button: UIButton){
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "circle.dashed.inset.fill"), for: .normal)
        button.tintColor = UIColor.black
    }
    
    
    @objc func pushProfile(){
        let profileVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileController
        profileVC.title = "Profile"
        profileVC.navigationItem.largeTitleDisplayMode = .never
        profileVC.avatar = self.avatarImg
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exRoom.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListNameChat", for: indexPath) as! ListChatCell
        exRoom.forEach { room in
            if userId == room.id {
                cell.configure(namechat: room.listRoom[indexPath.row].name) {
                    let chatVC = self.storyboard!.instantiateViewController(withIdentifier: "ChatVC") as! ChatController
                    chatVC.title = room.listRoom[indexPath.row].name
                    chatVC.friendRoom = room.listRoom[indexPath.row]
                    chatVC.navigationItem.largeTitleDisplayMode = .never
                    self.navigationController?.pushViewController(chatVC, animated: true)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "VIP"
    }
    
    
}
