//
//  MapVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 01/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireObjectMapper

class MapVC: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK:- Variables
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var currentLat: String? // 현재 위치 위도
    var currentLng: String? // 현재 위치 경도
    var radius: String? = "2000" // 반경
    
    var MapList = [MapDataVO]() // REST API를 이용해 받은 주변 정보
    
    var resultFood: String? // 최종 선택 음식
    
    
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    let ud = UserDefaults.standard
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 위치 사용 인증 요청
        self.requestAuthoriztion()
        
        // 맵뷰 세팅
        self.mapViewSet()
        
        // 최종 선택 음식 키워드 정의
        self.resultFood = self.getFoodName()
        
        // 뷰에 맵 추가
        self.view.insertSubview(self.mapView, at: 0)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // 주변 장소
        self.getMapInfo(keword: self.resultFood!, lng: self.currentLng!, lat: self.currentLat!, radius: self.radius!)
    }
    
    
    
    
    // 맵뷰 세팅 메소드
    func mapViewSet() {
        self.mapView.delegate = self
        self.mapView.baseMapType = .standard
        
        // 현재 위,경도 값 저장
        self.currentLat = String((locationManager.location?.coordinate.latitude)!)
        self.currentLng = String((locationManager.location?.coordinate.longitude)!)
        
        // 트랙킹 모드 & 나침반 모드 ON
        self.mapView.currentLocationTrackingMode = .onWithoutHeading
    }
    
    
    
    // 위치 사용 인증 요청 메소드
    func requestAuthoriztion() {
        // 위치 사용 인증 요청
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        // 인증 요청을 승인 했다면
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    // 마커 생성 메소드
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = name
        poiItem.markerType = .customImage //커스텀 타입으로 변경
        
        if name.elementsEqual("현재위치") == true {
            poiItem.customImage = UIImage(named: "user_marker3") //커스텀 이미지 지정
        } else {
            poiItem.customImage = UIImage(named: "gps_button") //커스텀 이미지 지정
        }
        
        poiItem.markerSelectedType = .customImage //선택 되었을 때 마커 타입
        poiItem.customSelectedImage = UIImage(named: "user_marker3") //선택 되었을 때 마커 이미지 지정
        poiItem.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        poiItem.showAnimationType = .noAnimation
        poiItem.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)
        
        return poiItem
    }
    
    
    
    // 주변 장소 정보 받는 메소드
    func getMapInfo(keword keyword: String, lng x: String, lat y: String, radius radius: String) {
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = [
            "Authorization" : "KakaoAK 05c120c8362e0943da53898d2bc8a308"
        ]
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
                    let mapVO = MapDataVO()
                    
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
            
            // 마커 찍기
            self.showMarker()
        }
    }
    
    
    
    // 받아온 장소정보를 이용해 마커를 띄워준다.
    func showMarker() {
        var items = [MTMapPOIItem]() // 마커 배열
        items.append(self.poiItem(name: "현재위치", latitude: Double(self.currentLat!)!, longitude: Double(self.currentLng!)!)) // 현재 위치 마커 추가
        
        // 주변 장소 마커 추가
        for data in self.MapList {
            items.append(self.poiItem(name: data.name!, latitude: data.y!, longitude: data.x!))
        }
        
        self.mapView.addPOIItems(items) // 맵뷰에 마커 추가
        self.mapView.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
    
    // 이미지 이름으로 음식 이름 받아 오는 메소드
    func getFoodName() -> String {
        var result = ud.string(forKey: "resultFood")
        
        switch result {
        case "food1":
            return "족발"
        case "food2":
            return "치킨"
        case "food3":
            return "보쌈"
        case "food4":
            return "짜장면"
        case "food5":
            return "백반"
        case "food6":
            return "돈까스"
        case "food7":
            return "햄버거"
        case "food8":
            return "냉면"
        default:
            return ""
        }
    }
    
    
    
    // Actions
    
}
