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
    fileprivate let dataSource = MyPlaceDataModel()
    
    @IBOutlet var myTableView: UITableView!
    
    fileprivate let pullToRefreshControl = UIRefreshControl()
    
    fileprivate var page: Int = 0
    fileprivate var user_id = 1
    
    var loadingData = false
    var loadMoreEnable = true
    
    private let loadMoreEnableWithCount = 20
    
    fileprivate var itemsNewAdded = [String]()
    

  
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.register(MyPlaceCell.nib, forCellReuseIdentifier: MyPlaceCell.identifier)
        myTableView.register(LoadMoreMyPlaceCell.nib, forCellReuseIdentifier: LoadMoreMyPlaceCell.identifier)
        myTableView.estimatedRowHeight = 20
        myTableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the u line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        dataSource.delegate = self
        dataSource.requestData(page: 0,user_id: user_id)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            myTableView.refreshControl = pullToRefreshControl
        } else {
            myTableView.addSubview(pullToRefreshControl)
        }
        
        pullToRefreshControl.addTarget(self,  action: #selector(self.pullToRefreshData(sender:)), for: .valueChanged)

        
        
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
        guard dataItems.count != 0 else {
            return 0
        }
        if  loadMoreEnable && dataItems.count >= loadMoreEnableWithCount  {
            return dataItems.count + 1
        }
        return dataItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == dataItems.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadMoreMyPlaceCell.identifier , for: indexPath) as! LoadMoreMyPlaceCell
            cell.selectionStyle = .none
            cell.spinner.startAnimating()
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPlaceCell.identifier , for: indexPath) as! MyPlaceCell
            cell.configureWithItem(item: dataItems[indexPath.row])
            return cell
           
        }
        
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
            
            showAlertToDelete(rowToDelete: indexPath.row)

            
        
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != dataItems.count  else {
            return
        }
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
    
    func pullToRefreshData(sender: Any){
        print("Refrshing")
        dataSource.requestData(page: 0,user_id: user_id)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if !loadingData && indexPath.row == dataItems.count && dataItems.count >= loadMoreEnableWithCount {
           
            loadingData = true
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async() {
             
                    print("load more working")
                    self.page+=1
                    self.dataSource.loadMore(self.page, user_id: self.user_id)
                    
                    
                }
            }
        }
    }
    
   
    

}
extension MyPlacesVC: MyPlaceDataModelDelegate {
    func didRecieveDataUpdate(data: [MyPlaceDataModelItem]) {
        dataItems = data
        loadMoreEnable = true
        myTableView.reloadData()
        pullToRefreshControl.endRefreshing()
        page = 0
        itemsNewAdded = []
        
    }
    func didAddNewDataUpdate(data: MyPlaceDataModelItem) {
        dataItems.insert(data, at: 0)
        itemsNewAdded.append(data.id!)
        
        
    }
    func didEditDataUpdate(newDataItem: MyPlaceDataModelItem,pos: Int){
        dataItems.remove(at: pos)
        dataItems.insert(newDataItem, at: pos)
        myTableView.reloadData()
    }
    
    func didDeleteDataUpdate(pos: Int,success: Bool) {
        if success {
            self.dataItems.remove(at: pos)
        }
        
    }
    
    func didLoadMoreReceiveDataUpdate(data: [MyPlaceDataModelItem], success: Bool) {
        var data = data
        if success {
            //filter data from added before out
            for dataCheck in itemsNewAdded {
                 data = data.filter{  $0.id != dataCheck }
            }
            
            dataItems += data
        }else{
            
            self.loadMoreEnable = false
            myTableView.reloadData()
        }
        self.loadingData = false
    }
}

extension MyPlacesVC {
    func showAlertToDelete(rowToDelete : Int){
        let alertController = UIAlertController(title: "Delete This Place", message: "Are you sure you want to delete this place", preferredStyle: .alert)
        
        let actionDelete = UIAlertAction(title: "Delete", style: .destructive){
            (result : UIAlertAction) -> Void in
            // Delete the row from the data source
            self.dataSource.deleteDataWithID(placeID: self.dataItems[rowToDelete].id!, pos: rowToDelete)
            
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionDelete)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
}
