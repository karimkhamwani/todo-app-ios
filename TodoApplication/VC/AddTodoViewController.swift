//
//  AddTodoViewController.swift
//  TodoApplication
//
//  Created by Karim on 25/08/2019.
//  Copyright © 2019 Karim. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var sayTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
    

    @IBAction func onPressCancel(_ sender: Any) {
        dismiss(animated: true)
        sayTextView.resignFirstResponder()
    }
    @IBAction func onPressDone(_ sender: Any) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
