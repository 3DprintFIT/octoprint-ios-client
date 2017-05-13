//
//  Sockets.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 13/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Alamofire
import enum Result.NoError
import ReactiveSwift

/// Allows to create web socket connections
class WebSocket {
    /// Connects to server and reads data stream
    ///
    /// - Parameters:
    ///   - url: URL of the remote sockets stream
    ///   - method: HTTP method of connection request
    func connect(url: URL, withMethod method: HTTPMethod) -> SignalProducer<Data, NoError> {
        let cancellable = Alamofire.request(url, method: method)

        return SignalProducer { sink, disposlable in
            cancellable.stream { data in
                sink.send(value: data)
            }

            disposlable.add {
                cancellable.cancel()
            }
        }
    }
}
