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
    
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    
    

    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapData.make()
        
        self.navigationController?.isNavigationBarHidden = false
        
        // 위치 사용 인증 요청
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        // 인증 요청을 승인 했다면
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.mapView.delegate = self
        self.mapView.baseMapType = .standard
        //self.mapView.setMapCenter(MTMapPoint(geoCoord: .init(latitude: 37.46224635789486, longitude: 126.81069738421284)), animated: true)
        
        // 트랙킹 모드 & 나침반 모드 ON
        self.mapView.currentLocationTrackingMode = .onWithoutHeading
        
        self.view.addSubview(mapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let list = mapData.MapList
        print("List Count : \(list.count)")
        var items = [MTMapPOIItem]()
        
        items.append(poiItem(name: "현재위치", latitude: 37.46224635789486, longitude: 126.81069738421284))
        for data in list {
            print("Title : \(data.name!)")
            print("latitude : \(data.name!)")
            items.append(poiItem(name: data.name!, latitude: data.y!, longitude: data.x!))
        }

        
        self.mapView.addPOIItems(items)
        self.mapView.fitAreaToShowAllPOIItems()  // 모든 마커가 보이게 카메라 위치/줌 조정
    }
    
    
    
    
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
