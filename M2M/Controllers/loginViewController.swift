//
//  ViewController.swift
//  thePrototype
//
//  Created by Tran Sam on 9/21/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        let  loginInfo = PatientCredential(email: "sam@motion2movement.com", password: "samsam2610")
        var login = RestApiManager()
        login.stringURL = "https://apiserver269.herokuapp.com/auth/local"
        login.Login(loginCredential: loginInfo) { tempData in
            print(tempData)
            let loginData = tempData
            DispatchQueue.main.async {
                let auth = authData.auth
                auth.loginData = loginData
                print("Login data is \(String(describing: auth.loginData!.userID))")
                self.present(mainVC, animated: true, completion: nil)
            }
        }
    }
    
}






