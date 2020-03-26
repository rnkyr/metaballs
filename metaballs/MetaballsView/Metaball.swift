//
//  Metaball.swift
//  metaballs
//
//  Created by Roman Kyrylenko on 10.03.2020.
//  Copyright © 2020 Roman Kyrylenko. All rights reserved.
//

import Foundation
import UIKit.UIBezierPath

struct Metaball: Equatable {
    
    let handleSize: CGFloat
    let curvature: CGFloat
    let radius: CGFloat
    let position: CGPoint
    
    func blobPath(with metaball: Metaball) -> UIBezierPath? {
        let distance = position.distance(to: metaball.position)
        // this coefficient should depend on the size of balls
        let maxDistance = radius + metaball.radius * 2.4
        
        if distance > maxDistance || distance <= abs(radius - metaball.radius) {
            return nil
        }
        
        // angles between center and circles' overlapping point
        let u1: CGFloat, u2: CGFloat
        if distance < radius + metaball.radius {
            u1 = acos(
                (pow(radius, 2) + pow(distance, 2) - pow(metaball.radius, 2)) / (2 * radius * distance)
            )
            u2 = acos(
                (pow(metaball.radius, 2) + pow(distance, 2) - pow(radius, 2)) / (2 * metaball.radius * distance)
            )
        } else {
            u1 = 0
            u2 = 0
        }
        
        return path(
            for: Blob(
                handleSize: handleSize, curvature: curvature,
                metaball1: self, metaball2: metaball, distance: distance, u1: u1, u2: u2
            ),
            c1: position,
            c2: metaball.position
        )
    }

    private func path(for blob: Blob, c1: CGPoint, c2: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: c1)
        path.addLine(to: blob.p1)
        path.addCurve(to: blob.p3, controlPoint1: blob.h1, controlPoint2: blob.h3)
        path.addLine(to: c2)
        
        path.move(to: c1)
        path.addLine(to: blob.p2)
        path.addCurve(to: blob.p4, controlPoint1: blob.h2, controlPoint2: blob.h4)
        path.addLine(to: c2)
        
        return path
    }
}
