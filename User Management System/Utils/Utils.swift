//
//  Utils.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/13/23.
//

import Foundation

class Utils{
    func isEmailExist(email: String) -> UserModel? {
            return DB_Manager().getUser(from: email)
        }

    // Email validation using regular expression
    func isValidEmail(email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // Phone number validation using regular expression
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
}
