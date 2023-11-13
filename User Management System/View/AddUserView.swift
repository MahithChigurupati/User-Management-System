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
    
    // helper variables
    @State private var isEmailValid: Bool = true
    @State private var isPhoneValid: Bool = true
    @State private var isUserExist: Bool = false
    
    // for handling alerts
    @State private var showAlert = false
    @State private var showMessage = ""
    @State private var showTitle = ""
    
    func resetFields(){
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phone = ""
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
            

            // button to add a user
            Button(action: {
                // check if text fields have data
                if(self.firstName == "" || self.lastName == "" || self.email == "" || self.phone == ""){
                    self.showAlert   = true
                    self.showTitle   = "Error"
                    self.showMessage = "All Fields are Required"
                }
                else{
                    // Validate email and phone
                    isUserExist = (Utils().isEmailExist(email: self.email) != nil)
                    
                    if !isUserExist {
                        // call function to add row in sqlite database
                        DB_Manager().addUser(firstNameValue: self.firstName,
                                             lastNameValue: self.lastName,
                                             emailValue: self.email,
                                             phoneValue: self.phone)
                            
                        resetFields()

                        self.showAlert   = true
                        self.showTitle   = "Success"
                        self.showMessage = "User successfully created."

                    }else{
                        self.showAlert   = true
                        self.showTitle   = "Error"
                        self.showMessage = "User with Email exist"
                        
                    }
                    
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
                    dismissButton: .default(Text("OK"), action: {
                        showAlert = false
                    })
                )
                
            }
        }
        .padding()
        .onAppear { resetFields() }
    }
}

#Preview {
    AddUserView()
}
