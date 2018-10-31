//
//  Utils.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 30/10/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(_ message: String, completion: (()->Void)? = nil) {
        // 메인 스레드에서 실행되도록
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                completion?() // completion 매개변수의 값이 nil이 아닐때만 실행
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: false)
        }
    
    }
}
