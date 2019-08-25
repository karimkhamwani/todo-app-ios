//
//  AddTodoViewController.swift
//  TodoApplication
//
//  Created by Karim on 25/08/2019.
//  Copyright © 2019 Karim. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var sayTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var managedContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyBoardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        sayTextView.becomeFirstResponder();
        sayTextView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden{
            sayTextView.text.removeAll()
            sayTextView.textColor = UIColor.white
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func KeyBoardWillShow(with notification : Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return };
        let keyboardHeight = keyboardFrame.cgRectValue.height;
        bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        print("Keyboard shows")
    }
    

    fileprivate func dismissAndResgin() {
        dismiss(animated: true)
        sayTextView.resignFirstResponder()
    }
    
    @IBAction func onPressCancel(_ sender: Any) {
        dismissAndResgin()
    }
    @IBAction func onPressDone(_ sender: Any) {
        guard let title = sayTextView.text, !title.isEmpty else {
            return;
        }
        let todo = Todo(context: managedContext)
        todo.title = title;
        todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        todo.date = Date()
        
        do {
            try managedContext.save()
            dismissAndResgin()
        }
        catch{
            print("Error while saving" , error);
        }
    }
}
