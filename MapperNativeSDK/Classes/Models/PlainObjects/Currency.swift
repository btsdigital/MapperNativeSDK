//
//  Currency.swift
//  AituPay
//
//  Created by Eduard Pyatnitsyn on 06/12/2019.
//  Copyright © 2019 BTS Digital. All rights reserved.
//

import Foundation

extension Currency {
    public static let currentCurrencySymbol = Currency.kzt.isoCode
    public static let currentCurrency = Currency.kzt
}

public enum Currency: Int, Decodable {
    case kzt = 398
    case usd = 840
    case rur = 810
    case rub = 643
    case eur = 978
    case cny = 156
    case gbp = 826
    case jpy = 392
    case byr = 974
    case chf = 756
    case uah = 980
    case unknown = 0
    
    init(code: Int) {
        self = Currency(rawValue: code) ?? .unknown
    }

    var symbol: String {
        switch self {
        case .kzt:
            return "₸"
        case .usd:
            return "$"
        case .rur:
            return "₽"
        case .rub:
            return "₽"
        case .eur:
            return "€"
        case .cny:
            return "元"
        case .gbp:
            return "£"
        case .jpy:
            return "¥"
        case .byr:
            return "B"
        case .chf:
            return "₣"
        case .uah:
            return "₴"
        case .unknown:
            return "unknown"
        }
    }

    var isoCode: String {
        switch self {
        case .kzt:
            return "KZT"
        case .usd:
            return "USD"
        case .rur:
            return "RUR"
        case .rub:
            return "RUB"
        case .eur:
            return "EUR"
        case .cny:
            return "CNY"
        case .gbp:
            return "GBP"
        case .jpy:
            return "JPY"
        case .byr:
            return "BYR"
        case .chf:
            return "CHF"
        case .uah:
            return "UAH"
        case .unknown:
            return "unknown"
        }
    }
}
