//
//  MyPlaceDataModel.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/6/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import Foundation
protocol MyPlaceDataModelDelegate: class {
    func didRecieveDataUpdate(data: [MyPlaceDataModelItem])
    func didFailDataUpdateWithError(error: Error)
    
    func didAddNewDataUpdate(data: MyPlaceDataModelItem)
    
    func didDeleteDataUpdate(placeID: Int)
    
    func didEditDataUpdate(newDataItem: MyPlaceDataModelItem,pos: Int)
}

extension MyPlaceDataModelDelegate {
    func didRecieveDataUpdate(data: [MyPlaceDataModelItem]) {
        
    }
    
    func didFailDataUpdateWithError(error: Error) {
        
    }
    
    func didAddNewDataUpdate(data: MyPlaceDataModelItem) {
        
    }
    
    func didDeleteDataUpdate(placeID: Int) {
        
    }
    
    func didEditDataUpdate(newDataItem: MyPlaceDataModelItem,pos: Int){
        
    }
    
    
}
class MyPlaceDataModel{
    
    weak var delegate:MyPlaceDataModelDelegate?
    func requestData(){
        
        var dataItems: [MyPlaceDataModelItem] = []
        
        let newItem = MyPlaceDataModelItem()
        newItem.address = "this is a test address from MVC model"
        newItem.place_name = "place name MVC"
        newItem.id = "1"
        newItem.latitude = "18.79974300"
        newItem.longtitude = "98.96545100"
        newItem.place_size_id = "1"
        newItem.province_id = "1"
        newItem.remark = "Liv@Nimman Condo\nห้อง 702\n\n** ไปรับผ้าปูที่ร้าน We Care Laundry ติดต่อคุณอ้อม เบอร์โทร 0899316544 ให้แจ้งว่ามารับผ้าปูขนาด 6 ฟุต ของคุณ ฮู้ดครับ\nก่อนรับผ้าต้อง แกะห่อผ้าออกมานับด้วย (ป้องกันของขาด) ดังนี้\n\n - ผ้าปูเตียง 6ฟุต จำนวน 1 ผืน\n- ปลอกผ้านวม 6ฟุต จำนวน 1 ผืน\n- ปลอกหมอน 4 ใบ\n-  ผ้าเช็ดตัว 2 ผืน\n- ผ้าเช็ดผม 2 ผืน\n- ผ้าเช็ดเท้า 2 ผืน\n- "
        
        dataItems.append(newItem)
        
        delegate!.didRecieveDataUpdate(data: dataItems)
        
        
    }
    
    func addNewData(newItem: MyPlaceDataModelItem, completionHandler : @escaping (Bool) -> ()){
        //Post to server
        
        delegate!.didAddNewDataUpdate(data: newItem)
        completionHandler(true)
   
        
    }
    
    func deleteDataWithID(placeID : Int){
        //Post id to server
        delegate!.didDeleteDataUpdate(placeID: placeID)
    }
    
    func editDataWithID(newDataItem: MyPlaceDataModelItem,position: Int, completionHandler : @escaping (Bool) -> ()){
        
        delegate!.didEditDataUpdate(newDataItem: newDataItem, pos: position)
        completionHandler(true)
    }
}
