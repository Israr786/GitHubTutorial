//
//  Extension+UIImage.swift
//  GitHubTutorial
//
//  Created by Israrul on 3/31/20.
//  Copyright © 2020 Israrul Haque. All rights reserved.
//

import Foundation

enum NetworkError:Error {
    case malformedURL(message:String)
    case errorWith(response:URLResponse?)
    case dataParsinFailed
}

//typealias completionHandler<DataModel:Decodable> = (Result<DataModel , NetworkError>) -> Void
typealias imageDownlaodCompletionHandler = (Data?, NetworkError?) -> Void

class Service {
    
    let urlSesson = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    
       
    func downloadImageFrom(url: String, completion: @escaping imageDownlaodCompletionHandler) {
       let urlSesson = URLSession(configuration: .default)
       guard let urlComponents = URLComponents(string:url) else {
           completion(nil, .malformedURL(message:"URL is not correct"))
           return
       }
       guard let url = urlComponents.url else {
           completion(nil, .malformedURL(message:"URL is nil"))
           return
       }
       dataTask =  urlSesson.dataTask(with:url) { (data, responce, error)  in
           guard let data = data , let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
               completion(nil, .errorWith(response:responce))
               return
           }
         completion(data, nil)

       }
       dataTask?.resume()
   }
}
   
