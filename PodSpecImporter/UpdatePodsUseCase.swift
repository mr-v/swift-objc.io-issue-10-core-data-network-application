//
//  UpdatePodsUseCase.swift
//  PodsDemo
//
//  Created by Witold Skibniewski on 04/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class UpdatePodsUseCase {

    let webService = WebJSONService(baseURLString: "http://localhost:4567/specs", defaultParameters: [String: Any]())
    let importer: Importer

    init(importer: Importer) {
        self.importer = importer
    }
    
    func execute() {
        let firstPage = 0
        fetchPods(firstPage) { [weak self] specs in
            self?.importer.importPodSpecs(specs)
            return
        }
    }

    private func fetchPods(page: Int, progressHandler: (pods: [NSDictionary]) -> ()) {
        webService.fetchJSON(["page": page]) { result in
            switch result {
            case .OK(let data):
                if let pods = data["result"] as? [NSDictionary] {
                    progressHandler(pods: pods)
                    let numberOfPages = data["number_of_pages"] as Int
                    let nextPage = page + 1
                    if nextPage < numberOfPages {
                        self.fetchPods(nextPage, progressHandler: progressHandler)
                    }
                    
                } else {
                    fallthrough
                }
            case .Error:
                println("error!")
            }
        }
    }
    
}