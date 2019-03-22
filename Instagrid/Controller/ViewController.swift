//
//  ViewController.swift
//  Instagrid
//
//  Created by Florian Peyrony on 18/03/2019.
//  Copyright © 2019 Florian Peyrony. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var picturesView: PicturesView!
    @IBOutlet var dispositions :[UIButton]!
    @IBOutlet var buttons: [UIButton]!
    var indexOfColor = 0
    var buttonClicked: UIButton!
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        clearImageDisposition()
        picturesView.currentTemplate = .Two
        dispositions[1].imageView?.isHidden = false
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func share() {
        let activityController = UIActivityViewController(activityItems: [picturesView.asImage()], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        resetBackgroundAndText()
    }
    
    func allowsShare() {
        var buttonWithPictures = 0
        if picturesView.currentTemplate == .One || picturesView.currentTemplate == .Two {
            for button in buttons {
                if (button.currentBackgroundImage) != nil {
                    buttonWithPictures += 1
                }
                if buttonWithPictures == 3 {
                    share()
                }
            }
        }
        if picturesView.currentTemplate == .Three {
            for button in buttons {
                if (button.currentBackgroundImage) != nil {
                    buttonWithPictures += 1
                }
                if buttonWithPictures == 4 {
                    share()
                }
            }
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
 
       if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            print("Swipe Up")
            allowsShare()
        }
    }
    
    func clearImageDisposition() {
        for disposition in dispositions {
            disposition.imageView?.isHidden = true
        }
    }
    
    func resetBackgroundAndText() {
        for button in buttons {
            button.setBackgroundImage(nil, for: .normal)
            button.setTitle("+", for: .normal)
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
    
    func pickAnImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.present(myPickerController, animated: true)
            }
        }
    }
    
    func alertForCameraAndPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            print("camera access")
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alertSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            print("Library access")
            self.pickAnImage()
        }))
        alertSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    @IBAction func pressButtonForAddImage(_ sender: UIButton) {
        buttonClicked = sender
       alertForCameraAndPhotoLibrary()
    }
    
    
}

extension ViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                print(buttonClicked)
                buttonClicked.setBackgroundImage(image, for: .normal)
                buttonClicked.setTitle("", for: .normal)
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
