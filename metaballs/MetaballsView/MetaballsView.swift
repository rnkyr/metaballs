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
            let side = CGFloat.random(in: 75...175)
            return CGRect(x: .random(in: 43...201), y: .random(in: 173...548), width: side, height: side)
            }
        ) {
            self.handleSize = handleSize
            self.curvature = curvature
            self.ballColor = ballColor
            self.numberOfBalls = numberOfBalls
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
            ball.backgroundColor = config.ballColor
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
                layer.fillColor = config.ballColor.cgColor
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
    
    private func rebuildPaths() {
        // not optimized, but could be ignored due to possible N
        for i in 0..<config.numberOfBalls {
            for j in 0..<config.numberOfBalls {
                let lhs = metaball(from: metaballs[i])
                let rhs = metaball(from: metaballs[j])
                blobLayers[i][j].path = lhs.blobPath(with: rhs)?.cgPath
            }
        }
    }
    
    private func rebuildPaths(with metaballView: UIView) {
        guard let j = metaballs.firstIndex(of: metaballView) else {
            return
        }

        let rhs = metaball(from: metaballs[j])
        for i in 0..<config.numberOfBalls {
            let lhs = metaball(from: metaballs[i])
            // clean up mirrored paths
            blobLayers[j][i].path = nil
            blobLayers[i][j].path = lhs.blobPath(with: rhs)?.cgPath
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
