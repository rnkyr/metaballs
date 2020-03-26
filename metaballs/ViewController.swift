//
//  ViewController.swift
//  metaballs
//
//  Created by Roman Kyrylenko on 03.03.2020.
//  Copyright © 2020 Roman Kyrylenko. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBAction private func configureAction() {
        let controller = ConfigViewController()
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        defer {
            super.prepare(for: segue, sender: sender)
        }
        
        guard let controller = segue.destination as? ConfigViewController, let view = view as? MetaballsView else {
            return
        }
        
        controller.setup(with: view.config) { config in
            view.config = config
        }
    }
}
