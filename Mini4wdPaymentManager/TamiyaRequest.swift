//
//  TamiyaRequest.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/06.
//  Copyright © 2017年 blk. All rights reserved.
//

import APIKit

protocol TamiyaRequest: Request {
}

extension TamiyaRequest {
    var baseURL: URL {
        return URL(string: "http://www.tamiya.com")!
    }
}

struct TamiyaResponse {
    var id: String
    var name: String?
    var description: String?
    var price: Int = 0

    init?(id: String, htmlString: String) {
        // id
        self.id = id

        let targetString = htmlString.replacingOccurrences(of: "\n", with: "")
        // name
        do {
            let regex = try NSRegularExpression(pattern: "<title>(.*)</title>", options: [])
            let targetStringRange = NSRange(location: 0, length: targetString.characters.count)

            let matches = regex.matches(in: targetString, options: [], range: targetStringRange)
            if matches.count > 0 {
                self.name = (targetString as NSString).substring(with: matches[0].rangeAt(1))
            }
        } catch let error {
            print("[ERROR] \(error)")
        }

        // description
        do {
            let regex = try NSRegularExpression(pattern: "<td><font size=\"2\" style=\"line-height:140%;\">(.*)(</font></td></tr></table>)", options: [])
            let targetStringRange = NSRange(location: 0, length: targetString.characters.count)

            let matches = regex.matches(in: targetString, options: [], range: targetStringRange)
            if matches.count > 0 {
                self.description = (targetString as NSString).substring(with: matches[0].rangeAt(1)).replacingOccurrences(of: "<br>", with: "\n")
            }
        } catch let error {
            print("[ERROR] \(error)")
        }

        // price
        do {
            let regex = try NSRegularExpression(pattern: "([0-9,]+)円", options: [])
            let targetStringRange = NSRange(location: 0, length: targetString.characters.count)

            let matches = regex.matches(in: targetString, options: [], range: targetStringRange)
            if matches.count > 0 {
                self.price = Int((targetString as NSString).substring(with: matches[0].rangeAt(1)).replacingOccurrences(of: ",", with: "")) ?? 0
            }
        } catch let error {
            print("[ERROR] \(error)")
        }
    }
}

struct GetPartRequest: TamiyaRequest {
    typealias Response = TamiyaResponse
    var method: HTTPMethod {
        return .get
    }
    var id: String
    var path: String {
        return "/japan/products/\(self.id)/index.htm"
    }
    var dataParser: DataParser = StringDataParser()

    init(id: String) {
        self.id = id
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard
            let htmlString = object as? String,
            let response = TamiyaResponse(id: self.id, htmlString: htmlString) else {
                throw ResponseError.unexpectedObject(object)
        }

        return response
    }
}
