//
//  GetReferralCodeDataModel.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/25/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol GetReferralCodeDataModelDelegate: class {
    func didGetReferralCode(referral_code: String,url_referral_code: String)
    func didErrorGetReferralCode()
}


class GetReferralCodeDataModel {
    weak var delegate: GetReferralCodeDataModelDelegate?
    
    func requestReferralCode(user_id: Int){
        let router = AlamofireRouter.getReferralCode(user_id: user_id)
        Alamofire.request(router).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if((responseData.result.value) != nil) {
                    let json = JSON(responseData.result.value!)
                    guard json["error"].boolValue != true else {
                        print(json["message"].stringValue)
                        self.delegate!.didErrorGetReferralCode()
                        return
                    }
                    
                    self.delegate!.didGetReferralCode(referral_code: json["referral_code"].stringValue,url_referral_code: json["url_referral_code"].stringValue)
                    
                }
                
            case .failure(let error):
                print(error)
                self.delegate!.didErrorGetReferralCode()
                return
            }
        }
    }
}
