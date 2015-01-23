//
//  ViewController.swift
//  Instaconcept
//
//  Created by Chris Da silva on 2015-01-13.
//  Copyright (c) 2015 Chris Da silva. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var signedActive = true
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var signUpToggle: UIButton!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var toggle2: UIButton!
    
    @IBAction func toggle(sender: AnyObject) {
        if signedActive {
        signedActive = false
        loginLabel.text = "Login below."
        //signUpToggle.setTitle("Login", forState: UIControlState.Normal)
            signUpToggle.titleLabel?.text = "Login"
        label2.text = "New user?"
        //toggle2.setTitle("Sign up", forState: UIControlState.Normal)
            toggle2.titleLabel?.text = "Sign up"// -<<<<<<<<<<<< DOES NOT CHANGE///////////////////////////// <<<<<<<<<<

        
        } else {
           signedActive = true
            loginLabel.text = "New? Sign up below."
            //signUpToggle.setTitle("Sign up", forState: UIControlState.Normal)
            signUpToggle.titleLabel?.text = "Sign up"
            label2.text = "Already have an account?"
            //signUpToggle.setTitle("Login", forState: UIControlState.Normal)
             toggle2.titleLabel?.text = "Login"
        }
    }
    


    func alertUser(title:String,error:String){
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
        
        self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
    
        var error = ""
        if username.text == "" || password.text == "" {
            error = "Please enter a username and password"
        }
        if error != "" {
            alertUser("Error in Form", error: error)
            
        } else {
            
            //Show query progress//
            
            activityIndicator = UIActivityIndicatorView(frame:CGRectMake(0, 0, 50, 50) )
                activityIndicator.center = self.view.center
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            if signedActive {
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, registerError: NSError!) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if registerError == nil {
                    if PFUser.currentUser() != nil {
                        self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                    }
                    
                } else {
                    
                    if let errorString = registerError.userInfo?["error"] as? NSString {
                        
                        error = errorString
                    }else{
                        error = "Oops, Looks like the server can't keep up with you please try again later."
                    }
                    self.alertUser("Cmon be original!", error: error)
                }
            }
                
             } else {
                PFUser.logInWithUsernameInBackground(username.text, password: password.text) {
                    (user: PFUser!, loginError: NSError!) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if loginError == nil {
                        if PFUser.currentUser() != nil {
                            self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                        }
                    } else {
                        if let errorString = loginError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Oops, Looks like the server can't keep up with you please try again later."
                        }
                        self.alertUser("Don't get trigger happy...", error: error)
                    }
                }
            }
        }
        
    }
    /*     reusable code!                                     */
//    @IBOutlet weak var pickedImage: UIImageView!
//    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        pickedImage.image = image
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    
//    @IBAction func imagePicker(sender: AnyObject) {
//        var image = UIImagePickerController()
//        image.delegate = self
//        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        image.allowsEditing = false
//        self.presentViewController(image, animated: true, completion: nil)
//    }
//    
//    
//    @IBAction func alert(sender: AnyObject) {
//        var alert = UIAlertController(title: "Are you sure you wanna die?", message: "Are you mega sure?", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "yes", style: .Default, handler: { action in
//            
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
//        
//        
//    }
//    
//    
//    @IBAction func pause(sender: AnyObject) {
//        var activityIndicator = UIActivityIndicatorView(frame:CGRectMake(0, 0, 50, 50) )
//    activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//        
//    }
//    
//    @IBAction func resume(sender: AnyObject) {
//        
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //Do any additional setup after loading the view, typically from a nib.
        
      
    }
    override func viewDidAppear(animated: Bool) {
      
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("jumpToUserTable", sender: self)
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

