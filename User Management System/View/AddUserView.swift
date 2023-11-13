//
//  AddUserView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import SwiftUI

struct AddUserView: View {
    // create variables to store user input values
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isEmailValid: Bool = true
    @State private var isPhoneValid: Bool = true
    @State private var isUserExist: Bool = false
    @State private var showAlert = false
    @State private var showMessage = ""
    @State private var showTitle = ""
    

    // to go back on the home screen when the user is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private func isEmailExist (email: String) -> Bool {
        let user: UserModel = DB_Manager().getUser(from: email)
        return type(of: user) == UserModel.self
    }

    // Email validation using regular expression
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    // Phone number validation using regular expression
    private func isValidPhone(phone: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }

    var body: some View {
        
        VStack {
            
            // User symbol on top
            Image(systemName: "person.fill.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(40)
                .foregroundColor(Color.blue)

            // create first name field
            TextField("Enter First Name", text: $firstName)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)

            // create last name field
            TextField("Enter Last Name", text: $lastName)
                .padding(10)
                .background(Color(.systemGray6))
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
                    isEmailValid = isValidEmail(email: newEmail)
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
                    isPhoneValid = isValidPhone(phone: newPhone)
                }
                .foregroundColor(isPhoneValid ? .primary : .red) 
            
            
            // Text message for invalid fields
            if (!email.isEmpty && !isEmailValid) || (!phone.isEmpty && !isPhoneValid) {
                Text("Please correct the fields")
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }
            

            // button to add a user
            Button(action: {
                // Validate email and phone
                isUserExist = isEmailExist(email: self.email)
                
                if !isUserExist {
                    // call function to add row in sqlite database
                    DB_Manager().addUser(firstNameValue: self.firstName,
                                         lastNameValue: self.lastName,
                                         emailValue: self.email,
                                         phoneValue: self.phone)

                    // Reset text fields
                    self.firstName = ""
                    self.lastName = ""
                    self.email = ""
                    self.phone = ""

                    self.showAlert = true
                    self.showTitle = "User Created"
                    self.showMessage = "The user has been successfully created."

                }else{
                    self.showAlert = true
                    self.showTitle = "Error"
                    self.showMessage = "User with Email exist"
                    
                }
            }, label: {
                Text("Add User")
                    .foregroundColor(Color(.systemBackground))
            })
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.blue)
            .cornerRadius(8)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(showTitle),
                    message: Text(showMessage),
                    dismissButton: .default(Text("OK"))
                )
                
            }
        }
        .padding()
        .onAppear {
                    // Reset text fields when the view appears
                    self.firstName = ""
                    self.lastName = ""
                    self.email = ""
                    self.phone = ""
                }
    }
}

#Preview {
    AddUserView()
}
