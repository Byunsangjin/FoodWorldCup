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
    
    
    
    // Variables
    
    
    // Constants
    let userDefault = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("화면 뜸!!")
        self.navigationController?.isNavigationBarHidden = false
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
            
            
            let koSession = KOSession.shared()
            if let session = koSession {
                // KOSessionTask.unlinkTask(completionHandler: nil) 카카오 로그인 연동 해제
                session.logoutAndClose(completionHandler: nil)
                print("kakao 로그아웃")
            }
            
            // 로그인 화면으로 돌아가기
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    // 푸드 월드컵 시작
    @IBAction func startPressed(_ sender: Any) {
        guard let selectFoodVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectFoodVC") else {
            print("SelectFoodVC 실패")
            return
        }
        
        self.navigationController?.pushViewController(selectFoodVC, animated: true)
    }
    
    
    
    // 이전 결과 확인
    @IBAction func resultPressed(_ sender: Any) {
        guard let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultVC") else {
            print("ResultVC 실패")
            return
        }
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
    
    // UnWind 세그웨이
    @IBAction func gotoMainVC(_ sender: UIStoryboardSegue) {
        
    }
    
}
