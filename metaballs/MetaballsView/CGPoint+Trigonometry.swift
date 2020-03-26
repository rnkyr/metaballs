//
//  CGPoint+Trigonometry.swift
//  metaballs
//
//  Created by Roman Kyrylenko on 10.03.2020.
//  Copyright © 2020 Roman Kyrylenko. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func distance(to p2: CGPoint) -> CGFloat {
        return pow(pow(x - p2.x, 2) + pow(y - p2.y, 2), 0.5)
    }

    func angle(with p2: CGPoint) -> CGFloat {
        return atan2(y - p2.y, x - p2.x)
    }
    
    func vector(with angle: CGFloat, and radius: CGFloat) -> CGPoint {
        return CGPoint(
            x: x + radius * cos(angle),
            y: y + radius * sin(angle)
        )
    }
}
