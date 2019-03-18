//
//  PicturesView.swift
//  Instagrid
//
//  Created by Florian Peyrony on 18/03/2019.
//  Copyright © 2019 Florian Peyrony. All rights reserved.
//

import Foundation
import UIKit

class PicturesView: UIView {
    
    @IBOutlet var buttons: [UIButton]!
    
    enum Template: Int {
        case One = 0, Two = 1, Three = 2
    }
    var currentTemplate: Template = .Two {
        didSet {
            setTemplate(currentTemplate)
        }
    }
    
    
    func setTemplate(_ template: Template) {
        for button in buttons {
            button.isHidden = false
            
        }
        if currentTemplate == .One {
            buttons[0].isHidden = true
        }
        if currentTemplate == .Two {
            buttons[3].isHidden = true
        }
    }
}
