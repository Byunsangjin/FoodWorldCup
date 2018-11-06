//
//  SelectFoodVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 01/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit

class SelectFoodVC: UIViewController {
    // Outlets
    @IBOutlet var topImageView: UIImageView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        topImageView.isUserInteractionEnabled = true
        topImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        topImageView.image = UIImage(named: "food5")
    }
    
    
    
    // Actions
    
    

}
