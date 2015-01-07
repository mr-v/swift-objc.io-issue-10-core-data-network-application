//
//  WebJSONService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import NSErrorPointerWrapper

class WebJSONService {
    private let session: NSURLSession
    let baseURLString: String
    let defaultParameters: [String : Any]

    init(baseURLString: String, defaultParameters: [String: Any]) {
        self.baseURLString = baseURLString
        self.defaultParameters = defaultParameters

        let defaultConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        defaultConfiguration.requestCachePolicy = .ReturnCacheDataElseLoad
        session = NSURLSession(configuration: defaultConfiguration)
    }

    func fetchJSON(parameters: [String: Any], completionHandler: Result<NSDictionary> -> ())  {
        let request = urlRequestWithParameters(parameters)

        let task = session.dataTaskWithRequest(request, completionHandler: { data, urlResponse, error in
            let dispatchError = { dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) } }
            if let httpResponse = urlResponse as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    dispatchError()
                    return
                }
            }

            tryWithErrorPointer(castResultTo: NSDictionary.self) { NSJSONSerialization.JSONObjectWithData(data, options: nil, error: $0) }
                .onError { _ in dispatchError() }
                .onSuccess { jsonObject in dispatch_async(dispatch_get_main_queue()) { completionHandler(.OK(jsonObject)) } }
        })
        task.resume()
    }

    private func urlRequestWithParameters(parameters: [String: Any]) -> NSURLRequest {
        let components = NSURLComponents(string: baseURLString)!
        let mergedParameters = defaultParameters + parameters
        if !mergedParameters.isEmpty {
            components.queryItems = queryItemsWithParameters(mergedParameters)
        }
        let request = NSURLRequest(URL: components.URL!)
        return request
    }

    private func queryItemsWithParameters(parameters: [String: Any]) -> [NSURLQueryItem] {
        let keys = parameters.keys.array
        return keys.map { key in NSURLQueryItem(name: key, value: "\(parameters[key]!)") }
    }
}
