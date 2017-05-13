//
//  OctoPrintPushEvents.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 13/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import enum Result.NoError
import ReactiveSwift

/// Shorthand for temperatures values
typealias PrinterTemperatures = (bed: Bed, tool: Tool)

/// OctoPrint Push events provider
class OctoPrintPushEvents {

    /// URL of connection target
    private let url: URL

    /// Web sockets connection provider
    private let sockets = WebSocket()

    init(url: URL) {
        // Connects to random printer socket stream
        self.url = url.appendingPathComponent("/sockjs/286/sd3d24ew/xhr_streaming")
    }

    /// Stream of current temperatures of printers,
    /// the signal is endless and must be disposed manually
    func temperatures() -> SignalProducer<PrinterTemperatures, NoError> {
         return currentPrinterState().map { json -> PrinterTemperatures? in

            guard
                let temperaturesObject = json["temps"] as? [[String: Any]],
                let toolObject = temperaturesObject.first?["tool0"] as? [String: Any],
                let bedObject = temperaturesObject.first?["bed"] as? [String: Any],
                let tool = try? Tool.fromJSON(json: toolObject),
                let bed = try? Bed.fromJSON(json: bedObject)
            else {
                    return nil
            }

            return (bed, tool)
        }
        .skipNil()
    }

    /// Reads only current printer state from sockets, filters out all different events
    ///
    /// - Returns: Signal of current printer states
    private func currentPrinterState() -> SignalProducer<[String: Any], NoError> {
        return connect().map({
            return $0["current"] as? [String: Any]
        })
            .skipNil()
    }

    /// Creates a generic connection requests and converts response data to valid JSON
    ///
    /// - Returns: Signal with response JSONs
    private func connect() -> SignalProducer<[String: Any], NoError> {

        let connection = sockets.connect(url: url, withMethod: .post)

        return SignalProducer { sink, disposable in

            let requestDisposable = connection.startWithValues { data in
                guard let response = String(data: data, encoding: .utf8) else { return }

                let startIndex = response.index(after: response.startIndex)

                // Strip the first character from value
                let cleanString = response.substring(from: startIndex)

                // Splits OctoPrint outputs into single lines
                cleanString.enumerateLines(invoking: { line, _ in
                    guard
                        let strippedData = line.data(using: .utf8),
                        let object = try? JSONSerialization.jsonObject(with: strippedData, options: .allowFragments),
                        let json = object as? [[String: Any]]
                        else { return }

                    // The OctoPrint returns array in which is the key-value object
                    if let json = json.first {
                        sink.send(value: json)
                    }
                })
            }

            disposable.add {
                requestDisposable.dispose()
            }
        }
        .filter { $0.count > 0 }
    }
}
