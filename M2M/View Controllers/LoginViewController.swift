//
//  LoginViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets and Properties
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = [usernameField, passwordField].map { $0.delegate = self }
        autoFillFields()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        tapToDismissSetup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    // MARK: - Methods and Functions
    @IBAction func loginButton(_ sender: Any) {
        samLogin()
    }
    
    func autoFillFields() {
        if let loginTuple = Defaults.manager.autoFillTextFields() {
            usernameField.text = loginTuple.0
            passwordField.text = loginTuple.1
        }
    }
    
    func samLogin() {
        loginButton.isEnabled = false
        guard let loginName = usernameField.text, let loginPassword = passwordField.text else {
            loginButton.isEnabled = true
            return
        }
        
        let  loginInfo = PatientCredential(email: loginName, password: loginPassword)
        var login = RestApiManager()
        
        login.stringURL = "https://apiserver269.herokuapp.com/auth/local"
        login.login(withCredentials: loginInfo) { tempData in
            print(tempData)
            let loginData = tempData
            
            DispatchQueue.main.async {
                let auth = AuthData.auth
                auth.setLogin(loginData)

                guard let userID = auth.getUserID() else { return }
                
                print("Date: \(Date.timeIntervalSinceReferenceDate)")
                
                print("Login data is \(String(describing: userID))")
                Defaults.manager.saveToDefaults(loginInfo)
                self.present(mainVC, animated: true) { [unowned self] in
                    self.loginButton.isEnabled = true

                    SelectedExercise.manager.populateExercises()
                    // NOTE: Vic's non-unit test
                    
                    // NOTE: End testing here
                }
            }
        }
    }

    func tapToDismissSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordField.resignFirstResponder()
            samLogin()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        //    guard let keyboardFrame = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        //    scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + 20
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset

    }

    @objc func keyboardWillHide(notification: NSNotification){
        //      scrollView.contentInset.bottom = 0

        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
