//
//  HDEmployeeImagePickerExtension.swift
//  CoreDataDemo
//
//  Created by Sanchika on 31/07/17.
//  Copyright © 2017 demo. All rights reserved.
//
import UIKit
import CoreData
import AVFoundation

extension HDAddEmployeeDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    final func imagePickerSetup() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.prepareImageForSaving(image: image)
        }
        
        picker.dismiss(animated: true, completion: nil);
        
    }
    
    final func prepareImageForSaving(image:UIImage) {
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        
        // dispatch with gcd.
        convertQueue.async() {
            
            // create NSData from UIImage
            guard let imageData = UIImageJPEGRepresentation(image, 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // scale image, I chose the size of the VC because it is easy
            let thumbnail = image.scale(toSize: CGSize(width: 50, height: 50))
            
            guard let thumbnailData  = UIImageJPEGRepresentation(thumbnail, 0.7) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData: imageData, thumbnailData: thumbnailData, date: date)
            
        }
    }
    
    final func saveImage(imageData:Data, thumbnailData:Data, date: Double) {
        employee!.profilePic = imageData
        employee!.thumbnail = thumbnailData
        DispatchQueue.main.async {
            self.cellRefernce!.setImageDetails(thumbnailData:thumbnailData)
        }
    }
    
    final func photosSelected() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized: presentImagePicker()
        default: accessDenied()
        }
    }
    
    
    func accessDenied() {
        let alert = UIAlertController(title: "Error", message: "Access not allowed", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
