//
//  Button.swift
//  P9 Popcorn Swirl
//
//  Created by Eric Stein on 2/28/20.
//  Copyright © 2020 Eric Stein. All rights reserved.
//

import UIKit

struct BetterButton {
    
    private var button: UIButton?
    
    mutating func setButton(_ button: UIButton) {
        self.button = button
    }
    
    func roundButton() {
        if let newButton = button {
            newButton.layer.cornerRadius = 15
            newButton.layer.masksToBounds = true
        }
    }
}
