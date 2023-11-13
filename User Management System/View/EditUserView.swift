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
    @State var lastName: String  = ""
    @State var email: String     = ""
    @State var phone: String     = ""

    // helper variables
    @State private var isEmailValid: Bool = true
    @State private var isPhoneValid: Bool = true
    @State private var isUserExist: Bool  = false

    // for handling alerts
    @State private var showAlert   = false
    @State private var showMessage = ""
    @State private var showTitle   = ""

    func resetFields() {
        firstName = ""
        lastName  = ""
        email     = ""
        phone     = ""
    }

    // to go back to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            // User symbol on top
            Image(systemName: "person.badge.clock.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(40)
                .foregroundColor(Color.blue)

            // create name field
            TextField("Enter first name", text: $firstName)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(5)
                .disableAutocorrection(true)

            // create name field
            TextField("Enter last name", text: $lastName)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(5)
                .disableAutocorrection(true)

            // create email field with validation
            TextField("Enter email", text: $email)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: email) { _, newEmail in
                    isEmailValid = Utils().isValidEmail(email: newEmail)
                }
                .foregroundColor(isEmailValid ? .primary : .red) // Change text color based on validation

            // create phone field with validation
            TextField("Enter Phone", text: $phone)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
                .onChange(of: phone) { _, newPhone in
                    isPhoneValid = Utils().isValidPhone(phone: newPhone)
                }
                .foregroundColor(isPhoneValid ? .primary : .red)

            // alert message for invalid fields
            if (!email.isEmpty && !isEmailValid) || (!phone.isEmpty && !isPhoneValid) {
                Text("Please correct the fields")
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }

            // button to update a user
            Button(action: {
                // check if text fields have data
                if(self.firstName.isEmpty || self.lastName.isEmpty || self.email.isEmpty || self.phone.isEmpty){
                    self.showAlert   = true
                    self.showTitle   = "Error"
                    self.showMessage = "All Fields are Required"
                }else{
                    // Validate email
                    isUserExist = (Utils().isEmailExist(email: self.email)?.id != self.id && Utils().isEmailExist(email: self.email)?.id != nil)

                    if !isUserExist {
                        // call function to update row in sqlite database
                        DB_Manager().updateUser(idValue: self.id, firstNameValue: self.firstName, lastNameValue: self.lastName, emailValue: self.email, phoneValue: self.phone)

                        resetFields()

                        // go back to home page on success
                        self.mode.wrappedValue.dismiss()

                    } else {
                        self.showAlert   = true
                        self.showTitle   = "Error"
                        self.showMessage = "User with Email exist"
                    }
                }
                
            }, label: {
                Text("Update User")
                    .foregroundColor(Color(.systemBackground))
            })
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.blue)
            .cornerRadius(8)
            .padding()
        }.padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(showTitle),
                    message: Text(showMessage),
                    dismissButton: .default(Text("OK"), action: {
                        showAlert = false
                    })
                )
            }

            // populate user's data in fields when view loaded
            .onAppear(perform: {
                // get data from database
                let userModel: UserModel = DB_Manager().getUser(idValue: self.id)

                // populate in text fields
                self.firstName = userModel.firstName
                self.lastName  = userModel.lastName
                self.email     = userModel.email
                self.phone     = userModel.phone
            })
    }
}

struct EditUserView_Previews: PreviewProvider {
    @State static var id: Int = 0

    static var previews: some View {
        EditUserView(id: $id)
    }
}
