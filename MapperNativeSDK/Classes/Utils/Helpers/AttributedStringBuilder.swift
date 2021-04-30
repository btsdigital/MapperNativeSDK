//
//  AttributedStringBuilder.swift
//  aitu.city
//
//  Created by sergey.bendak on 7/29/19.
//  Copyright © 2019 BTSDigital. All rights reserved.
//

import UIKit

/**
 Упрощенное создание атрибутных строк.
 После конфигурации необходимо вызвать метод `build()`, который вернет `NSAttributedString`

 Пример:

 ```
 let str = "Test string!"
 let result = AttributedStringBuilder(string: str)
     .color(.green)
     .color(.red, range: NSRange(location: 0, length: 4))
     .color(.yellow, range: NSRange(location: str.count - 1, length: 1))
     .font(.systemFont(ofSize: 24))
     .font(.boldSystemFont(ofSize: 32), range: NSRange(location: 0, length: 4))
     .build()
 ```
 */

final class AttributedStringBuilder {
    /// Описание атрибута, для использования внутри билдера.
    private struct Attribute {
        let key: NSAttributedString.Key
        let value: Any
        let range: NSRange?
    }

    private let string: String
    private var attributes: [Attribute] = []

    init(string: String) {
        self.string = string
    }

    /// - Parameter font: шрифт, будет применяться для `range`
    /// - Parameter range: опциональный, если не передавать, применяется для всей строки
    func font(_ font: UIFont, range: NSRange? = nil) -> AttributedStringBuilder {
        attributes.append(
            Attribute(key: .font, value: font, range: range)
        )
        return self
    }

    /// - Parameter color: цвет, будет применяться для `range`
    /// - Parameter range: опциональный, если не передавать, применяется для всей строки
    func color(_ color: UIColor, range: NSRange? = nil) -> AttributedStringBuilder {
        attributes.append(
            Attribute(key: .foregroundColor, value: color, range: range)
        )
        return self
    }

    /// - Parameter backgroundColor: цвет фона, будет применяться для `range`
    /// - Parameter range: опциональный, если не передавать, применяется для всей строки
    func backgroundColor(_ backgroundColor: UIColor, range: NSRange? = nil) -> AttributedStringBuilder {
        attributes.append(
            Attribute(key: .backgroundColor, value: backgroundColor, range: range)
        )
        return self
    }

    /// - Parameter paragraph: парвила, будут применяться для `range`
    /// - Parameter range: опциональный, если не передавать, применяется для всей строки
    func paragraph(_ paragraph: NSParagraphStyle, range: NSRange? = nil) -> AttributedStringBuilder {
        attributes.append(
            Attribute(key: .paragraphStyle, value: paragraph, range: range)
        )
        return self
    }

    /// - Returns: возвращает сконфигурированную `NSAttributedString`
    func build() -> NSAttributedString {
        let str = NSMutableAttributedString(string: string)
        attributes.forEach { attribute in
            let range = attribute.range ?? NSRange(location: 0, length: string.count)
            str.addAttribute(attribute.key, value: attribute.value, range: range)
        }
        return str
    }
}
