//
//  BUAPI.swift
//  Example
//
//  Created by Victor on 20/12/2016.
//  Copyright © 2016 Vmlweb. All rights reserved.
//

import Foundation

public enum BUMethod: String{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case OPTIONS = "OPTIONS"
    case HEAD = "HEAD"
}

public class BUAPI{
    
    public var url: String? = "https://bu-games.bmth.ac.uk"
    public var path: String? = "/api/v1"
    public var auth: BUAccessKey?
    
    //URL prefix for HTTP requests
    public var hostPrefix: String{
        return "\(self.url ?? "")\(self.path ?? "")"
    }
    
    //Singleton
    public static let instance = BUAPI()
    private init(){}
    
    //MARK: Request Methods
    
    //Convenience methods for url and path appended requests
    public func request(withPath path: String, method: BUMethod, body: [String: Any]? = nil, error: @escaping (BUError) -> Void, success: @escaping ([String: Any]) -> Void){
        makeRequest(withURL: "\(hostPrefix)\(path)", method: method, body: body, error: error, success: success)
    }
    
    //Convenience methods for url appended requests
    public func request(withURL url: String, method: BUMethod, body: [String: Any]? = nil, error: @escaping (BUError) -> Void, success: @escaping ([String: Any]) -> Void){
        makeRequest(withURL: "\(self.url ?? "")\(url)", method: method, body: body, error: error, success: success)
    }
    
    //Make a generic request to the backend server url, response is sent to error and success closures
    private func makeRequest(withURL url: String, method: BUMethod, body: [String: Any]? = nil, error: @escaping (BUError) -> Void, success: @escaping ([String: Any]) -> Void){
        
        //Encode url and body parameters into http request
        var requestURL: URL
        var requestBody: Data? = nil
        if let body = body{
            if method == .GET || method == .DELETE{
                requestURL = URL(string: "\(url)\(encode(url: body))")!
            }else{
                requestURL = URL(string: url)!
                requestBody = encode(json: body)
            }
        }else{
            requestURL = URL(string: url)!
        }
        
        //Create http session and request
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBody
        
        //Prepare http headers
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //Authenticate request with access key and secret
        if let auth = auth{
            request.addValue(auth.key, forHTTPHeaderField: "AuthAccessKey")
            request.addValue(auth.secret, forHTTPHeaderField: "AuthAccessSecret")
        }
        
        //Make http request with completion handlers
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, code: Error?) -> Void in
            
            //Check for server connection errors
            if let code = code {
                print(code)
                error(BUError.Connection)
                
            }else if let response = response as? HTTPURLResponse{
            
                //Check the http response status codes
                if response.statusCode != 200{
                    if response.statusCode == 404{
                        error(BUError.NotFound)
                    }else if response.statusCode == 500{
                        error(BUError.Server)
                    }else{
                        error(BUError.Server)
                    }
                    return
                }
                
                do{
                    //Decode JSON data from url
                    guard let data = data else{ error(BUError.Json); return }
                    guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{ error(BUError.Json); return }
                    
                    //Check whether response contains error message
                    if let code = object["error"] as? Int{
                        if let code = BUError(rawValue: code){
                            error(code)
                        }else{
                            error(BUError.Unknown)
                        }
                        return
                    }
                    
                    //Return the successful json object
                    success(object)
                
                }catch _{
                    error(BUError.Json)
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //Encode parameters as key/value pairs in url a format
    private func encode(url parameters: [String: Any]) -> String{
        var body = "?"
        for (key, value) in parameters.enumerated(){
            body += "\(key)=\(value)&"
        }
        return body.trimmingCharacters(in: CharacterSet(charactersIn: "&"))
    }
    
    //Encode any nested dictionary or list type into a json node object
    private func encode(json object: [String: Any]) -> Data{
        
        //Recursive loop through every level of object
        func encode(item: Any) -> Any?{

            //Deal with simple value types first
            if let date = item as? Date{
                
                //Convert date to timestamp
                return date.timeIntervalSince1970
                
            }else if let type = item as? CGPoint, var point = type.dictionaryRepresentation as? [String: Any]{
                
                //Encode keys from core graphics rect
                for (key, value) in point{
                    point[key] = nil
                    point[key.lowercased()] = value
                }
                return point
                
            }else if let type = item as? CGSize, var size = type.dictionaryRepresentation as? [String: Any]{
                
                //Encode keys from core graphics rect
                for (key, value) in size{
                    size[key] = nil
                    size[key.lowercased()] = value
                }
                return size
                
            }else if let type = item as? CGRect, var rect = type.dictionaryRepresentation as? [String: Any]{
                
                //Encode keys from core graphics rect
                for (key, value) in rect{
                    rect[key] = nil
                    rect[key.lowercased()] = value
                }
                return rect
                
            }else if var dictionary = item as? [String: Any]{
                
                //Scan and encode dictionary keys
                for (key, value) in dictionary{
                    if let newValue = encode(item: value){
                        dictionary[key] = newValue
                    }
                }
                return dictionary
                
            }else if var array = item as? [Any]{
                
                //Scan and encode array indexes
                for (index, value) in array.enumerated(){
                    if let newValue = encode(item: value){
                        array[index] = newValue
                    }
                }
                return array
                
            }else{
                return nil
            }
        }
        
        //Process JSON serialization
        do{
            return try JSONSerialization.data(withJSONObject: encode(item: object) ?? [:], options: [])
        }catch{
            do{
                return try JSONSerialization.data(withJSONObject: [:], options: [])
            }catch{
                return Data()
            }
        }
    }
}
