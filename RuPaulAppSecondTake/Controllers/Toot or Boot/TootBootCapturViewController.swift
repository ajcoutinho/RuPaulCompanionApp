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
    
    //tracks if Camera is being used or not.
    var usingCamera = false

    //MARK: - Outlets
    @IBOutlet weak var TootBootCaptureImage: UIImageView!
    
    //MARK: - Load Method
    override func viewDidLoad() {
        super.viewDidLoad()

        //Gets the starting point of the imageview
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(displayInfo))
        //Temporary call to initial alert. Need to find why camera calls viewWillAppear and photo library does not
        //navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera.circle"), style: .plain, target: self, action: #selector(firstCall))
        
        //firstCall()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //camera has been used
        if(usingCamera) {
            usingCamera = false
            return
        } else {
            //camera has not been used, i.e. entered from a tab.
            firstCall()
        }
        
    }
    
    //Alert handler helper method
    //Called to handle various actions in this scene's AlertControllers
    func alertHandler(_ key: Int) {
        switch(key) {
            
        //Case 0: Resets the capture without setting the source.
        case 0:
            //UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            //    self.TootBootCaptureImage.transform = .identity
            //}, completion: nil)
            if(self.imagePicker.sourceType == .camera) {
                usingCamera = true
            }
            self.present(self.imagePicker, animated: true)
            
        //1: Resets the capture, setting the source to "Camrea"
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                //UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                //    self.TootBootCaptureImage.transform = .identity
                //}, completion: nil)
                
                self.imagePicker.sourceType = .camera
                self.usingCamera = true
                self.present(self.imagePicker, animated: true)
                    } else {
                        //Camera is unavailable; asks if they want to use Library.
                        alertHandler(4)
                    }
            
        //2: Resets the capture, setting the source to "Photo Library"
        case 2:
            //UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    //self.TootBootCaptureImage.transform = .identity
                //}, completion: nil)
            
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
        guard let image = self.TootBootCaptureImage.image else { return }
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.TootBootCaptureImage.transform = CGAffineTransform(translationX: -1000, y: 0)
        }, completion: {
            _ in
            //Removes the image, and returns it to the center
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.TootBootCaptureImage.image = nil
                self.TootBootCaptureImage.transform = CGAffineTransform.identity
            })
        })
        
        //Saves an item to the gallery list, with the TootBoot set to 'true'
        let imageName = UUID().uuidString
        let newItem = TootBootItem(photo: imageName, TootBoot: true)
        self.itemsList.saveImage(image: image, withIdentifier: imageName)
        self.itemsList.addItem(item: newItem)
        
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
        guard let image = self.TootBootCaptureImage.image else { return }
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.TootBootCaptureImage.transform = CGAffineTransform(translationX: 1000, y: 0)
        }, completion: {
            _ in
            
            //Remove the image, and return it to the center
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.TootBootCaptureImage.image = nil
                self.TootBootCaptureImage.transform = CGAffineTransform.identity
            })
        })
        
        //Saves an item to the gallery list, with the TootBoot set to 'false'
        let imageName = UUID().uuidString
        let newItem = TootBootItem(photo: imageName, TootBoot: false)
        self.itemsList.saveImage(image: image, withIdentifier: imageName)
        self.itemsList.addItem(item: newItem)
        
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
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.TootBootCaptureImage.transform = CGAffineTransform(translationX: 0, y: 1600)
        }, completion: {
            _ in
            //Remove the image, and return it to the center
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.TootBootCaptureImage.image = nil
                self.TootBootCaptureImage.transform = CGAffineTransform.identity
            })
        })
        
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
    
    @objc func firstCall() {
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
    
    @objc func displayInfo() {
        let alert = UIAlertController(title: "Toot or Boot", message: "If you like something, swipe the image left to TOOT it. If not, swipe right to BOOT it. Either way, the image is added to the Gallery. Swipe down to discard the image and take another photo.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        
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
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
        
        let alert = UIAlertController(title: "Canceled Photo selection", message: "Did you want to try again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            //Presents the Imagepicker
            self.alertHandler(0)
        }))
        if(imagePicker.sourceType == .camera) {
            alert.addAction(UIAlertAction(title: "Use Photo in Library", style: .default, handler: { _ in
                //Present the ImagePicker, setting its source to Photo Library
                self.alertHandler(2)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Take Photo with Camera", style: .default, handler: { _ in
                //Present the ImagePicker, setting its source to Photo Library
                self.alertHandler(1)
            }))
        }
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            //Goes to the Gallery
            self.alertHandler(3)
        }))
        
        present(alert, animated: true)
    }
    
}
