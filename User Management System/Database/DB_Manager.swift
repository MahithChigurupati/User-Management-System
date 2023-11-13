//
//  DB_Manager.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import Foundation
import SQLite

class DB_Manager {
    // sqlite instance
    private var db: Connection!

    // table instance
    private var users: Table!

    // columns instances of table
    private var id: Expression<Int>!
    private var firstName: Expression<String>!
    private var lastName: Expression<String>!
    private var email: Expression<String>!
    private var phone: Expression<String>!

    // constructor of this class
    init() {
        // exception handling
        do {
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""

            // creating database connection
            db = try Connection("\(path)/UserManagement.sqlite3")

            // creating table object
            users = Table("users")

            // create instances of each column
            id        = Expression<Int>("id")
            firstName = Expression<String>("firstName")
            lastName  = Expression<String>("lastName")
            email     = Expression<String>("email")
            phone     = Expression<String>("phone")

            // check if the user's table is already created
            if !UserDefaults.standard.bool(forKey: "is_db_created") {
                // if not, then create the table
                try db.run(users.create { t in
                    t.column(id, primaryKey: true)
                    t.column(firstName)
                    t.column(lastName)
                    t.column(email, unique: true)
                    t.column(phone)
                })

                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }

        } catch {
            // show error message if any
            print(error.localizedDescription)
        }
    }

    public func addUser(firstNameValue: String, lastNameValue: String, emailValue: String, phoneValue: String) {
        do {
            try db.run(users.insert(firstName <- firstNameValue, lastName <- lastNameValue, email <- emailValue, phone <- phoneValue))
        } catch {
            print(error.localizedDescription)
        }
    }

    // return array of user models
    public func getUsers() -> [UserModel] {
        // create empty array
        var userModels: [UserModel] = []

        // get all users in descending order
        users = users.order(id.desc)

        // exception handling
        do {
            // loop through all users
            for user in try db.prepare(users) {
                // create new model in each loop iteration
                let userModel: UserModel = UserModel()

                // set values in model from database
                userModel.id        = user[id]
                userModel.firstName = user[firstName]
                userModel.lastName  = user[lastName]
                userModel.email     = user[email]
                userModel.phone     = user[phone]

                // append in new array
                userModels.append(userModel)
            }
        } catch {
            print(error.localizedDescription)
        }

        // return array
        return userModels
    }

    // get single user data
    public func getUser(idValue: Int) -> UserModel {
        // create an empty object
        let userModel: UserModel = UserModel()

        // exception handling
        do {
            // get user using ID
            let user: AnySequence<Row> = try db.prepare(users.filter(id == idValue))

            // get row
            try user.forEach({ rowValue in

                // set values in model
                userModel.id        = try rowValue.get(id)
                userModel.firstName = try rowValue.get(firstName)
                userModel.lastName  = try rowValue.get(lastName)
                userModel.email     = try rowValue.get(email)
                userModel.phone     = try rowValue.get(phone)
            })
        } catch {
            print(error.localizedDescription)
        }

        // return model
        return userModel
    }
    
    // get single user data
    public func getUser(from emailValue: String) -> UserModel? {
        // create an empty object
        var userModel: UserModel?

        // exception handling
        do {
            // get user using ID
            let user: AnySequence<Row> = try db.prepare(users.filter(email == emailValue))

            // get row
            try user.forEach({ rowValue in
                
                if userModel == nil {
                    userModel = UserModel()
                }

                // set values in model
                userModel?.id        = try rowValue.get(id)
                userModel?.firstName = try rowValue.get(firstName)
                userModel?.lastName  = try rowValue.get(lastName)
                userModel?.email     = try rowValue.get(email)
                userModel?.phone     = try rowValue.get(phone)
            })
        } catch {
            print(error.localizedDescription)
        }

        // return model
        return userModel
    }

    // function to update user
    public func updateUser(idValue: Int, firstNameValue: String, lastNameValue: String, emailValue: String, phoneValue: String) {
        do {
            // get user using ID
            let user: Table = users.filter(id == idValue)

            // run the update query
            try db.run(user.update(firstName <- firstNameValue, lastName <- lastNameValue, email <- emailValue, phone <- phoneValue))
        } catch {
            print(error.localizedDescription)
        }
    }

    // function to delete user
    public func deleteUser(idValue: Int) {
        do {
            // get user using ID
            let user: Table = users.filter(id == idValue)

            // run the delete query
            try db.run(user.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}
