//
//  MapVC.swift
//  FoodWorldCup
//
//  Created by Byunsangjin on 01/11/2018.
//  Copyright © 2018 Byunsangjin. All rights reserved.
//

import UIKit
import CoreLocation

class MapVC: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK:- Variables
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var mapData = MapData()
    //var mapPoint: MTMapPoint?
    var lat: String?
    var lng: String?
    var radius: String?
    
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    
    
    

    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내비게이션바 띄우기
        self.navigationController?.isNavigationBarHidden = false
        
        // 위치 사용 인증 요청
        self.requestAuthoriztion()
        
        // 맵뷰 세팅
        self.mapViewSet()
        
        
        
        
        
        
        
        // 뷰에 맵 추가
        self.view.insertSubview(self.mapView, at: 0)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        // REST API를 이용해 list 만들기
        mapData.make(keword: "짜장면", lng: lng!, lat: lat!, radius: "2000")
        
        let list = mapData.MapList // 장소 정보 리스트
        var items = [MTMapPOIItem]() // 마커 배열
        
        items.append(poiItem(name: "현재위치", latitude: 37.46224635789486, longitude: 126.81069738421284)) // 현재 위치 마커 추가
        
        // 주변 장소 마커 추가
        for data in list {
            items.append(poiItem(name: data.name!, latitude: data.y!, longitude: data.x!))
        }

        self.mapView.addPOIItems(items) // 맵뷰에 마커 추가
        self.mapView.fitAreaToShowAllPOIItems() // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
    
    // 맵뷰 세팅
    func mapViewSet() {
        self.mapView.delegate = self
        self.mapView.baseMapType = .standard
        //self.mapView.setMapCenter(MTMapPoint(geoCoord: .init(latitude: 37.46224635789486, longitude: 126.81069738421284)), animated: true)
        
        // 트랙킹 모드 & 나침반 모드 ON
        self.mapView.currentLocationTrackingMode = .onWithoutHeading
        
    }
    
    
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        self.lat = String(location.mapPointGeo().latitude)
        self.lng = String(location.mapPointGeo().longitude)
        print("\(lat)=========================")
        print("\(lng)=========================")
    }
    
    
    
    // 위치 사용 인증 요청
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
    
    
    
    // 마커 생성
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
    
    
        
        
    
    
    
    // Actions
    
}
