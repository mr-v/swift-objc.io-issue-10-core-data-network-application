//
//  ErrorReference.swift
//  PodSpecImporter
//
//  Created by Witold Skibniewski on 08/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

let ErrorByReferenceDomain = "Error by reference"

func tryWithError<T>(fun: (e: NSErrorPointer) -> T) -> ErrorReferenceResult<T> {
    var possibleError: NSError?
    let result: T? = fun(e: &possibleError)

    if let error = possibleError {
        return ErrorReferenceResult(data: nil, error: error)
    }

    let success = result as? Bool
    let error: NSError? = success? == false ? NSError(domain: ErrorByReferenceDomain, code: 1, userInfo: nil) : nil
    return ErrorReferenceResult(data: result, error: error)
}

struct ErrorReferenceResult<T> {
    private let data: T?
    private let error: NSError?

    func onError(fun: (error: NSError) -> ()) -> ErrorReferenceResult {
        if error != nil {
            fun(error: error!)
        }
        return self
    }

    func onSuccess(fun: (data: T) -> ()) -> ErrorReferenceResult {
        if data != nil {
            fun(data: data!)
        }
        return self
    }
}
