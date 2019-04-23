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
    @IBOutlet var dispositions: [UIButton]!
    var buttonClicked: UIButton!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var swipeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        picturesView.currentTemplate = .Two
        self.dispositions[1].setImage(UIImage(named:"dispositionInUse"), for: [])
        
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
    
    func orientation(text: String, direction: UISwipeGestureRecognizer.Direction) {
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
            self.picturesView.resetImage()
            
        }
        animateView(postition: -screenHeight)
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
            if picturesView.allowsShare(numberOfButtonNeedImage: 3) == true {
                share()
            } else {
                alert(titleEntered: "Add picture", messageEntered: "Please, add picture on all buttons before swipe to share")
            }
        }
        else if picturesView.currentTemplate == .Three {
            if picturesView.allowsShare(numberOfButtonNeedImage: 4) == true {
                share()
            } else {
                alert(titleEntered: "Add picture", messageEntered: "Please, add picture on all buttons before swipe to share")
            }
        }
    }
    
    @IBAction func templateDisposition(_ sender: UIButton) {
        for disposition in dispositions {
            disposition.setImage(nil, for: [])
        }
        if let template = PicturesView.Template(rawValue: sender.tag) {
            picturesView.currentTemplate = template
            sender.setImage(UIImage(named: "dispositionInUse"), for: [])
        }
    }
    
    func library() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.present(myPickerController, animated: true)
            }
        }
    }
    
    func camera()  {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
    }
    
    func alertForCameraAndPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.camera()
            } else {
                print("Camera not available")
                self.alert(titleEntered: "Camera not avalaible", messageEntered: "Please, choose a picture in your Photo Library")
            }
        }))
        alertSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            print("Library access")
            self.library()
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
                buttonClicked.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                buttonClicked.setImage(image, for: .normal)
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
