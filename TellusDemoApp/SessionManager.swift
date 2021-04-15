//
//  SessionManager.swift
//  TellusDemoApp
//
//  Created by GGTECH LLC on 4/14/21.
//

import Foundation
enum SessionKeys : String{
    case token,user,loginType,isLoggedin
}
class SessionManager{
    public static let shared = SessionManager()
    private init(){}
    private let userDefaults = UserDefaults.standard
    
    func saveLoginSession(token:String){
        saveValue(with: .token, value: token)
        saveValue(with: .isLoggedin, value: true)
    }
    func saveLoginUser(user:User){
        do{
            let userData = try JSONEncoder().encode(user)
            if let data = String(data: userData, encoding: .utf8){
            saveValue(with: .user, value: data)
                saveValue(with: .isLoggedin, value: true)
            }
        }catch{}
    }
    func getCurrentUser()->User?{
        let userData:String? = getValue(with: .user)
        if let jsonData = userData?.data(using: .utf8){
            let user = try! JSONDecoder().decode(User.self, from: jsonData)
            return user
        }
        return nil
    }
    func isLogin()->Bool{
        return getValue(with: .isLoggedin) ?? false
    }
    var loginType: LoginType? {
        get {
            guard let type:String = getValue(with: .loginType) else {
                return nil
            }
            return LoginType(rawValue:type)
        }
        set(type) {
            saveValue(with: .loginType, value: type)
        }
    }
    func logout(){
        saveValue(with: .isLoggedin, value: false)
    }
    func saveValue(with key:SessionKeys,value:Any?){
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    func getValue<T>(with key:SessionKeys)->T?{
        return userDefaults.value(forKey: key.rawValue) as? T
    }
}
