//
//  ResultVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 01/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var resultImgView: UIImageView!
    
    

    // MARK:- Variables
    var resultImage: String = ""

    
    
    // MARK:- Methods
    override func viewDidLoad() {
        resultImgView.image = UIImage(named: resultImage)
        
        // 배경 이미지 꽉차게 설정
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "back_result")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    
    
    // MARK:- Actions
 
    
}
