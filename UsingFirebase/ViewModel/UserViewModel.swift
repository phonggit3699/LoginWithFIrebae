//
//  UserViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 16/08/2021.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject{
    let db = Firestore.firestore()
    var ref: DocumentReference?
    static let shared = UserViewModel()
    
    init() {}
    
    func postProfile(id: String, user: UserModel) {
        
        do {
            
            try db.collection("Users").document(id).setData(from: user)
        } catch let error {
            print("Error writing city to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getProfileByID(id: String,_ com: @escaping (UserModel) -> Void){
        let docRef = db.collection("Users").document(id)
        docRef.getDocument{ (document, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            
            if let document = document, document.exists {
                do {
                    let userData = try document.data(as: UserModel.self)
                    DispatchQueue.main.async {
                        com(userData!)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    
}
