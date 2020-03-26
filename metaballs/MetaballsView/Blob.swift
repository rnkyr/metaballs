//
//  Blob.swift
//  metaballs
//
//  Created by Roman Kyrylenko on 10.03.2020.
//  Copyright © 2020 Roman Kyrylenko. All rights reserved.
//

import CoreGraphics

struct Blob {
    
    // handle curve control points
    let h1: CGPoint, h2: CGPoint, h3: CGPoint, h4: CGPoint
    // tangent points
    let p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint
    
    init(
        handleSize: CGFloat, curvature: CGFloat,
        metaball1: Metaball, metaball2: Metaball,
        distance: CGFloat,
        u1: CGFloat, u2: CGFloat
    ) {
        let angleBetweenCenters = metaball2.position.angle(with: metaball1.position)
        let maxSpread = acos((metaball1.radius - metaball2.radius) / distance)
        let pi = CGFloat.pi
        
        // calculating tangent points
        let angle1 = angleBetweenCenters + u1 + (maxSpread - u1) * curvature
        let angle2 = angleBetweenCenters - u1 - (maxSpread - u1) * curvature
        let angle3 = angleBetweenCenters + pi - u2 - (pi - u2 - maxSpread) * curvature
        let angle4 = angleBetweenCenters - pi + u2 + (pi - u2 - maxSpread) * curvature
        p1 = metaball1.position.vector(with: angle1, and: metaball1.radius)
        p2 = metaball1.position.vector(with: angle2, and: metaball1.radius)
        p3 = metaball2.position.vector(with: angle3, and: metaball2.radius)
        p4 = metaball2.position.vector(with: angle4, and: metaball2.radius)
        
        let totalRadius = metaball1.radius + metaball2.radius
        let d2Base = min(curvature * handleSize, p1.distance(to: p3) / totalRadius)
        let d2 = d2Base * min(1, distance * 2 / totalRadius)
        
        // find length of the handles
        let r1 = metaball1.radius * d2
        let r2 = metaball2.radius * d2
        
        let halfPi: CGFloat = CGFloat.pi / 2
        // calculate control points
        h1 = p1.vector(with: angle1 - halfPi, and: r1)
        h2 = p2.vector(with: angle2 + halfPi, and: r1)
        h3 = p3.vector(with: angle3 + halfPi, and: r2)
        h4 = p4.vector(with: angle4 - halfPi, and: r2)
    }
}
