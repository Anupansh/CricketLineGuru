//
//  Gradient.swift
//  BookMii
//
//  Created by Anuj Naruka on 19/06/17.
//  Copyright © 2017 BrainMobi. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class Gradient: UIView {
    @IBInspectable var firstColour: UIColor = UIColor.clear
        {
        didSet{
            updateView()
        }
    }
    @IBInspectable var SecondColour: UIColor = UIColor.clear
        {
        didSet{
            updateView()
        }
    }
    @IBInspectable var StartPointX: Double = 0.0
        {
        didSet{
            updateView()
        }
    }
    @IBInspectable var StartPointY: Double = 0.5
        {
        didSet{
            updateView()
        }
    }
    @IBInspectable var EndPointX: Double = 1.0
        {
        didSet{
            updateView()
        }
    }
    @IBInspectable var EndPointY: Double = 0.5
        {
        didSet{
            updateView()
        }
    }
//    override class func layerClass() -> AnyClass {
//        return CAGradientLayer.self
//    }
    //mark:- SWIFT 3.0
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    func updateView()
    {
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = CGPoint(x: StartPointX, y: StartPointY)
        layer.endPoint = CGPoint(x: EndPointX, y: EndPointY)
        layer.colors = [firstColour.cgColor,SecondColour.cgColor]
    }
    
}
