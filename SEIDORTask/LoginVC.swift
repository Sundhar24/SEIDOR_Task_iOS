//
//  LoginVC.swift
//  SEIDORTask
//
//  Created by Sundhar on 06/07/24.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var enterEmailTxt: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var enteredEmail: String?
    var enteredPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewcall()
        self.enterEmailTxt.delegate = self
        self.passwordTxt.delegate = self
        self.submitBtn.addTarget(self, action: #selector(SubmitTapped), for: .touchUpInside)
       
    }
    
    
    func viewcall(){
        passwordTxt.isSecureTextEntry = true
        emailView.layer.borderColor = UIColor.black.cgColor
        passwordView.layer.borderColor = UIColor.black.cgColor
        emailView.layer.borderWidth = 0.5
        passwordView.layer.borderWidth = 0.5
        emailView.layer.cornerRadius = 10
        passwordView.layer.cornerRadius = 10
        submitBtn.layer.cornerRadius = 10
        
    }
    
    @objc func SubmitTapped() {
        guard let email = enterEmailTxt.text, !email.isEmpty else {
            showAlertWithmsg(msg: "Please enter your email")
            return
        }
        
        guard email.isValidEmail else {
            showAlertWithmsg(msg: "Please enter a valid email")
            return
        }
        
        guard let password = passwordTxt.text, !password.isEmpty else {
            showAlertWithmsg(msg: "Please enter your password more than 6 letters")
            return
        }
        
        guard password.isValidPassword else {
            showAlertWithmsg(msg: "Password must be at least 6 characters long")
            return
        }
        
        // Save login credentials in UserDefaults
        UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let characterListVC = mainStoryboard.instantiateViewController(withIdentifier: "CharacterListVC") as! CharacterListVC
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = characterListVC
            window.makeKeyAndVisible()
        }
    }



}

extension LoginVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == enterEmailTxt {
            
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 100
            
            let currentCharacterCount1 = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount1 {
                return false
            }
            let newLength1 = currentCharacterCount1 + string.count - range.length
            return newLength1 <= 11
            
        } else if textField == passwordTxt {
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 20
        }
        
        else{
            return false
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == enterEmailTxt || textField == passwordTxt {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == enterEmailTxt || textField == passwordTxt {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        return true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 40
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension UIViewController{
    func showAlertWithmsg(msg:String? = ""){
        let alertController = UIAlertController(title: "", message: msg, preferredStyle:UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
            
        })
        self.present(alertController, animated: true, completion: nil)

    }

}
extension String {
    var isValidEmail: Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    var isValidPassword: Bool {
            return self.count >= 6
    }

}

