//
//  SignUpViewController.swift
//  TellusDemoApp
//
//  Created by GGTECH LLC on 4/14/21.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "TellusLogo.jpg"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let facebookButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Sign in with Facebook", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.setImage(UIImage(named: "icon-facebook") , for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        button.addTarget(self, action: #selector(fbButtonDidTap), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.setImage(UIImage(named: "icon-google") , for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: -35, bottom: 12, right: 0)
        
        button.addTarget(self, action: #selector(googleButtonDidTap), for: UIControl.Event.touchUpInside)
        
        return button
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(submitTapped), for: UIControl.Event.touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    @objc func fbButtonDidTap(){
        Facebook.logIn(from: self, completion: handleLoginResult(result:))
    }
    @objc func googleButtonDidTap(){
        Google.logIn(from: self,completion: handleLoginResult(result:))
    }
    @objc func submitTapped(){
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        TellusBackend.logIn(credential: email, password: password,completion: handleTellusLoginResult(result:))
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isFormValid {
            submitButton.isEnabled = true
            submitButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        /* uncomment for keyboard adjustments
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        */
        setupLogo()
        setupInputFields()
        hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        
    }
    
    
    fileprivate func setupLogo(){
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

    }
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, facebookButton, googleButton, submitButton])
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 80, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 260)
    }
    
    private func handleLoginResult(result:(Result<String, Error>)){
        switch result{
        case .success(let token):
            print("Success",token)
            SessionManager.shared.saveLoginSession(token: token)
            saveLoginAndMovetoHome()
        case .failure(let error):
            showAlert()
            print("Login Failed",error)
        }
    }
    private func handleTellusLoginResult(result:(Result<User, Error>)){
        switch result{
        case .success(let user):
            print("User",user)
            SessionManager.shared.saveLoginUser(user: user)
            saveLoginAndMovetoHome()
        case .failure(let error):
            showAlert()
            print("Login Failed",error)
        }
    }
    private func saveLoginAndMovetoHome(){
        let controller = HomeViewController()
        let homeController = UINavigationController(rootViewController: controller)
        homeController.modalPresentationStyle = .overFullScreen
        
        homeController.modalTransitionStyle = .crossDissolve
        self.present(homeController, animated: true, completion: nil)
    }
   
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

