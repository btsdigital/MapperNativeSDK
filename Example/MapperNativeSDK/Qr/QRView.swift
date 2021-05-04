//
//  QRView.swift
//  Mapper
//
//  Created by Никишин Ибрахим on 02/06/20.
//  Copyright © 2020 BTS Digital. All rights reserved.
//

import UIKit

final class QRView: UIView {
    let lineWidthAngle: CGFloat = 6
    let xRectangleLeft: CGFloat = 60

    override func draw(_: CGRect) {
        let sizeRetangle = CGSize(width: frame.size.width - xRectangleLeft * 2.0,
                                  height: frame.size.width - xRectangleLeft * 2.0)
        let yMinRetangle = frame.size.height / 2.0 - sizeRetangle.height / 2.0 - 44
        let yMaxRetangle = yMinRetangle + sizeRetangle.height
        let xRetangleRight = frame.size.width - xRectangleLeft

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).cgColor)

        context.fill(CGRect(x: 0, y: 0, width: frame.size.width, height: yMinRetangle))
        context.fill(CGRect(x: 0, y: yMinRetangle, width: xRectangleLeft, height: sizeRetangle.height))
        context.fill(CGRect(x: xRetangleRight, y: yMinRetangle, width: xRectangleLeft, height: sizeRetangle.height))
        context.fill(CGRect(x: 0, y: yMaxRetangle, width: frame.size.width, height: frame.size.height - yMaxRetangle))
        context.strokePath()
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setLineWidth(0.5)
        context.addRect(CGRect(x: xRectangleLeft,
                               y: yMinRetangle,
                               width: sizeRetangle.width,
                               height: sizeRetangle.height))
        context.strokePath()

//        context.setStrokeColor(UIColor.Mapper.secondaryDark.cgColor)
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        context.setLineWidth(lineWidthAngle)
    }
}
