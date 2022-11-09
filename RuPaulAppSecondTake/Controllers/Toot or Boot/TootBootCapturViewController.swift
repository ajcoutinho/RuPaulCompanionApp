//
//  TootBootCapturViewController.swift
//  RuPaulAppSecondTake
//
//  Created by Alex Coutinho on 2022-10-06.
//

import UIKit

class TootBootCapturViewController: UIViewController, UIGestureRecognizerDelegate{

    //MARK: - Properties
    var itemsList: TootBootItems!
    let imagePicker = UIImagePickerController()
    var imageStart: CGPoint!

    //MARK: - Outlets
    @IBOutlet weak var TootBootCaptureImage: UIImageView!
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()

        imageStart = CGPoint(x: TootBootCaptureImage.center.x, y: TootBootCaptureImage.center.y)

        TootBootCaptureImage.isUserInteractionEnabled = true
        
        //set the gesture reconizers in the photo view
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipedLeft))
        swipeLeft.delegate = self
        swipeLeft.direction = .left
        TootBootCaptureImage.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipedRight))
        swipeRight.delegate = self
        swipeRight.direction = .right
        TootBootCaptureImage.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipedDown))
        swipeDown.delegate = self
        swipeDown.direction = .down
        TootBootCaptureImage.addGestureRecognizer(swipeDown)
        
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Toot or Boot!", message: "If you like it, swipe left to TOOT it, otherwise, swipe left to BOOT it.\n Would you like to take a photo?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
            //Sets source to camera, and presents the imagePicker
            self.alertHandler(1)
        }))
        alert.addAction(UIAlertAction(title: "Use photo in Library", style: .default, handler: { (_) in
            //Sets source to Library, and presents the imagePicker
            self.alertHandler(2)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            //Goes to the Gallery.
            self.alertHandler(3)
        }))
        
        present(alert, animated: true)
    }
    
    //Alert handler helper method
    //Called to handle various actions in this scene's AlertControllers
    func alertHandler(_ key: Int) {
        switch(key) {
            
        //Case 0: Resets the capture without setting the source.
        case 0:
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.TootBootCaptureImage.center = self.imageStart
            }, completion: nil)
            self.present(self.imagePicker, animated: true)
            
        //1: Resets the capture, setting the source to "Camrea"
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                                self.TootBootCaptureImage.center = self.imageStart
                        }, completion: nil)
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
                    } else {
                        //Camera is unavailable; asks if they want to use Library.
                        alertHandler(4)
                    }
            
        //2: Resets the capture, setting the source to "Photo Library"
        case 2:
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                            self.TootBootCaptureImage.center = self.imageStart
                        }, completion: nil)
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
            
        //3: Sends the user to the gallery tab
        case 3:
            tabBarController?.selectedIndex = 2
            
        //4: Camera is unavailable. Asks if they want to use Photo Library.
        case 4:
            let errorAlert = UIAlertController(title: "You do not have access to the camera.", message: "Would you like to use photos from your Photo Library instead?", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                            //Sets source to Library, and presents the imagePicker
                            self.alertHandler(2)
                        }))
                        errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                            // Goes to the gallery
                            self.alertHandler(3)
                        }))
            self.present(errorAlert, animated: true)
            
        default:
            break
        }
    }
    
    
    //MARK: - Obj-C Methods
    @objc func viewSwipedLeft() {
        
        //Image flies off the screen to the left
        let targetSpot = CGPoint(x: -1000, y: TootBootCaptureImage.center.y)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.TootBootCaptureImage.center = targetSpot
        }, completion: nil)
        
        //Saves an item to the gallery list, with the TootBoot set to 'true'
        if let image = TootBootCaptureImage.image {
            let imageName = UUID().uuidString
            let newItem = TootBootItem(photo: imageName, TootBoot: true)
            itemsList.saveImage(image: image, withIdentifier: imageName)
            itemsList.addItem(item: newItem)
        }
        
        let alert = UIAlertController(title: "Toot!", message: "Would you like to take another?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            //Presents the imagePicker
            self.alertHandler(0)
        }))
        if(imagePicker.sourceType == .camera) {
            alert.addAction(UIAlertAction(title: "Use photo in Library", style: .default, handler: { (_) in
                //Sets the source to Library, and presents the ImagePicker
                self.alertHandler(2)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Take photo with Camera", style: .default, handler: { (_) in
                //Sets the source to camera, and presents the ImagePicker
                self.alertHandler(1)
            }))
        }
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            // Goes to the gallery
            self.alertHandler(3)
        }))
        present(alert, animated: true)
    }
    
    @objc func viewSwipedRight() {
        
        //Image flies off the screen to the right
        let targetSpot = CGPoint(x: 1000, y: TootBootCaptureImage.center.y)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.TootBootCaptureImage.center = targetSpot
        }, completion: nil)
        
        //Saves an item to the gallery list, with the TootBoot set to 'false'
        if let image = TootBootCaptureImage.image {
            let imageName = UUID().uuidString
            let newItem = TootBootItem(photo: imageName, TootBoot: false)
            itemsList.saveImage(image: image, withIdentifier: imageName)
            itemsList.addItem(item: newItem)
        }
        let alert = UIAlertController(title: "Boot!", message: "Would you like to take another?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            //Presents the imagePicker
            self.alertHandler(0)
        }))
        if(imagePicker.sourceType == .camera) {
            alert.addAction(UIAlertAction(title: "Use photo in Library", style: .default, handler: { (_) in
                //Sets the source to Library, and presents the ImagePicker
                self.alertHandler(2)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Take photo with Camera", style: .default, handler: { (_) in
                //Sets the source to camera, and presents the ImagePicker
                self.alertHandler(1)
            }))
        }
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            // Goes to the gallery
            self.alertHandler(3)
        }))
        present(alert, animated: true)
    }
    
    //Swiping down cancels the creation of a new gallery item.
    @objc func viewSwipedDown() {
        
        //image flies off the screen to the bottom
        let targetSpot = CGPoint(x: TootBootCaptureImage.center.x, y: 1600)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.TootBootCaptureImage.center = targetSpot
        }, completion: nil)
        
        let alert = UIAlertController(title: "Image discarded", message: "Would you like to try again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            //Presents the imagePicker
            self.alertHandler(0)
        }))
        if(imagePicker.sourceType == .camera) {
            alert.addAction(UIAlertAction(title: "Use photo in Library", style: .default, handler: { (_) in
                //Sets the source to Library, and presents the ImagePicker
                self.alertHandler(2)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Take photo with Camera", style: .default, handler: { (_) in
                //Sets the source to camera, and presents the ImagePicker
                self.alertHandler(1)
            }))
        }
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (_) in
            // Goes to the gallery
            self.alertHandler(3)
        }))
        present(alert, animated: true)
    }
   
}

//MARK: - Extensions
extension TootBootCapturViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        TootBootCaptureImage.image = image
        
        self.dismiss(animated: true)
    }
    
}
