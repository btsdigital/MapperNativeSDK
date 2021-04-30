//
//  UIViewController+Custom.swift
//  AituPay
//
//  Created Eduard Pyatnitsyn on 08/11/2019.
//  Copyright © 2019 BTS Digital. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
