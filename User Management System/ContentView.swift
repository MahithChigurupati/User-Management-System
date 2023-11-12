//
//  ContentView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import SwiftUI

struct ContentView: View {
    
    // array of user models
    @State var userModels: [UserModel] = []
    
    var body: some View {
        // create navigation view
        NavigationView {
         
            VStack {
         
                // create link to add user
                HStack {
                    Spacer()
                    NavigationLink (destination: AddUserView(), label: {
                        Text("Add user")
                    })
                }
         
                // create list view to show all users
                List (self.userModels) { (model) in
                 
                    // show name, email and age horizontally
                    HStack {
                        Text(model.firstName)
                        Spacer()
                        Text(model.lastName)
                        Spacer()
                        Text(model.email)
                        Spacer()
                        Text(model.phone)
                        Spacer()
                 
                        // edit and delete button goes here
                    }
                }
         
            }.padding()
            .onAppear(perform: {
                self.userModels = DB_Manager().getUsers()
            })
        }
    }
}

#Preview {
    ContentView()
}
