//
//  EditUserView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/12/23.
//

import SwiftUI

struct EditUserView: View {
    // id receiving of user from previous view
    @Binding var id: Int

    // variables to store value from input fields
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var phone: String = ""

    // to go back to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            // create name field
            TextField("Enter first name", text: $firstName)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)

            // create name field
            TextField("Enter last name", text: $lastName)
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
            TextField("Enter phone", text: $phone)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)

            // button to update user
            Button(action: {
                // call function to update row in sqlite database
                DB_Manager().updateUser(idValue: self.id, firstNameValue: self.firstName, lastNameValue: self.lastName, emailValue: self.email, phoneValue: self.phone)

                // go back to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Edit User")
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }.padding()

            // populate user's data in fields when view loaded
            .onAppear(perform: {
                // get data from database
                let userModel: UserModel = DB_Manager().getUser(idValue: self.id)

                // populate in text fields
                self.firstName = userModel.firstName
                self.lastName = userModel.lastName
                self.email = userModel.email
                self.phone = userModel.phone
            })
    }
}

struct EditUserView_Previews: PreviewProvider {
    // when using @Binding, do this in preview provider
    @State static var id: Int = 0

    static var previews: some View {
        EditUserView(id: $id)
    }
}
