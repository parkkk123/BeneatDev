//
//  MyPlaceDataModel.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/6/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol MyPlaceDataModelDelegate: class {
    func didRecieveDataUpdate(data: [MyPlaceDataModelItem])
    func didFailDataUpdateWithError(error: Error)
    
    func didAddNewDataUpdate(data: MyPlaceDataModelItem)
    
    func didDeleteDataUpdate(pos: Int,success: Bool)
    
    func didEditDataUpdate(newDataItem: MyPlaceDataModelItem,pos: Int)
    
    func didLoadMoreReceiveDataUpdate(data: [MyPlaceDataModelItem],success: Bool)
}

extension MyPlaceDataModelDelegate {
    func didRecieveDataUpdate(data: [MyPlaceDataModelItem]) {
        
    }
    
    func didFailDataUpdateWithError(error: Error) {
        
    }
    
    func didAddNewDataUpdate(data: MyPlaceDataModelItem) {
        
    }
    
    func didDeleteDataUpdate(pos: Int,success: Bool) {
        
    }
    
    func didEditDataUpdate(newDataItem: MyPlaceDataModelItem,pos: Int){
        
    }
    
    func didLoadMoreReceiveDataUpdate(data: [MyPlaceDataModelItem],success: Bool){
        
    }
    
    
}
class MyPlaceDataModel{
    
    weak var delegate:MyPlaceDataModelDelegate?
    func requestData(page: Int,user_id: Int){
        
        var dataItems: [MyPlaceDataModelItem] = []
        
//        let newItem = MyPlaceDataModelItem()
//        newItem.address = "this is a test address from MVC model"
//        newItem.place_name = "place name MVC"
//        newItem.id = "1"
//        newItem.latitude = "18.79974300"
//        newItem.longtitude = "98.96545100"
//        newItem.place_size_id = "1"
//        newItem.province_id = "1"
//        newItem.remark = "Liv@Nimman Condo\nห้อง 702\n\n** ไปรับผ้าปูที่ร้าน We Care Laundry ติดต่อคุณอ้อม เบอร์โทร 0899316544 ให้แจ้งว่ามารับผ้าปูขนาด 6 ฟุต ของคุณ ฮู้ดครับ\nก่อนรับผ้าต้อง แกะห่อผ้าออกมานับด้วย (ป้องกันของขาด) ดังนี้\n\n - ผ้าปูเตียง 6ฟุต จำนวน 1 ผืน\n- ปลอกผ้านวม 6ฟุต จำนวน 1 ผืน\n- ปลอกหมอน 4 ใบ\n-  ผ้าเช็ดตัว 2 ผืน\n- ผ้าเช็ดผม 2 ผืน\n- ผ้าเช็ดเท้า 2 ผืน\n- "
//        
        
        
        let router = AlamofireRouter.getDataMyPlace(page: page, user_id: user_id)
        Alamofire.request(router).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    guard json["error"].boolValue != true else {
                        print(json["message"].stringValue)
                        return
                    }
                    
                    for (value) : (JSON) in json["listings"].arrayValue {
                        let newItem = MyPlaceDataModelItem()
                        newItem.address = value["address"].stringValue
                        newItem.place_name = value["place_name"].stringValue
                        newItem.id = value["id"].stringValue
                        newItem.latitude = value["latitude"].stringValue
                        newItem.longitude = value["longitude"].stringValue
                        newItem.place_size_id = value["place_size_id"].stringValue
                        newItem.province_id = value["province_id"].stringValue
                        newItem.remark = value["remark"].stringValue
                        
                        dataItems.append(newItem)
                        
                        
                    }
                    self.delegate!.didRecieveDataUpdate(data: dataItems)
                }
                
            case .failure(let error):
                print(error)
                return
            }
        }
        
        
    }
    
    func addNewData(newItem: MyPlaceDataModelItem, completionHandler : @escaping (Bool) -> ()){
        //Post to server
        
        let router = AlamofireRouter.addMyPlace(item: newItem)
        Alamofire.request(router).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    guard json["error"].boolValue != true else {
                        print(json["message"].stringValue)
                        completionHandler(false)
                        return
                    }
                    print("successful added \(json)")
                    newItem.id = json["id"].stringValue
                    self.delegate!.didAddNewDataUpdate(data: newItem)
                    completionHandler(true)
                }
                
            case .failure(let error):
                print(error)
                completionHandler(false)
                return
            }
        }
        
        
        
   
        
    }
    
    func deleteDataWithID(placeID : String,pos: Int){
        //Post id to server
        
        let router = AlamofireRouter.deleteMyPlace(id: placeID)
        Alamofire.request(router).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    guard json["error"].boolValue != true else {
                        print(json["message"].stringValue)
                        self.delegate!.didDeleteDataUpdate( pos: pos, success: false)
                        return
                    }
                    
                    self.delegate!.didDeleteDataUpdate( pos: pos, success: true)
                   
                }
                
            case .failure(let error):
                print(error)
                self.delegate!.didDeleteDataUpdate(pos: pos, success: false)
                return
            }
        }
        
        
    }
    
    func editDataWithID(newDataItem: MyPlaceDataModelItem,position: Int, completionHandler : @escaping (Bool) -> ()){
        
        let router = AlamofireRouter.updateMyPlace(id: newDataItem.id!, item: newDataItem)
        Alamofire.request(router).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    guard json["error"].boolValue != true else {
                        print(json["message"].stringValue)
                        completionHandler(false)
                        return
                    }
                    
                    self.delegate!.didEditDataUpdate(newDataItem: newDataItem, pos: position)
                    completionHandler(true)
                }
                
            case .failure(let error):
                print(error)
                completionHandler(false)
                return
            }
        }
        
        
    }
    
    func loadMore(_ page: Int,user_id: Int){
        let router = AlamofireRouter.getDataMyPlace(page: page, user_id: user_id)
        Alamofire.request(router).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    guard json["error"].boolValue != true else {
                        print(json["message"].stringValue)
                        self.delegate?.didLoadMoreReceiveDataUpdate(data: [], success: false)
                        return
                    }
                    var dataItems: [MyPlaceDataModelItem] = []
                    
                    for (value) : (JSON) in json["listings"].arrayValue {
                        let newItem = MyPlaceDataModelItem()
                        newItem.address = value["address"].stringValue
                        newItem.place_name = value["place_name"].stringValue
                        newItem.id = value["id"].stringValue
                        newItem.latitude = value["latitude"].stringValue
                        newItem.longitude = value["longitude"].stringValue
                        newItem.place_size_id = value["place_size_id"].stringValue
                        newItem.province_id = value["province_id"].stringValue
                        newItem.remark = value["remark"].stringValue
                        
                        dataItems.append(newItem)
                        
                        
                    }

                    
                     self.delegate?.didLoadMoreReceiveDataUpdate(data: dataItems, success: true)
                    
                }
                
            case .failure(let error):
                print(error)
                
                return
            }
        }
        
       
    }
}
