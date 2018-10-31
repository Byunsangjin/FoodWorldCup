//
//  ViewController.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 26/10/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    
    // Outlets
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var facebookLoginBtn: FBSDKLoginButton!
    
    
    
    // Variables
    
    
    
    // Constants
    let userDefault = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        facebookLoginBtn.delegate = self
        facebookLoginBtn.readPermissions = ["public_profile", "email"] // 추가 읽기 권한을 요청
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        email.text = ""
        password.text = ""
        
        if userDefault.bool(forKey: "usersignedin") {
            guard let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") else {
                return
            }
            present(mainvc, animated: false)
        }
        
    }
    
    
    
    // 유저 로그인
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.moveToMainVC()
            } else if error?._code == AuthErrorCode.userNotFound.rawValue { // 이메일이 틀렸을 때
                self.alert("이메일이 틀립니다.")
            } else if error?._code == AuthErrorCode.wrongPassword.rawValue { // 비밀번호가 틀렸을 때
                self.alert("비밀번호가 틀립니다.")
            } else {
                self.alert("\(error?.localizedDescription)")
            }
        }
    }
    
    
    // 페이스북 로그인 버튼
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult?, error: Error!) {
        if result?.token == nil {
            return
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if error == nil {
                    // 유저 로그인값 true
                    self.userDefault.set(true, forKey: "usersignedin")
                    self.userDefault.synchronize()
                    
                    self.moveToMainVC()
                } else if error?._code == AuthErrorCode.accountExistsWithDifferentCredential.rawValue {
                    self.alert("동일한 이메일로 가입되어있습니다.\n 다른 방법으로 로그인해주세요")
                }
            }
            
            // 토큰을 통해 로그인 되자마자 로그아웃 시킨다.
            FBSDKLoginManager().logOut()
        }
    }
    
    

    // 페이스북 로그아웃 버튼
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    
    }
    
    
    func moveToMainVC() {
        // 유저 로그인값 true
        self.userDefault.set(true, forKey: "usersignedin")
        self.userDefault.synchronize()
        
        guard let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") else {
            return
        }
        
        // 메인화면으로 이동
        self.present(mainvc, animated: false)
    }
    
    
    // Actions
    @IBAction func signInPressed(_ sender: Any) {
        signInUser(email: self.email.text!, password: self.password.text!)
    }
    
    
    
    
    
    
    
}

