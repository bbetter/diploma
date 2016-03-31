//
//  FeedbackController.swift
//  ezlang
//
//  Created by mac on 06.02.16.
//  Copyright © 2016 5wheels. All rights reserved.
//

import UIKit
import MessageUI

//TODO: not working on simulator , test on real device

class FeedbackController : UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var backButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        subject.delegate = self
        body.delegate = self
    }
    
    @IBAction func backPressed(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func sendMail(sender: AnyObject) {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients(["ezlangsup@gmail.com"])
        picker.setSubject(subject.text!)
        picker.setMessageBody(body.text!, isHTML: true)
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITextFieldDelegate
    
    // 2
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    
    // 3
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        body.text = textView.text
        if text == "\n" {
            body.resignFirstResponder()
            
            return false
        }
        
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            if let gestures = self.view.gestureRecognizers as [UIGestureRecognizer]! {
                for gesture in gestures {
                    self.view.removeGestureRecognizer(gesture)
                }
            }
        }
}
