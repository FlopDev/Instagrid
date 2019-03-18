//
//  ViewController.swift
//  Instagrid
//
//  Created by Florian Peyrony on 18/03/2019.
//  Copyright © 2019 Florian Peyrony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var picturesView: PicturesView!
    @IBOutlet var dispositions :[UIButton]!
    var indexOfColor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearImageDisposition()
        picturesView.currentTemplate = .Two
        dispositions[1].imageView?.isHidden = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func clearImageDisposition() {
        for disposition in dispositions {
            disposition.imageView?.isHidden = true
        }
    }

    @IBAction func didTappedOnDisposition(_ sender: UIButton) {
        clearImageDisposition()
        if let template = PicturesView.Template(rawValue: sender.tag) {
            picturesView.currentTemplate = template
        }
         sender.imageView?.isHidden = false
    }
    @IBAction func switchColor(_ sender: Any) {
        let colors: [UIColor] = [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5910229683, green: 0.3601167798, blue: 0, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.1315900385, green: 0.3851100206, blue: 0.567650497, alpha: 1)]
        picturesView.backgroundColor = colors[indexOfColor]
        for button in picturesView.buttons {
            button.setTitleColor(colors[indexOfColor], for: [])
        }
        indexOfColor += 1
        if indexOfColor == 9 {
            indexOfColor = 0
        }
    }
    
}

