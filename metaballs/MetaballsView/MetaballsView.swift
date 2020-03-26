//
//  MetaballsView.swift
//  metaballs
//
//  Created by Roman Kyrylenko on 10.03.2020.
//  Copyright © 2020 Roman Kyrylenko. All rights reserved.
//

import UIKit

public final class MetaballsView: UIView {
    
    public struct Config {

        public let handleSize: CGFloat
        public let curvature: CGFloat
        public let ballColor: UIColor
        public let numberOfBalls: Int
        public let frameForBall: (Int) -> CGRect
        
        public init(
            handleSize: CGFloat = 2.4,
            curvature: CGFloat = 0.5,
            ballColor: UIColor = UIColor(red: 0.16, green: 0.09, blue: 0.38, alpha: 1.00),
            numberOfBalls: Int = 4,
            frameForBall: @escaping (Int) -> CGRect = { _ in
            let side = 120//CGFloat.random(in: 75...175)
            return CGRect(x: .random(in: 43...201), y: .random(in: 173...548), width: side, height: side)
            }
        ) {
            self.handleSize = handleSize
            self.curvature = curvature
            self.ballColor = ballColor
            self.numberOfBalls = 2
            self.frameForBall = frameForBall
        }
    }
    
    public var config = Config() {
        didSet { didChangeConfig(from: oldValue, to: config) }
    }
    
    private var metaballs: [UIView] = []
    private var blobLayers: [[CAShapeLayer]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    private func initialize() {
        layoutBalls()
        backgroundColor = .white
        rebuildPaths()
    }
    
    private func layoutBalls() {
        metaballs.forEach {
            $0.removeFromSuperview()
        }
        metaballs = (0..<config.numberOfBalls).map { index in UIView(frame: config.frameForBall(index)) }
        metaballs.forEach { ball in
            ball.backgroundColor = .clear//config.ballColor
            ball.layer.borderColor = UIColor.black.cgColor
            ball.layer.borderWidth = 1
            ball.layer.cornerRadius = ball.frame.width / 2
            addSubview(ball)
            ball.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
        }
        blobLayers.forEach { layers in
            layers.forEach {
                $0.removeFromSuperlayer()
            }
        }
        blobLayers = (0..<config.numberOfBalls).map { _ in
            let innerList: [CAShapeLayer] = (0..<config.numberOfBalls).map { _ in
                let layer = CAShapeLayer()
                layer.fillColor = nil//config.ballColor.cgColor
//                layer.fillRule = .evenOdd
                layer.strokeColor = UIColor.purple.cgColor
                self.layer.addSublayer(layer)
                
                return layer
            }
            
            return innerList
        }
    }
    
    private func didChangeConfig(from oldValue: Config, to newValue: Config) {
        var shouldRebuild = false
        
        if oldValue.numberOfBalls != newValue.numberOfBalls {
            layoutBalls()
            shouldRebuild = true
        }
        
        if oldValue.handleSize != newValue.handleSize || oldValue.curvature != newValue.curvature {
            shouldRebuild = true
        }
        
        if oldValue.ballColor != newValue.ballColor {
            metaballs.forEach {
                $0.backgroundColor = newValue.ballColor
            }
            blobLayers.forEach {
                $0.forEach {
                    $0.fillColor = newValue.ballColor.cgColor
                }
            }
        }

        if shouldRebuild {
            rebuildPaths()
        }
    }
    
    lazy var h1: UILabel = {
        let label = UILabel()
        label.text = "h1"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        addSubview(label)
        
        return label
    }()
    lazy var h2: UILabel = {
        let label = UILabel()
        label.text = "h2"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        addSubview(label)
        
        return label
    }()
    lazy var h3: UILabel = {
        let label = UILabel()
        label.text = "h3"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        addSubview(label)
        
        return label
    }()
    lazy var h4: UILabel = {
        let label = UILabel()
        label.text = "h4"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        addSubview(label)
        
        return label
    }()
    
    lazy var p1: UILabel = {
        let label = UILabel()
        label.text = "p1"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.red
        addSubview(label)
        
        return label
    }()
    lazy var p2: UILabel = {
        let label = UILabel()
        label.text = "p2"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.red
        addSubview(label)
        
        return label
    }()
    lazy var p3: UILabel = {
        let label = UILabel()
        label.text = "p3"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.red
        addSubview(label)
        
        return label
    }()
    lazy var p4: UILabel = {
        let label = UILabel()
        label.text = "p4"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.red
        addSubview(label)
        
        return label
    }()
    
    lazy var ball1: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.darkGray
        addSubview(label)
        
        return label
    }()
    lazy var ball2: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.darkGray
        addSubview(label)
        
        return label
    }()
    
    private func rebuildPaths() {
        // not optimized, but could be ignored due to possible N
        for i in 0..<config.numberOfBalls {
            for j in 0..<config.numberOfBalls {
                var lhs = metaball(from: metaballs[i])
                let rhs = metaball(from: metaballs[j])
                blobLayers[i][j].path = lhs.blobPath(with: rhs)?.cgPath
                h1.center = lhs.h1
                h1.sizeToFit()
                h2.center = lhs.h2
                h2.sizeToFit()
                h3.center = lhs.h3
                h3.sizeToFit()
                h4.center = lhs.h4
                h4.sizeToFit()
                
                p1.center = lhs.p1
                p1.sizeToFit()
                p2.center = lhs.p2
                p2.sizeToFit()
                p3.center = lhs.p3
                p3.sizeToFit()
                p4.center = lhs.p4
                p4.sizeToFit()
                
                ball1.center = lhs.position
                ball1.sizeToFit()
                ball2.center = rhs.position
                ball2.sizeToFit()
            }
        }
    }
    
    private func rebuildPaths(with metaballView: UIView) {
        guard let j = metaballs.firstIndex(of: metaballView) else {
            return
        }

        let rhs = metaball(from: metaballs[j])
        for i in 0..<config.numberOfBalls {
            var lhs = metaball(from: metaballs[i])
            // clean up mirrored paths
            blobLayers[j][i].path = nil
            blobLayers[i][j].path = lhs.blobPath(with: rhs)?.cgPath
            h1.center = lhs.h1
            h1.sizeToFit()
            h2.center = lhs.h2
            h2.sizeToFit()
            h3.center = lhs.h3
            h3.sizeToFit()
            h4.center = lhs.h4
            h4.sizeToFit()
            
            p1.center = lhs.p1
            p1.sizeToFit()
            p2.center = lhs.p2
            p2.sizeToFit()
            p3.center = lhs.p3
            p3.sizeToFit()
            p4.center = lhs.p4
            p4.sizeToFit()
            
            ball1.center = lhs.position
            ball1.sizeToFit()
            ball2.center = rhs.position
            ball2.sizeToFit()
        }
    }
    
    @objc
    private func pan(_ recognizer: UIPanGestureRecognizer) {
        guard let metaballView = recognizer.view else {
            return
        }
        
        bringSubviewToFront(metaballView)
        let translation = recognizer.translation(in: self)
        metaballView.center.x += translation.x
        metaballView.center.y += translation.y
        recognizer.setTranslation(.zero, in: self)
        
        rebuildPaths(with: metaballView)
    }
    
    private func metaball(from view: UIView) -> Metaball {
        return Metaball(
            handleSize: config.handleSize,
            curvature: config.curvature,
            radius: view.frame.width / 2,
            position: view.center
        )
    }
}
