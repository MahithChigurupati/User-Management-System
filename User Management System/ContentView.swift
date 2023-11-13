//
//  ContentView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchUserView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search")
                }

            AddUserView()
                .tabItem {
                    Image(systemName: "person.badge.plus")
                    Text("Add User")
                }

        }.accentColor(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
