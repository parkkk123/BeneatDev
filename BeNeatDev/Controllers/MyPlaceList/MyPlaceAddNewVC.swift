//
//  MyPlaceAddNewVC.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/5/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit
import DropDown

class MyPlaceAddNewVC: UIViewController {
    
    @IBOutlet weak var namePlaceLabel: UITextField!
    @IBOutlet weak var selectType: UIButton!
    @IBOutlet weak var selectProvince: UIButton!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var remarkLabel: UITextField!
    
    var latitudeLocation: String! = "18.79974300"
    var longtitudeLocation: String! = "98.96545100"
    
    var selectedType: Int = -1 {
        didSet{
            guard selectedType != -1 else {
                return
            }
            
           
            selectType.setTitle(PlaceSizeID(rawValue: selectedType)?.GetName, for: .normal)
            
         
        }
    }
    var selectedProvince: Int = -1 {
        didSet{
            guard selectedProvince != -1 else {
                return
            }
            selectProvince.setTitle(ProvinceID(rawValue: selectedProvince)?.GetName, for: .normal)
        }
    }
    
    let widthBorder:CGFloat = 15
    
    var dataSource = MyPlaceDataModel()
    
    var posRowEdit : Int?
    
    var delegate: MyPlaceDetailProtocol?
    
    var itemEdit: MyPlaceDataModelItem?
    
    
    public var isEditDetail: Bool = false {
        didSet {
            if isEditDetail {
                let leftButtonItem = UIBarButtonItem.init(
                    title: "Close",
                    style: .done,
                    target: self,
                    action: #selector(self.closeViewButtonAction)
                )
                self.navigationItem.leftBarButtonItem = leftButtonItem
            }
        }
    }
    
    let dropDownType = DropDown()
    let dropDownProvince = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureDropDownType()
        configureDropDownProvince()
        
        if isEditDetail {
            loadDataToShow()
        }
        
    }
    
    func closeViewButtonAction(){
        self.dismiss(animated: true)
    }
    
    func configureDropDownType() {
        dropDownType.anchorView = view // UIView or UIBarButtonItem
        
        
        var dataType : [String] = []
        
        
        for var num in 1...(PlaceSizeID(rawValue: 1)?.CountID)! {
            if num >= 7  {
                num += 1
            }
            dataType.append( (PlaceSizeID(rawValue: num)?.GetName)! )
        }
        
        dropDownType.dataSource = dataType
        
        // Action triggered on selection
        dropDownType.selectionAction = {  (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedType = index + 1
            if self.selectedType >= 7{
                self.selectedType += 1
            }
            
            
            self.selectType.titleLabel?.text = PlaceSizeID(rawValue: self.selectedType-1)?.GetName
        }
        
        // Will set a custom width instead of the anchor view width
        dropDownType.width = view.frame.size.width-widthBorder*2
        
        dropDownType.bottomOffset = CGPoint(x: widthBorder, y: selectType.frame.origin.y)
    }
    
    func configureDropDownProvince() {
        dropDownProvince.anchorView = view // UIView or UIBarButtonItem
        
        var dataProvince : [String] = []
        
        for num in 1..<ProvinceID.countID.rawValue {
            dataProvince.append( (ProvinceID(rawValue: num)?.GetName)! )
        }
        
        dropDownProvince.dataSource = dataProvince

        // Action triggered on selection
        dropDownProvince.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedProvince = index + 1
            
            self.selectProvince.titleLabel?.text = ProvinceID(rawValue: self.selectedProvince-1)?.GetName
        }
        
        // Will set a custom width instead of the anchor view width
        dropDownProvince.width = view.frame.size.width-widthBorder*2
        
        dropDownProvince.bottomOffset = CGPoint(x: widthBorder, y: selectProvince.frame.origin.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSelectType(_ sender: Any) {
        dropDownType.show()
    }
    
    @IBAction func btnSelectProvince(_ sender: Any) {
        dropDownProvince.show()
    }

    @IBAction func btnSave(_ sender: Any) {
        
        guard !namePlaceLabel.text!.isEmpty  else {
            showAlertError(title: "User Places", msg: "กรุณากรอกชื่อสถานที่")
            return
        }
        
        guard selectedType + 1 != 0  else {
            showAlertError(title: "User Places", msg: "กรุณาเลือกประเภทที่พัก")
            return
        }
        
        guard selectedProvince + 1 != 0 else {
            showAlertError(title: "User Places", msg: "กรุณาเลือกเมือง")
            return
        }
        
        guard  !addressLabel.text!.isEmpty  else {
            showAlertError(title: "User Places", msg: "กรุณากรอกที่อยู่ของสถานที่")
            return
        }
        
        
        
        
        if isEditDetail {
            processDataToEdit()
        }else {
            processDataToSave()
        }
        
        
        
    }
    func showAlertError(title: String,msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
      
        let actionDismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        
        alertController.addAction(actionDismiss)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func processDataToSave(){
        

        let newItem = MyPlaceDataModelItem()
        newItem.place_name = namePlaceLabel.text
        newItem.place_size_id = String(selectedType)
        newItem.province_id = String(selectedProvince)
        newItem.address = addressLabel.text
        newItem.latitude = latitudeLocation
        newItem.longitude = longtitudeLocation
        newItem.remark = remarkLabel.text
        newItem.user_id = "1"
        
        dataSource.addNewData(newItem: newItem) {
            (success) in
            if success {
                print("Scuess add new data")
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
    
    func processDataToEdit(){
        let newItem = MyPlaceDataModelItem()
        newItem.place_name = namePlaceLabel.text
        newItem.place_size_id = String(selectedType)
        newItem.province_id = String(selectedProvince)
        newItem.address = addressLabel.text
        newItem.latitude = latitudeLocation
        newItem.longitude = longtitudeLocation
        newItem.remark = remarkLabel.text
        newItem.user_id = "1"
        newItem.id = itemEdit!.id
        
        dataSource.editDataWithID(newDataItem: newItem, position: posRowEdit!){
          
            (success) in
            if success {
                print("Sucess edit data at row : \(self.posRowEdit!)")
                self.delegate?.updateViewWithNewData(newDataItem: newItem)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func loadDataToShow(){
        //itemEdit
        namePlaceLabel.text = itemEdit?.place_name
        addressLabel.text = itemEdit?.address
        remarkLabel.text = itemEdit?.remark
        
        
        latitudeLocation = itemEdit?.latitude
        longtitudeLocation = itemEdit?.longitude
        
        selectedType = Int(itemEdit!.place_size_id!)!
        selectedProvince = Int(itemEdit!.province_id!)!
        
        dropDownProvince.selectRow(at: selectedProvince - 1)
        
        if selectedType > 7 {
            selectedType -= 1
        }
        dropDownType.selectRow(at: selectedType - 1)
        
        selectedType = Int(itemEdit!.place_size_id!)!
        
    }
    
    

}

