//
//  MyPlacesVC.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/4/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit
import Alamofire

class MyPlacesVC: UITableViewController {

    fileprivate var dataItems = [MyPlaceDataModelItem]() {
        didSet{
            myTableView.reloadData()
        }
    }
    private let dataSource = MyPlaceDataModel()
    
    @IBOutlet var myTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.register(MyPlaceCell.nib, forCellReuseIdentifier: MyPlaceCell.identifier)
        myTableView.estimatedRowHeight = 20
        myTableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the u line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        dataSource.delegate = self
        dataSource.requestData()
        
        
        let router = AlamofireRouter.getDataMyPlace
     
        Alamofire.request(router).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPlaceCell.identifier , for: indexPath) as! MyPlaceCell
        cell.configureWithItem(item: dataItems[indexPath.row])
       

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataItems.remove(at: indexPath.row)

            
        
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "myPlaceDetail") as! MyPlaceDetailVC
        navigationController?.pushViewController(vc, animated: true)
        vc.item = dataItems[indexPath.row]
        vc.posRowDetail = indexPath.row
        vc.dataSource.delegate = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addNewItem" {
            let vc = segue.destination as! MyPlaceAddNewVC
            vc.dataSource.delegate = self
        }
    }
    

}
extension MyPlacesVC: MyPlaceDataModelDelegate {
    func didRecieveDataUpdate(data: [MyPlaceDataModelItem]) {
        dataItems = data
        myTableView.reloadData()
    }
    func didAddNewDataUpdate(data: MyPlaceDataModelItem) {
        dataItems.append(data)
        myTableView.reloadData()
        
    }
    func didEditDataUpdate(newDataItem: MyPlaceDataModelItem,pos: Int){
        dataItems.remove(at: pos)
        dataItems.insert(newDataItem, at: pos)
        myTableView.reloadData()
    }
}
