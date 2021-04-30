//
//  DeepLinkParser.swift
//  mapper
//
//  Created by Никишин Ибрахим on 7/10/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

enum LinkCommands: String {
    case didVerify
    case unrecognized
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "didverify":
            self = .didVerify
        default:
            self = .unrecognized
            assertionFailure("Unrecognized deepLink command")
        }
    }

    var rawValue: String {
        switch self {
        case .didVerify:
            return "didverify"
        default:
            return "unrecognized"
        }
    }
}

protocol LinkParser {
    func isValidLink(_ url: URL) -> Bool
    func parseCommand(_ url: URL) -> LinkCommands
    func getParam(_ name: String, url: URL) -> String?
}

final class LinkParserImpl: LinkParser {
    func isValidLink(_ url: URL) -> Bool {
        return !(url.host?.isEmpty ?? true)
    }
    
    func parseCommand(_ url: URL) -> LinkCommands {
        guard let command = url.pathComponents.last else {
            return .unrecognized
        }
        
        let deepLinkCommand = LinkCommands(rawValue: command)
        return deepLinkCommand
    }
    
    func getParam(_ name: String, url: URL) -> String? {
        return url.valueOf(name)
    }
}
