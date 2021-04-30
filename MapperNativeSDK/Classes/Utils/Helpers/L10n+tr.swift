//
//  L10n.swift
//  Mapper
//
//  Created by Никишин Ибрахим on 10/2/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension L10n {
    enum Constant {
        static let localeKey = "localeKey"
    }
    
    static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let bundle: Bundle
        if
            let language = UserDefaults.standard.object(forKey: L10n.Constant.localeKey) as? String,
            !language.isEmpty,
            let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let languageBundle = Bundle(path: path) {
            bundle = languageBundle
        } else {
            bundle = Bundle(for: L10nBundleToken.self)
        }
        // swiftlint:disable:next nslocalizedstring_key
        let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

final class L10nBundleToken {}
