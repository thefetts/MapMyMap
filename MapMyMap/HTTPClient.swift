//
// Created by pivotal on 3/21/17.
// Copyright (c) 2017 Pivotal. All rights reserved.
//

import Foundation

import Alamofire

class HTTPClient {
    func request(_ url: URLConvertible, method: Alamofire.HTTPMethod, parameters: Parameters?) {
        _ = Alamofire.request("http://localhost:9999/locations", method: .post, parameters: parameters,
                                               encoding: JSONEncoding.default)
    }
}