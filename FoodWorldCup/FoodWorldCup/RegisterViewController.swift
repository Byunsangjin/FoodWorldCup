//
//  RegisterViewController.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 26/10/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class RegisterViewController: UIViewController {
    // Outlets
    @IBOutlet var email: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var compPasswd: UITextField! // 확인용 암호
    
    
    // Variables
    
    
    
    // Constants
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        
    }
    
    
    
    @IBAction func register(_ sender: Any) {
        
        if email.text!.isEmpty || name.text!.isEmpty || password.text!.isEmpty { // 텍스트 필드에 입력하지 않은 값이 있으면
            self.alert("공백을 입력하세요.")
        } else if password.text != compPasswd.text {
            self.alert("비밀번호가 일치하지 않습니다.")
        } else if password.text!.count < 6 {
            self.alert("6자리이상의 비밀번호를 입력하세요.")
        } else {
            userDefault.set(name.text!, forKey: email.text!)
            createUser(email: email.text!, password: password.text!)
        }
        
        
        
    }
    
    
    
    // 유저 생성
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil { // 회원가입 성공
                self.alert("회원가입에 성공 하셨습니다.") {
                    self.navigationController?.popViewController(animated: false)
                }
            } else { // 회원가입 실패
                self.alert("회원가입 실패 : \(error?.localizedDescription)") {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }
}
