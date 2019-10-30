//
//  WebApiRequest.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

// To use this class, customize the following for YOUR web service:
// > The "urlBase" string on line 23
// > The format of the "url" string on line 39
// > The code to fetch the security token (if you have one) on line 63
// The rest of the code should work as-is without modifications
// You can leave the "print" statements as-is or comment them out

import UIKit

class WebApiRequest {
    
    // MARK: - Properties
    // Base URL, and then we add to the end
    // This is customized to match the behavior of the desired Web API
    var urlBase = "https://thecatapi-56b0.restdb.io/rest/a-3-cats"
    
    // Settable properties of NSMutableURLRequest
    var httpMethod = "GET"
    var headerAccept = "application/json"
    var headerContentType = "application/json"
    var httpBody: Data?
    
    // MARK: - Public methods
    
    func sendRequest<T:Decodable>(toUrlPath urlPath: String, completion: @escaping (T)->Void) {
        
        // Safely encode the URL path fragment that was passed into this method
        let encodedUrlPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        // Assemble the complete URL
        guard let url = URL(string: "\(urlBase)\(encodedUrlPath!)") else {
            print("\nFailed to construct url with \(urlBase)\(urlPath)")
            return
        }
        
        // Diagnostic
        print("\n\(url.description)")
        
        // Create a session configuration object
        let sessionConfig = URLSessionConfiguration.default
        
        // Create a session object
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Create a request object
        //let request = NSMutableURLRequest(url: url)
        var request = URLRequest(url: url)
        
        // Set its important properties
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.setValue(headerAccept, forHTTPHeaderField: "Accept")
        request.setValue(headerContentType, forHTTPHeaderField: "Content-Type")
        // Add some code here to fetch the
        // security bearer token from somewhere in the app
        let token = "5dae10493cbe87164d4bb5a3"
        // Then, if there is a token, attach it
        if !token.isEmpty {
            request.setValue(token, forHTTPHeaderField: "x-apikey")
        }
        
        // Define a network task; after it's created, it's in a "suspended" state
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if let error = error {
                // Stop the app's network activity indicator in the status bar
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print("\nTask request error: \(error.localizedDescription)")
                print("\n\(error)\n")
            }
            
            // Look at the response object
            let r = response as! HTTPURLResponse
            
            // It is an interim or informational response
            if (100...199).contains(r.statusCode) {
                
                let results: T? = "Response was interim or informational" as? T
                // Maybe extract and return more information
                completion(results!)
            }
            
            // Happy case... the request was successful, and we have data
            if let data = data, (200...299).contains(r.statusCode) {
                
                // FYI, we can show some details about the response
                // This code is interesting during development only
                // Remove it from the production/deployed app
                print("\nResponse status code is \(r.statusCode)\nHeaders:")
                // To make the syntax easier, convert [AnyHashable: Any] to strings
                let sortableHeaders = r.allHeaderFields as! [String: String]
                // Show each header in the response
                for header in sortableHeaders.sorted(by: { $0.0 < $1.0 }) {
                    print("  \(header.key): \(header.value)")
                }
                
                // Declare an object to hold the incoming data
                var results: T? = nil
                // Attempt to deserialize the data from the response
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    results = try decoder.decode(T.self, from: data)
                    
                    //results = try JSONDecoder().decode(T.self, from: data)
                }
                catch {
                    // Stop the app's network activity indicator in the status bar
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    print("\nData decoding error: \(error.localizedDescription)")
                    print("\n\(error)\n")
                    return
                }
                
                // The request was successful, and deserialization was successful.
                // So, call the closure completion
                
                //Dump
                //dump(results)
                
                completion(results!)
            }
            
            // Redirection
            if (300...399).contains(r.statusCode) {
                
                let results: T? = "HTTP \(r.statusCode) - Request was redirected" as? T
                // Maybe extract and return more information
                completion(results!)
            }
            
            // An error is in the request
            if (400...499).contains(r.statusCode) {
                
                let results: T? = "HTTP \(r.statusCode) - The request caused an error" as? T
                // Maybe extract and return more information
                completion(results!)
            }
            
            // An error happened at the server
            if (500...599).contains(r.statusCode) {
                
                let results: T? = "HTTP \(r.statusCode) - An error on the server happened" as? T
                // Maybe extract and return more information
                completion(results!)
            }
            
            // Finally, reference the app's network activity indicator in the status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        
        // Now that the task is defined and configured, execute it
        task.resume()
        
        // Reference the app's network activity indicator in the status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
}
