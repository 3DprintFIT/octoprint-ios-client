//
//  TokenPluginTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 05/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class TokenPluginSpec: QuickSpec {
    override func spec() {
        it("signs request") {
            let token = "Access Token"
            let url = URL(string: "http://localhost")!
            let request = URLRequest(url: url)
            let target = DynamicTarget(baseURL: url, target: OctoPrintAPI.version)
            let plugin = TokenPlugin(token: token)

            let signedRequest = plugin.prepare(request, target: target)

            expect(signedRequest.value(forHTTPHeaderField: "X-Api-Key")) == token
        }
    }
}
