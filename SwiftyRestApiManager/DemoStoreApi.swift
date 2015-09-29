//
//  DemoStoreApi.swift
//  SwiftyRestApiManager
//
//  Created by Sugam Kalra on 23/09/15.
//  Copyright © 2015 Sugam Kalra. All rights reserved.
//

import UIKit

import Foundation

class DemoStoreApi
{
    
    internal let api: DemoRestApiManager
    
    internal var ENDPOINT_BASE = "/services/apexrest/v1.0/GetAllVisits?StoreCode=11004"
    
    init(baseUrl:String,accessToken:String) {
        self.api = DemoRestApiManager(baseUrl: baseUrl, accessToken: accessToken, endPoint: ENDPOINT_BASE)
    }
    
    //MARK: - API Methods
    func getStoreData(onCompletion: (JSON) -> Void)
    {
        
        self.api.makeHTTPGetRequest(self.api.fullPath, onCompletion: { json, err in
            
            onCompletion(json as JSON)
        })
        
    }


}
