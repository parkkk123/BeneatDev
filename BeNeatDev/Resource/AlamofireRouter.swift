//
//  AlamofireRouter.swift
//  BeNeatDev
//
//  Created by Panuwit Pholkerd on 7/10/2560 BE.
//  Copyright © 2560 Panuwit Pholkerd. All rights reserved.
//

import UIKit
import Alamofire

enum AlamofireRouter: URLRequestConvertible {
    
    case getDataMyPlace
    case deleteMyPlace(id: Int)
    case updateMyPlace(id: Int,item : MyPlaceDataModelItem)
    case addMyPlace(item: MyPlaceDataModelItem)
    case getDetailMyPlace(id: Int)
    
    public func asURLRequest() throws -> URLRequest {
        let baseURLString = "https://dev.beneat.co/api"
        let url = URL(string: baseURLString + path)!
        var mutableURLRequest = URLRequest(url: url)
        mutableURLRequest.httpMethod = method.rawValue
        mutableURLRequest.setValue("f16165fd153002b5bfe951e92288e874", forHTTPHeaderField: "Authorization")
        
        return try Alamofire.JSONEncoding.default.encode(mutableURLRequest, with: parameters)
    }
    
    var path: String {
        switch self {
        case .getDataMyPlace:
            return "/users-places/"
        case .deleteMyPlace:
            return "/users-places/"
        case .updateMyPlace:
            return "/users-places/"
        case .addMyPlace:
            return "/users-places/"
        case .getDetailMyPlace(let id):
            return "/users-places/\(id)/"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getDataMyPlace:
            return .get
        case .deleteMyPlace:
            return .delete
        case .updateMyPlace:
            return .put
        case .addMyPlace:
            return .post
        case .getDetailMyPlace:
            return .get
        
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getDataMyPlace:
            return nil
        case .deleteMyPlace(let id):
            return ["id": id]
        case .updateMyPlace(let id,let item):
            return ["id": id ,
                    "place_name":item.place_name!,
                    "place_size_id": item.place_size_id!,
                    "province_id": item.province_id!,
                    "address": item.address!,
                    "latitude": item.latitude!,
                    "longitude": item.longtitude!,
                    "remark": item.remark!
            ]
        case .addMyPlace(let item):
            return ["user_id": item.user_id!,
                "place_name": item.place_name!,
                "place_size_id": item.place_size_id!,
                "province_id": item.province_id!,
                "latitude": item.latitude!,
                "longitude": item.longtitude!,
                "remark": item.remark!
                
            ]
        case .getDetailMyPlace:
            return nil
        }
    }
    
//    public var headers: [String: String]? {
//        return ["Authorization": "f16165fd153002b5bfe951e92288e874"]
//    }
//    
    
    
}
