//
//  ProfileController.swift
//  UsingFirebase
//
//  Created by PHONG on 09/09/2021.
//

import UIKit

class ProfileController: UIViewController {
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var userId: String {
        guard let userId = UserDefaults.standard.string(forKey: "userID") else {
            return ""
        }
        return userId
    }
    var avatar: UIImage?
    var profile: UserModel?
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBAction func pickerAvatar(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = UIImagePickerController.SourceType.photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        print("run")
        present(vc, animated: true, completion: nil)
    }
    //TODO: Logout action
    @IBAction func logout() {
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginController
        AuthViewModel.shared.logout()
        dismiss(animated: true, completion: nil)
        present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserViewModel.shared.getProfileByID(id: userId) { data in
            self.profile = data
            self.lbPhone.text = "Phone \(data.phone)"
            self.lbAddress.text = "Address \(data.address)"
            self.lbUsername.text = data.name
        }
        
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.black.cgColor
        
        
        //TODO: settup for avatar image (img profile)
        avatarImg.layer.cornerRadius = avatarImg.frame.width / 2
        avatarImg.clipsToBounds = true
        if let avatar = self.avatar {
            avatarImg.image = avatar
        }
    
    }


}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickImage = info[.originalImage] as? UIImage{
            avatar = pickImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
