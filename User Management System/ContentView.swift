//
//  ContentView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import SwiftUI

struct ContentView: View {
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
         
                // list view goes here
         
            }.padding()
            .navigationBarTitle("User Management")
        }
    }
}

#Preview {
    ContentView()
}
