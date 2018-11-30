//
//  RandomFoodVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 29/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreData

class RandomFoodVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stopBtn: UIButton!
    
    
    
    // MARK:- Variables
    var foodList = ["food1", "food2", "food3", "food4", "food5", "food6", "food7", "food8"]
    
    
    
    
    // MARK:- Constants
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidAppear(_ animated: Bool) {
        // 배경 이미지 꽉차게 설정
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backImage.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        // 내비게이션 숨기기
        //self.navigationController?.isNavigationBarHidden = true
        
        // 첫 음식 사진
        self.imageView.image = UIImage(named: self.foodList[Int.random(in: 0...7)])
        
        // 애니메이션 이미지 배열 정의
        var imageArr = [UIImage]()
        for data in self.foodList {
            imageArr.append(UIImage(named: data)!)
        }
        
        // 애니메이션 이미지 배열
        self.imageView.animationImages = imageArr
        
        // 애니메이션 속성 설정
        self.imageView.animationDuration = 0.7
        //self.imageView.animationRepeatCount = 5
        
        // 애니메이션 시작
        self.imageView.startAnimating()
        
        // 결과 음식 이미지 설정
        let rand = Int.random(in: 0...7)
        self.imageView.image = UIImage(named: self.foodList[rand])
        
        self.ud.set(self.foodList[rand], forKey: "resultFood")
    }
    
    
    
    // MARK:- Actions
    @IBAction func stopBtnPressed(_ sender: UIButton) {
        if self.stopBtn.tag == 0 { // Stop버튼 클릭 시
            // 애니메이션 멈추고 버튼 텍스트 변경
            self.imageView.stopAnimating()
            self.stopBtn.setTitle("주변 위치 확인", for: .normal)
            
            // 태그 변경
            self.stopBtn.tag = 1
        } else { // 주변 위치 확인 버튼 클릭 시
            guard let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")  else {
                print("MapVC 실패")
                return
            }
            
            self.navigationController?.pushViewController(mapVC, animated: true)
            
            // 태그 변경
            self.stopBtn.tag = 0
        }
    }
}
