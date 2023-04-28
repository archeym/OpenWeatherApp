//
//  BounceButton.swift
//  OpenWeatherApp
//
//  Created by Arkadijs Makarenko on 28/04/2023.
//

import UIKit

class BounceButton: UIButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 1.1)
        
        
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations:  {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        super.touchesBegan(touches, with: event)
    }
    
}
