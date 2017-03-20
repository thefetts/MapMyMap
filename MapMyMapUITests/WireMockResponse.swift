//
// Created by pivotal on 3/20/17.
// Copyright (c) 2017 Pivotal. All rights reserved.
//

import Foundation

import Freddy

struct WireMockResponse {
    var wasMatched: Bool
    var requestURL: String
}

extension WireMockResponse: JSONDecodable {
    init(json: JSON) {
        try! wasMatched = json.getBool(at: "wasMatched")

        let requestDictionary = try! json.getDictionary(at: "request")
        if let urlJSON = requestDictionary["url"] {
            requestURL = try! String(json: urlJSON)
        } else {
            requestURL = ""
        }
    }
}
