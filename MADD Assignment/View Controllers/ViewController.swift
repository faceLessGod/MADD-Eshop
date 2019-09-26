//
//  ViewController.swift
//  MADD Assignment
//
//  Created by Aruna Lakmal2 on 9/21/19.
//  Copyright © 2019 Aruna Lakmal2. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var roleSegment: UISegmentedControl!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var selectedSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboardOnBackgroundTap()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let urlString = "https://reqres.in/api/login"
        
        Alamofire.request(urlString,
                          method: .post,
                          parameters: ["email":self.userName.text,"password": self.password.text],
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON {
                            response in
                            switch response.result {
                            case .success:
                                self.handleRoles()
                            case .failure(let error):
                                self.showAlert(title: "Login Error", message: error.localizedDescription)
                            }
        }
    }
    
    func handleRoles() {
        let segueIdentifier = self.selectedSegmentIndex == 0 ? SegueIdentifiers.buyerIdentifier : SegueIdentifiers.sellerIdentifier
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let urlString = "https://reqres.in/api/register"
        
        Alamofire.request(urlString,
                          method: .post,
                          parameters: ["email":self.userName.text,"password": self.password.text],
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON {
                            response in
                            switch response.result {
                            case .success:
                                break
                            case .failure(let error):
                                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                            }
        }
    }
    
    @IBAction func onSelectRole(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
    }
    
}

