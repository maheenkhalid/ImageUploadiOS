//
//  ViewController.swift
//  ImageUpload
//
//  Created by Maheen Khalid on 16/02/2016.
//  Copyright © 2016 Maheen khalid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chooseImage(sender: AnyObject) {
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func upload(sender: AnyObject) {
        if let image = self.imageView.image {
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            
            let urlString = "YOUR_URL_HERE"
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            
            mutableURLRequest.HTTPMethod = "POST"
            
            let boundaryConstant = "----------------12345";
            let contentType = "multipart/form-data;boundary=" + boundaryConstant
            mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            // create upload data to send
            let uploadData = NSMutableData()
            
            // add image
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"picture\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData(imageData!)
            uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            mutableURLRequest.HTTPBody = uploadData
            
            
            let task = session.dataTaskWithRequest(mutableURLRequest, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    // Image uploaded
                }
            })
            
            task.resume()
            
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods -
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

