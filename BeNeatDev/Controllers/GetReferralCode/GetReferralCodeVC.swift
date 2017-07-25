//
//  GetReferralCodeVC.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/25/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit

class GetReferralCodeVC: UIViewController {

    @IBOutlet weak var referralCodeLabel: UILabel!
    fileprivate let dataSource = GetReferralCodeDataModel()
    
    fileprivate var urlReferralCode = "https://beneat.co/"

    @IBOutlet weak var shareCodeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.delegate = self
        dataSource.requestReferralCode(user_id: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func shareButton(_ sender: Any) {

        let objectsToShare:URL = URL(string: urlReferralCode)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}

extension GetReferralCodeVC : GetReferralCodeDataModelDelegate {
    func didGetReferralCode(referral_code: String, url_referral_code: String) {
        referralCodeLabel.text = referral_code
        urlReferralCode = url_referral_code
        shareCodeBtn.isEnabled = true
    }
    func didErrorGetReferralCode(){
        urlReferralCode = "https://beneat.co/"
        referralCodeLabel.text = "Error get Referral Code "
        shareCodeBtn.isEnabled = false
    }
}
