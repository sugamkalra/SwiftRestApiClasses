//
//  DemoRestApiManager.swift
//  SwiftyRestApiManager
//
//  Created by Sugam Kalra on 23/09/15.
//  Copyright © 2015 Sugam Kalra. All rights reserved.
//

import UIKit

typealias ServiceResponse = (JSON, NSError?) -> Void


extension String {
    func URLEncodedString() -> String? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let escapedString = self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        
        return escapedString
    }
    static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String? {
        if (parameters.count == 0)
        {
            return nil
        }
        var queryString : String? = nil
        for (key, value) in parameters {
            if let encodedKey = key.URLEncodedString()
            {
                if let encodedValue = value.URLEncodedString()
                {
                    if queryString == nil
                    {
                        queryString = ""
                    }
                    else
                    {
                        queryString! += "&"
                    }
                    queryString! += encodedKey + "=" + encodedValue
                }
            }
        }
        return queryString
    }
}



class DemoRestApiManager: NSObject
{
    
    /// Base URL for services
    private var baseUrl: String = ""
    private var endPoint: String = ""
    var fullPath: String = ""
    /// the access token used for authorization
    var accessToken: String = ""
    
    /// the name of the authorization header to substiture API access token (for future)
    let AUTH_HEADER = "Authorization"
    
    
    init(baseUrl: String, accessToken: String, endPoint: String)
    {
        print(accessToken)
        print(endPoint)
        
        super.init()
        self.initialize(baseUrl, accessToken:accessToken, endPoint: endPoint)
    }
    
    func initialize(baseUrl: String, accessToken: String, endPoint: String) {
        
        self.baseUrl = baseUrl
        self.endPoint = endPoint
        self.fullPath = baseUrl + endPoint
        self.accessToken = accessToken
    }
    
    
    func getRequest(onCompletion: (JSON) -> Void)
    {
        let route = self.baseUrl
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func sampleTest(onCompletion: (JSON) -> Void)
    {
        let route = self.baseUrl
        
        let body: Dictionary<String,String> = ["grant_type": "password","client_id": "3MVG9I1kFE5Iul2Bn1eJQgPu88trNCCOG9xpwEau1xJqRWd7AnnmsJ_KoeVq4VSSo_QW.fpB6CQ36oGcMPuDJ","client_secret": "3032549359899499647","username":"sfdemo@demo.jdc.appirio.com","password":"appirio12345" ];
        
        makeHTTPPostRequest(route,body: body ,onCompletion: { json, err in
            
            onCompletion(json as JSON)
            
        })
        
    }
    
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        print(path)
        
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }
    
    
    //MARK: Perform a POST Request
    func makeHTTPPostRequest(path: String, body: Dictionary<String,String>, onCompletion: ServiceResponse)
    {
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-type");
        
        // Set the POST body for the request
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        print(body)
        
        
        var theJSONData:NSData = NSData()
        
        
        do{
            theJSONData = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions(rawValue: 0))
        }
        catch
        {
            
        }
        
        
        let theJSONText = NSString(data: theJSONData,
            encoding: NSASCIIStringEncoding)
        print("JSON string = \(theJSONText!)")
        
        
        request.HTTPBody = theJSONText!.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, nil)
        })
        task.resume()
    }
    
}