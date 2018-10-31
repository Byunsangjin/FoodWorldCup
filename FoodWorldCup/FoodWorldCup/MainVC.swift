//
//  MainVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 27/10/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MainVC: UIViewController {
    // outlets
    @IBOutlet var email: UILabel!
    
    
    
    // Variables
    
    
    // Constants
    let userDefault = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //guard let email = Auth.auth().currentUser?.email else { return }
        //self.email.text = userDefault.string(forKey: email)
        
        self.email.textAlignment = .center
        self.email.text = Auth.auth().currentUser?.displayName
        //Auth.auth().currentUser?.delete(completion: nil)
    }
    
    
    
    // Actions
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            // usersignedin값 false
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            
            // 로그아웃
            try Auth.auth().signOut() // 이메일 로그아웃
            try GIDSignIn.sharedInstance()?.signOut() // 구글 로그아웃
            
            
            // 첫 화면으로 돌아가기
            self.dismiss(animated: false, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
