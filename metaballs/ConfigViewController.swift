//
//  ConfigViewController.swift
//  metaballs
//
//  Created by Roman Kyrylenko on 10.03.2020.
//  Copyright © 2020 Roman Kyrylenko. All rights reserved.
//

import UIKit

final class ConfigViewController: UIViewController {
    
    @IBOutlet private var handleSizeSlider: UISlider!
    @IBOutlet private var handleSizeLabel: UILabel!
    @IBOutlet private var curvatureSlider: UISlider!
    @IBOutlet private var curvatureLabel: UILabel!
    @IBOutlet private var numberOfBallsLabel: UILabel!
    @IBOutlet private var numberOfBallsSlider: UISlider!
    
    private var handleSize: Float = 0 {
        didSet { handleSizeLabel.text = "Handle size: \((handleSize * 10).rounded() / 10)" }
    }
    private var curvature: Float = 0 {
        didSet { curvatureLabel.text = "Curvature: \((curvature * 10).rounded() / 10)" }
    }
    private var numberOfBalls: Int = 0 {
        didSet { numberOfBallsLabel.text = "Balls: \(numberOfBalls)" }
    }
    
    private var config: MetaballsView.Config!
    private var callback: ((MetaballsView.Config) -> Void)!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        curvatureSlider.value = Float(config.curvature)
        curvature = Float(config.curvature)
        handleSizeSlider.value = Float(config.handleSize)
        handleSize = Float(config.handleSize)
        numberOfBalls = config.numberOfBalls
        numberOfBallsSlider.value = Float(config.numberOfBalls)
    }
    
    func setup(with config: MetaballsView.Config, callback: @escaping (MetaballsView.Config) -> Void) {
        self.config = config
        self.callback = callback
    }
    
    @IBAction private func curvatureChanged() {
        curvature = curvatureSlider.value
    }
    
    @IBAction private func handleSizeChanged() {
        handleSize = handleSizeSlider.value
    }
    
    @IBAction private func numberOfBallsChanged() {
        numberOfBalls = Int(numberOfBallsSlider.value)
    }
    
    @IBAction private func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveButtonAction() {
        callback(MetaballsView.Config(
            handleSize: CGFloat(handleSizeSlider.value),
            curvature: CGFloat(curvatureSlider.value),
            ballColor: config.ballColor,
            numberOfBalls: Int(numberOfBallsSlider.value)
        ))
        dismiss(animated: true, completion: nil)
    }
}
