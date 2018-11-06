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
import NaverThirdPartyLogin
import Alamofire

class ViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    // Outlets
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var facebookLoginBtn: FBSDKLoginButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton! {
        didSet{
            logoutBtn.isHidden = true
        }
    }
    
    
    // Variables
    
    
    
    // Constants
    let userDefault = UserDefaults.standard
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        facebookLoginBtn.delegate = self
        facebookLoginBtn.readPermissions = ["public_profile", "email"] // 추가 읽기 권한을 요청
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.email.text = ""
        self.password.text = ""
        
        self.password.resignFirstResponder()
        
        if userDefault.bool(forKey: "usersignedin") {
            guard let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") else {
                return
            }
            self.navigationController?.pushViewController(mainvc, animated: false)
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
    
    // 메인뷰로 이동하는 메소드
    func moveToMainVC() {
        // 유저 로그인값 true
        self.userDefault.set(true, forKey: "usersignedin")
        self.userDefault.synchronize()
        
        guard let mainvc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") else {
            return
        }
        
        // 메인화면으로 이동
        self.navigationController?.pushViewController(mainvc, animated: true)
    }
    
    
    // Actions
    @IBAction func signInPressed(_ sender: Any) {
        signInUser(email: self.email.text!, password: self.password.text!)
    }
    
    
    // Kakao 로그인
    @IBAction func loginKakao(_ sender: Any) {
        let session = KOSession.shared()
        
        if let s = session { // 로그인 세선이 생성 되었으면
            // 이전 열린 세선은 닫고
            if s.isOpen() {
                s.close()
            }
            
            s.open(completionHandler: { (error) in
                
                if error == nil { // 에러가 없으면
                    if s.isOpen() { // 로그인 성공
                        self.moveToMainVC()
                    } else { // 로그인 실패
                        self.alert("로그인 실패")
                    }
                } else { // 로그인 에러
                    
                }
            })
        } else { // 세선 생성 실패
            print("세션 생성 실패")
        }
    }
    
    
    // Naver 로그인
    @IBAction func handleLogin(_ sender: Any) { // ----- 1
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
        
        self.moveToMainVC()
        print("네이버 로그인 성공")
    }
    
    
    
    // Naver 로그아웃
    @IBAction func handleLogout(_ sender: Any) { // ----- 2
        //        loginConn?.resetToken() // 로그아웃
        loginInstance?.requestDeleteToken() // 연동해제
        logoutBtn.isHidden = true
        loginBtn.isHidden = false
    }
    
    
}



extension ViewController: NaverThirdPartyLoginConnectionDelegate{
    // 네이버 앱이 설치되어 있지 않다면 사파리를 통해 인증 진행 화면을 띄운다.
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        present(naverSignInViewController, animated: true, completion: nil)
    }
    
    
    // 접근 토큰과 갱신 토큰을 성공적으로 받아왔을 때 호출되는 메소드
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    
    
    // 접근 토큰과 갱신 토큰을 성공적으로 받아왔을 때 호출되는 메소드
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    
    
    // 연동이 성공적을 해제되었을 때 호출되는 메소드
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    
    
    
    // 접근 토큰, 갱신 토큰, 연동 해제등이 실패했을 때 호출되는 메소드
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        print(error)
    }
    
    
    
    // 접근 토큰이나 갱신 토큰이 발급되었을 때 실행되어야 할 메소드로 해당 토큰으로 실질적인 사용자 정보에 접근하는 메소드
    func getNaverEmailFromURL(){
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}
        
        let authorization = "\(tokenType) \(accessToken)"
        Alamofire.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let birthday = object["birthday"] as? String else {return}
            guard let name = object["name"] as? String else {return}
            guard let email = object["email"] as? String else {return}
        }
    }
}
