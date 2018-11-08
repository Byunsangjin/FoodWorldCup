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
    
    
    
    // MARK:- Constants
    let locationManager = CLLocationManager()
    var mapPoint: MTMapPoint?
    

    // MARK:- Methods
    override func viewDidLoad() {
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
        
        
        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.setMapCenter(mapPoint, animated: false)
        mapView.currentLocationTrackingMode = .onWithoutHeading
        
        self.view.addSubview(mapView)
    }
    

    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        print("중심 이동중")
    }
    
    
    
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print(location.mapPointGeo().latitude)
        print(location.mapPointGeo().longitude)
    }
    
    
    

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    
    
    // Actions
    
}
