//
//  UserModel.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import Foundation
 
class UserModel: Identifiable {
    public var id: Int = 0
    public var firstName: String = ""
    public var lastName: String = ""
    public var email: String = ""
    public var phone: String = ""
}
