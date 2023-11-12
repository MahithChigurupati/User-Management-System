//
//  AddUserView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import SwiftUI

struct AddUserView: View {
    // create variables to store user input values
    @State var firstName: String = ""
    @State var lastName: String  = ""
    @State var email: String     = ""
    @State var phone: String     = ""

    // to go back on the home screen when the user is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            // create name field
            TextField("Enter First Name", text: $firstName)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)

            // create name field
            TextField("Enter Last Name", text: $lastName)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)

            // create email field
            TextField("Enter email", text: $email)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            // create age field, number pad
            TextField("Enter Phone", text: $phone)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)

            // button to add a user
            Button(action: {
                // call function to add row in sqlite database
                DB_Manager().addUser(firstNameValue: self.firstName,
                                     lastNameValue: self.lastName,
                                     emailValue: self.email,
                                     phoneValue: self.phone)

                // go back to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Add User")
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }.padding()
    }
}

#Preview {
    AddUserView()
}
