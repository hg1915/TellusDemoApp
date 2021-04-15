//
//  API.swift
//  TellusDemoApp
//
//  Created by GGTECH LLC on 4/14/21.
//

import UIKit
import Foundation
enum LoginType:String{
    case tellUs,facebook,google
}
enum Facebook {
    /// This method presents the Facebook authentication flow and if successful returns an authentication token, returning to the presenting screen.
    static func logIn(from presentingViewController: UIViewController, completion: (Result<String, Error>) -> Void) {
        if Bool.random() {
            completion(.success("a-token"))
        } else {
            completion(.failure(GenericError()))
        }
    }
    static func logOut(completion: (Result<Void, Error>) -> Void) {
        if Bool.random() {
            completion(.success(()))
        } else {
            completion(.failure(GenericError()))
        }
    }
}

enum Google {
    /// This method presents the Google authentication flow and if successful returns an authentication token, returning to the presenting screen.
    static func logIn(from presentingViewController: UIViewController, completion: (Result<String, Error>) -> Void) {
        if Bool.random() {
            completion(.success("a-token"))
        } else {
            completion(.failure(GenericError()))
        }
    }
    static func logOut(completion: (Result<Void, Error>) -> Void) {
        if Bool.random() {
            completion(.success(()))
        } else {
            completion(.failure(GenericError()))
        }
    }
}

enum TellusBackend {
    /// Logs the user in if an account with the given email already exists, or creates a new user using the given email.
    static func logIn(credential: String, password: String, completion: (Result<User, Error>) -> Void) {
        if Bool.random() {
            completion(.success((User(session: UUID().uuidString))))
        } else {
            completion(.failure(GenericError()))
        }
    }
    /// Logs the user in using a 3rd party token
    static func logIn(token: String, completion: (Result<User, Error>) -> Void) {
        if Bool.random() {
            completion(.success((User(session: UUID().uuidString))))
        } else {
            completion(.failure(GenericError()))
        }
    }
    /// Logs the user out regardless of the authentication method used.
    static func logOut(completion: (Result<Void, Error>) -> Void) {
        if Bool.random() {
            completion(.success(()))
        } else {
            completion(.failure(GenericError()))
        }
    }
}


struct GenericError : Error {}
struct User : Codable{
    let session: String
}
