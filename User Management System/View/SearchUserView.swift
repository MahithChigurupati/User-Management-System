//
//  SearchUserView.swift
//  User Management System
//
//  Created by Mahith ‎ on 11/13/23.
//

import SwiftUI

struct SearchUserView: View {
    // initializing userModels
    @State var userModels: [UserModel] = []

    // search term field to store text entered by user in search bar
    @State var searchTerm = ""

    // for handling update/delete operation
    @State var userSelected: Bool = false
    @State var selectedUserId: Int = 0
    @State private var userToDelete: UserModel?
    @State var showModal = false // for update

    // for handling alert messages
    @State private var showingAlert = false

    // filtering users based on search term
    var filteredUsers: [UserModel] {
        guard !searchTerm.isEmpty else {
            return userModels.sorted { $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending }
        }
        return userModels.filter { $0.firstName.localizedCaseInsensitiveContains(searchTerm) || $0.lastName.localizedCaseInsensitiveContains(searchTerm) }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // Users image to view on top
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 40)
                        .padding(20)
                        .foregroundColor(Color.blue)
                }

                // to list the users view (retrieving users)
                NavigationStack {
                    List(self.filteredUsers) { model in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .foregroundColor(Color.blue)

                            Spacer()
                            Text(model.firstName)
                            Spacer()
                            Text(model.lastName)
                            Spacer()

                            // edit button to handle edit operation
                            Button(action: {
                                self.selectedUserId = model.id
                                self.userSelected = true
                                self.showModal = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(Color.blue)
                            }
                            .buttonStyle(PlainButtonStyle())

                            // delete button to delete user
                            Button(action: {
                                userToDelete = model
                                showingAlert = true
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(Color.red)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .searchable(text: $searchTerm, prompt: "Search Users") // search bar to type searchTerm to filter
            }
            .onAppear(perform: { // get all the users on screen load
                self.userModels = DB_Manager().getUsers()
            })
            .alert(isPresented: $showingAlert) { // Delete User confirmation alert
                Alert(
                    title: Text("Delete User"),
                    message: Text("Are you sure you want to delete this user?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let userToDelete = userToDelete {
                            let dbManager: DB_Manager = DB_Manager()
                            dbManager.deleteUser(idValue: userToDelete.id)
                            self.userModels = dbManager.getUsers()
                        }
                    },
                    secondaryButton: .cancel()
                )
            } // handling modal view for update operation
            .sheet(isPresented: $showModal, onDismiss: {
                self.userModels = DB_Manager().getUsers()
            }) {
                NavigationView {
                    EditUserView(id: $selectedUserId)
                        .navigationBarItems(trailing: Button("Close") { // close button in modal for older iPhones
                            self.showModal = false
                        })
                }
            }
        }
    }
}

#Preview {
    SearchUserView()
}
