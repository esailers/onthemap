//
//  GradientView.swift
//  Percentally
//
//  Created by Eric Sailers on 12/31/15.
//  Copyright © 2015 Expressive Solutions. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Methods

    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }

    func gradientWithColors(firstColor: UIColor, _ secondColor : UIColor) {
        
        let deviceScale = UIScreen.mainScreen().scale
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width * deviceScale, self.frame.size.height * deviceScale)
        gradientLayer.colors = [firstColor.CGColor, secondColor.CGColor]
        
        layer.insertSublayer(gradientLayer, atIndex: 0)
    }
}
