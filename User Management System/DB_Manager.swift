//
//  DB_Manager.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import Foundation
// import library
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
}
