//
//  MyPlaceDetailVC.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/4/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit
import GoogleMaps

enum ProvinceID :Int{
    case One = 1,Two,Three,countID
    var GetName: String {
        switch self {
        case .One:
            return "Bangkok and vicinity"
        case .Two:
            return "Chiang Mai"
        case .Three:
            return "Phuket"
        default:
            return ""
        }
    }
    
}
enum PlaceSizeID :Int{
    case One = 1,Two,Three,Four,Five,Six=6,Eight=8
    
    var GetName: String {
        switch self {
        case .One:
            return "Condo 1 BR (40 sq.m)"
        case .Two:
            return "Condo 1 BR (50 sq.m.)"
        case .Three:
            return "Condo 2 BR (80 sq.m.)"
        case .Four:
            return "Condo 3 BR (100 sq.m.)"
        case .Five:
            return "House/ Townhome (100 sq.m.)"
        case .Six:
            return "House/ Townhome (100-200 sq.m.)"
        case .Eight:
            return "Office/ Workplace (20 sq.m.)"
        default:
            return ""
        }
    }
    
    var CountID: Int {
        return 7
    }
        
    
    
}

protocol MyPlaceDetailProtocol:class {
    func updateViewWithNewData(newDataItem: MyPlaceDataModelItem)
}

class MyPlaceDetailVC: UIViewController {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeSizeIDLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var provinceIDLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
     var latitude: Double!
     var longtitude: Double!
    
    var item: MyPlaceDataModelItem!
    
    var posRowDetail: Int!
    
    var dataSource = MyPlaceDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureDetails()
    }
    
    public func configureDetails(){
        
        latitude = Double(item.latitude!)
        longtitude = Double(item.longtitude!)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: 15.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        marker.map = mapView
        
        
        
        placeNameLabel.text = item.place_name
        placeSizeIDLabel.text = PlaceSizeID.init(rawValue: Int(item.place_size_id!)!)?.GetName
        remarkLabel.text = item.remark
        provinceIDLabel.text = ProvinceID.init(rawValue: Int(item.province_id!)!)?.GetName 
        
        locationLabel.text = item.address
        
        
        
        
    
    
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="editingDetail" {
            let navController = segue.destination as! UINavigationController
            let vc = navController.viewControllers.first as! MyPlaceAddNewVC
            vc.isEditDetail = true
            vc.posRowEdit = posRowDetail
            vc.dataSource = dataSource
            vc.delegate = self
            vc.itemEdit = item
            
        
            
        }
    }
    
}

extension MyPlaceDetailVC:MyPlaceDetailProtocol{
    func updateViewWithNewData(newDataItem: MyPlaceDataModelItem){
        item = newDataItem
        configureDetails()
    
 
        
    }
}
