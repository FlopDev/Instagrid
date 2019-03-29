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
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var dispositions: [UIButton]!
    var indexOfColor = 0
    var buttonClicked: UIButton!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var swipeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        resetImageDisposition()
        picturesView.currentTemplate = .Two
        dispositions[1].imageView?.isHidden = false
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func deviceRotated(){
        if view.gestureRecognizers?.count == 1 {
            view.gestureRecognizers?.remove(at: 0)
        }
        if UIDevice.current.orientation.isLandscape {
            orientation(text: "Swip left to share", direction: .left)
        }
        if UIDevice.current.orientation.isPortrait {
            orientation(text: "Swipe up to share ", direction: .up)
        }
    }
    
    func orientation(text: String, direction:UISwipeGestureRecognizer.Direction) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeText.text = text
        swipe.direction = direction
        self.view.addGestureRecognizer(swipe)
    }
    
    func share() {
        let finalPicture = picturesView.asImage()
        let screenHeight = UIScreen.main.bounds.height
        let activityController = UIActivityViewController(activityItems: [finalPicture], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.animateView(postition: 0)
            
            for button in self.buttons {
                button.setImage(nil, for: .normal)
                button.imageView?.image = nil
            }
        }
        animateView(postition: -screenHeight)
    }
    
    func allowsShare(numberOfPicturesAvailable: Int) {
        var buttonWithPic = 0
        for button in buttons {
            if button.isHidden {
                print("Button hide")
            } else {
                if ((button.imageView?.image) != nil) {
                    buttonWithPic += 1
                } else {
                    print("add picture")
                }
            }
        }
        
        if buttonWithPic == numberOfPicturesAvailable {
            share()
        } else {
            alert(titleEntered: "Add picture", messageEntered: "Please, add picture on all dispositions before swipe up to share")
        }
    }
    
    func alert(titleEntered: String, messageEntered: String) {
        let alert = UIAlertController(title: titleEntered , message: messageEntered , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func animateView(postition: CGFloat) {
        var translationForm: CGAffineTransform
        translationForm = CGAffineTransform(translationX: 0, y: postition)
        UIView.animate(withDuration: 0.3, animations: {
            self.picturesView.transform = translationForm
        })
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if picturesView.currentTemplate == .One || picturesView.currentTemplate == .Two {
            allowsShare(numberOfPicturesAvailable: 3)
        }
        
        if picturesView.currentTemplate == .Three {
            allowsShare(numberOfPicturesAvailable: 4)
        }
    }
    
    func resetImageDisposition() {
        for disposition in dispositions {
            disposition.imageView?.isHidden = true
        }
    }
    
    func resetImage() {
        for button in buttons {
            button.setImage(nil, for: .normal)
        }
    }
    
    
    @IBAction func didTappedOnDisposition(_ sender: UIButton) {
        resetImageDisposition()
        sender.imageView?.isHidden = false
        if let template = PicturesView.Template(rawValue: sender.tag) {
            picturesView.currentTemplate = template
        }
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
    
    @IBAction func pressButtonForAddImage(_ sender: UIButton) {buttonClicked = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Select a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
                self.alert(titleEntered: "Camera not avalaible", messageEntered: "Please, choose a picture in your Photo Library")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.pickAnImage()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
}

extension ViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if info[UIImagePickerController.InfoKey.originalImage] != nil {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                buttonClicked.setImage(image, for: .normal)
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
