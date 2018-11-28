//
//  SelectFoodVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 01/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

// 토너먼트 몇강인지
enum Tournament {
    case quarterfinal
    case semifinal
    case final
}

class SelectFoodVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var bottomImageView: UIImageView!
    
    
    
    // MARK:- Variables
    var foodList = ["food1", "food2", "food3", "food4", "food5", "food6", "food7", "food8"]
    var topNum = 6
    var bottomNum = 7
    var tournament: Tournament = Tournament.quarterfinal // 현재 토너먼트가 몇강인지 나타내 주는 변수
    
    
    
    // MARK:- Constants
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        
        // 내비게이션 바 숨김
        self.navigationController?.isNavigationBarHidden = true
        
        // 배경 이미지 설정
        backgroundImage.image = UIImage(named: "back_quarter_final")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        // 이미지 뷰 초기화
        drawImage()
        
        let tapTopImageView = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.topImageView.isUserInteractionEnabled = true
        self.topImageView.addGestureRecognizer(tapTopImageView)
        
        let tapBottomImageView = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.bottomImageView.isUserInteractionEnabled = true
        self.bottomImageView.addGestureRecognizer(tapBottomImageView)
    }
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (tapGestureRecognizer.view?.tag)! == 1 { // topImageView 선택시
            foodList.remove(at: bottomNum)
        } else { // bottomImageView 선택시
            foodList.remove(at: topNum)
        }
        
        switch tournament {
        case .quarterfinal:
            quarterfinal()
            break
        case .semifinal:
            semifinal()
            break
        case .final:
            final()
            break
        }
    }
    
    
    // 8강
    func quarterfinal() {
        if topNum == 0 {
            self.tournament = .semifinal
            
            // 4강 시작
            bottomNum = foodList.count - 1
            topNum = bottomNum - 1
            
            // 배경 사진 4강으로 바꾸기
            backgroundImage.image = UIImage(named: "back_semi_final")
            drawImage()
            
            return
        }
        
        // 다음 비교할 사진의 배열 번호
        topNum -= 2
        bottomNum -= 2
        
        drawImage()
    }
    
    
    
    // 4강
    func semifinal() {
        if topNum == 0 {
            self.tournament = .final
            
            // 결승 시작
            bottomNum = foodList.count - 1
            topNum = bottomNum - 1
            
            // 배경 사진 결승으로 바꾸기
            backgroundImage.image = UIImage(named: "back_final")
            
            drawImage()
            
            return
        }
        
        // 다음 비교할 사진의 배열 번호
        topNum -= 2
        bottomNum -= 2
        
        drawImage()
    }
    
    
    
    // 결승
    func final() {
        guard let resultvc = self.storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC else {
            print("에러")
            return
        }
        
        ud.set(foodList[0], forKey: "resultFood")
        //resultvc.resultImage = foodList[0]
        
        self.navigationController?.pushViewController(resultvc, animated: false)
    }
    
    
    // 음식 이미지 그리기
    func drawImage() {
        topImageView.image = UIImage(named: foodList[topNum])
        bottomImageView.image = UIImage(named: foodList[bottomNum])
    }
    
    
    
    
    // MARK:- Actions
    // 그만할래요 버튼
    @IBAction func stopPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
