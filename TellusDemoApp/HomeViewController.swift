//
//  HomeViewController.swift
//  TellusDemoApp
//
//  Created by GGTECH LLC on 4/14/21.
//

import Foundation
import UIKit


class HomeViewController: UIViewController {
   
    let logoutGroup = DispatchGroup()
   
    let tellusLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Smart Savers Choose Tellus\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40)])
        
        attributedText.append(NSAttributedString(string: "No Fees ● 3% APY* ● Paid Out Daily", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogOutButton()
        setupCenterLabel()
        view.backgroundColor = .white
    }
    
    fileprivate func setupLogOutButton() {
        
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleLogOut))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleLogOut))
        }
        let image: UIImage = UIImage(named: "TellusLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
       
    }
    
    fileprivate func setupCenterLabel(){
        view.addSubview(tellusLabel)
        tellusLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 50, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        tellusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tellusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.logoutUser()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func logoutUser(){
        switch SessionManager.shared.loginType {
        case .facebook:
            logoutGroup.enter()
            Facebook.logOut(completion: handleLogoutResult(result:))
        case .google:
            logoutGroup.enter()
            Google.logOut(completion: handleLogoutResult(result:))
        case .tellUs:
            logoutGroup.enter()
            TellusBackend.logOut(completion: handleLogoutResult(result:))
        case .none: break
            
        }
        logoutGroup.notify(queue: .main) {
            SessionManager.shared.logout()
            let signUpViewController = SignupViewController()
            
            signUpViewController.modalPresentationStyle = .fullScreen
            signUpViewController.modalTransitionStyle = .crossDissolve
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    private func handleLogoutResult(result:Result<Void, Error>){
        switch result {
        case .success:
            logoutGroup.leave()
        case .failure(let error):
            print("Failed to logout",error)
            showAlert()
        }
    }
}
