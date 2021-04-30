//
//  LinkHandler.swift
//  mapper
//
//  Created by Никишин Ибрахим on 7/10/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

protocol LinkHandler {
    func handleLink(_ url: URL)
}

class LinkHandlerImpl: LinkHandler {
    private enum Commands {
        static let didVerify = "didverify"
    }

    func handleLink(_ url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let commandParam = components?.host else {
            return
        }
        let command = LinkCommands(rawValue: commandParam)
        
        switch command {
        case .didVerify:
//            processDidVerifyCommand(from: url)
            print("TODO")
        case .unrecognized:
            assertionFailure("Unrecognized command")
            return
        }
    }

//    private func processDidVerifyCommand(from url: URL) {
//        if let errorCode = url.valueOf("error") {
//            didService.handleError(errorCode: errorCode)
//            return
//        }
//
//        guard let code = url.valueOf("code") else {
//            return
//        }
//        didService.registerDidCode(code)
//    }
}
