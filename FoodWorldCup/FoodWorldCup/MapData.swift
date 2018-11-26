//
//  MapData.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 26/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

// REST API를 이용해 지도 정보를 받아오는 클래스
class MapData {
    // MARK:- Variables
    var MapList = [MapDataVO]()
    var keyword = "짜장면"
    var x = "126.811181"
    var y = "37.463845"
    var radius = "3000"
    
    
    // MARK:- Constants
    let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    let headers: HTTPHeaders = [
        "Authorization" : "KakaoAK 05c120c8362e0943da53898d2bc8a308"
    ]
    
    
    
    // MARK:- Methods
    func make() {
        let params: Parameters = [
            "query" : "\(keyword)",
            "x" : "\(x)",
            "y" : "\(y)",
            "radius" : "\(radius)"
        ]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseObject { (response: DataResponse<MapDataDTO>) in
            let addressDTO = response.result.value
            
            if let documents = addressDTO?.document {
                for document in documents {
                    var mapVO = MapDataVO()
                    
                    print(document.address!)
                    print(document.name!)
                    print("x=\(Double(document.x!)!)")
                    print("y=\(Double(document.y!)!)")
                    print("=============")
                    
                    // mapVO 객체에 담아 MapList에 추가
                    mapVO.name = document.name!
                    mapVO.phone = document.phone!
                    mapVO.address = document.address!
                    mapVO.roadAddress = document.roadAddress!
                    mapVO.x = (Double(document.x!))!
                    mapVO.y = (Double(document.y!))!
                    
                    self.MapList.append(mapVO)
                }
            }
            print("MapList : \(self.MapList.count)")
        }
        
    }
    
    
    
    
    
}
