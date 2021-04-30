//
//  URL+Custom.swift
//  mapper
//
//  Created by Никишин Ибрахим on 7/10/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else {
            return nil
        }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
