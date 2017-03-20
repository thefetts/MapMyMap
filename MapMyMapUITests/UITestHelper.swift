//
// Created by pivotal on 3/20/17.
// Copyright (c) 2017 Pivotal. All rights reserved.
//

import Alamofire
import Freddy
import Nimble

class UITestHelper {
    static func resetWireMock() {
        configureWireMock("mappings", method: .delete)
        configureWireMock("requests", method: .delete)
    }

    static func configureWireMock(_ path: String, method: HTTPMethod, body: [String: [String: Any]]? = nil) {
        sendToWireMock(path, method: method, body: body)
                .responseString { response in
                    if (response.result.isFailure) {
                        print("WireMock Request Failure, requested url: /__admin/" + path)
                    }
                }
    }

    static func expectRequestCount(_ requestUrl: String, count: Int) {
        sendToWireMock("requests", method: .get).responseJSON { response in
            if let data = response.data {
                let json = try! JSON(data: data)
                let array = try! json.getArray(at: "requests").map(WireMockResponse.init)
                let actualCount = array
                        .filter({ $0.wasMatched })
                        .filter({ $0.requestURL == requestUrl }).count
                expect(actualCount).to(equal(count))
            }
        }
    }

    static private func sendToWireMock(_ path: String, method: HTTPMethod, body: [String: Any]? = nil) -> DataRequest {
        var request: DataRequest
        if let body = body {
            request = Alamofire.request(
                    "http://localhost:9999/__admin/" + path, method: method,
                    parameters: body, encoding: JSONEncoding.default
            )
        } else {
            request = Alamofire.request(
                    "http://localhost:9999/__admin/" + path, method: method
            )
        }

        return request
    }
}
