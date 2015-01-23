//
//  postViewController.swift
//  Instaconcept
//
//  Created by Chris Da silva on 2015-01-21.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit
import Parse

class postViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var photoSelected:Bool = false
    @IBOutlet weak var shareText: UITextField!
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var background: UIImageView!
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    func alertUser(title:String,error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                ///visualls/////////////////////
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        
        visualEffectView.frame = background.bounds
        
        background.addSubview(visualEffectView)
      let vibrancyEffect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Light))
    
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(vibrancyView)
        ///visuals/////////////////
               }

        func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
            imageToPost.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            photoSelected = true
        }
    
    @IBAction func chooseImage(sender: AnyObject) {
                var image = UIImagePickerController()
                image.delegate = self
                image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                image.allowsEditing = false
                self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBAction func submitPost(sender: AnyObject) {
        var error = ""
        if (photoSelected == false) {
            error = "Please select an image"
        }
//        else if ( shareText.text == "" ) {
//            
//            error = "Please enter a message"
//        }
        if error != "" {
            alertUser("Cannot post image", error: error)
        } else {
            activityIndicator = UIActivityIndicatorView(frame:CGRectMake(0, 0, 50, 50) )
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();            var post = PFObject(className: "Post")
            //post["Title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            post.saveInBackgroundWithBlock {(success: Bool!, error: NSError!) -> Void in
                
                if success == false {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.alertUser("your image is to heavy for our server", error: "Please try later")
                    
                } else {
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    post["imageFile"] = imageFile
                    post.saveInBackgroundWithBlock {(success: Bool!, error: NSError!) -> Void in
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        if success == false {
                            self.alertUser("your image is to heavy for our server", error: "Please try later")
                        } else {
                            self.alertUser("Image posted", error: "Your image has been posted successfully")
                            self.photoSelected = false
                            self.imageToPost.image = UIImage(named:"photo.jpg" )
                            println("imagePosted")
                        }
                    }
                }
                
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
