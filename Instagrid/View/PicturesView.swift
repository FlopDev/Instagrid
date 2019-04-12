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
     var indexOfColor = 0
    
    
    enum Template: Int {
        case One = 0, Two = 1, Three = 2
    }
    var currentTemplate: Template = .Two {
        didSet {
            setTemplate(currentTemplate)
        }
    }
    
    func resetImage() {
        for button in buttons {
            button.setImage(nil, for: .normal)
            button.imageView?.image = nil
        }
    }
    
    func tchekPicture() -> Int {
        var buttonWithImage = 0
        for button in buttons {
            if button.isHidden {
                print("Button hide")
            } else {
                if ((button.imageView?.image) != nil) {
                    buttonWithImage += 1
                } else {
                    print("add picture")
                }
            }
        }
        return buttonWithImage
    }
    
    
    func allowsShare(numberOfButtonNeedImage: Int) -> Bool {
        if currentTemplate == .One || currentTemplate == .Two {
            if tchekPicture() == numberOfButtonNeedImage {
                return true
            } else {
                print("add pictures")
                return false
            }
        }
        if currentTemplate == .Three {
            if tchekPicture() == 4 {
                return true
            } else {
                print("add pictures")
                return false
            }
        }
        return false
    }
    
    @IBAction func switchColor(_ sender: Any) {
        let colors: [UIColor] = [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5910229683, green: 0.3601167798, blue: 0, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.1315900385, green: 0.3851100206, blue: 0.567650497, alpha: 1)]
        self.backgroundColor = colors[indexOfColor]
        for button in buttons {
            button.setTitleColor(colors[indexOfColor], for: [])
        }
        indexOfColor += 1
        if indexOfColor == 9 {
            indexOfColor = 0
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
