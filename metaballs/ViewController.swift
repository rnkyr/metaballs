//
//  ViewController.swift
//  Metaballs
//
//  Created by Roman Kyrylenko on 6/5/18.
//  Copyright © 2018 pr0ctopus. All rights reserved.
//

import UIKit

final class MetaballView: UIView {
    
    var radius: CGFloat { return bounds.width / 2 }
    
    init(center: CGPoint, radius: CGFloat) {
        let d: CGFloat = radius * 2
        super.init(frame: CGRect(x: center.x - d / 2, y: center.y - d / 2, width: d, height: d))
        
        backgroundColor = .black
        layer.cornerRadius = d / 2
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func equation(x: CGFloat, y: CGFloat) -> CGFloat {
        return (radius / sqrt((x - center.x) * (x - center.x) + (y - center.y) * (y - center.y)))
    }
}

final class ContainerView: UIView {
    
    let centerMetaball: MetaballView = MetaballView(center: CGPoint(x: 187.5, y: 287.5), radius: 20)
    var movingMetaball: MetaballView = MetaballView(center: CGPoint(x: 187.5, y: 187.5), radius: 20)
    
    init() {
        super.init(frame: .zero)
        
        addSubview(centerMetaball)
        addSubview(movingMetaball)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        movingMetaball.center = point
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawMetaballs()
    }
    
    let minThreshold: CGFloat = 0.99
    let maxThreshold: CGFloat = 1.01
    
    func drawMetaballs() {
        let inset: CGFloat = 100
        let minX: CGFloat = min(movingMetaball.frame.minX, centerMetaball.frame.minX) - inset
        let maxX: CGFloat = max(movingMetaball.frame.maxX, centerMetaball.frame.maxX) + inset
        let minY: CGFloat = min(movingMetaball.frame.minY, centerMetaball.frame.minY) - inset
        let maxY: CGFloat = max(movingMetaball.frame.maxY, centerMetaball.frame.maxY) + inset
        var x = minX
        var points: [CGPoint] = []
        let step: CGFloat = 1
        while x < maxX {
            var y = minY
            while y < maxY {
                var sum: CGFloat = 0
                for ball in [centerMetaball, movingMetaball] {
                    sum += ball.equation(x: x, y: y)
                }
                if sum >= minThreshold && sum <= maxThreshold {
                    points.append(CGPoint(x: x, y: y))
                }
                y += step
            }
            x += step
        }
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.black.cgColor)
        let size = CGSize(width: step, height: step)
        context.fill(points.map { CGRect(origin: $0, size: size) })
    }
}

final class ViewController: UIViewController {
    
    override func loadView() {
        self.view = ContainerView()
    }
}
