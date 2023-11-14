# User Management App

This iOS mobile application is designed to manage user profiles, providing an intuitive interface for administrators to create, edit, and delete user profiles efficiently.

## Features

- **User Profile Creation:**
  - Admins can create user profiles by entering information such as First Name, Last Name, Email, Phone Number.
- **User Profile Management:**
  - Admins can view a list of all users in the system.
  - Admins can also search to find the users.
  - Edit user profiles if necessary.
  - Delete user profiles.

## Requirements

### Functional Requirements

- **User Profile Creation:**
  - Admin can input user details during profile creation.
- **User Profile Management:**
  - Admin can view a list of all users.
  - Admin can edit user profiles.
  - Admin can delete user profiles.

### Error Handling

- Properly addressed all edge cases and failure scenarios.

### Technical Stack

- DB: SQlite
- UI: SwiftUI

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/MahithChigurupati/User-Management-System.git
   ```

2. Open the project in Xcode. **Make sure you open "User Management System" with the `.xcworkspace` extension.**
3. Run the Project in Xcode

- Homepage shows the search bar and list of all users to search from (If you don't see any users, make sure to add few users)
- you can only edit/ delete once you have users added.
- you can add users from `Add User` tab
- from the list of users, you can click on `pencil` icon to edit and `trash` icon to delete the item.
- All the error scenarios are handled.

## Sample UI

<img src="Simulator Screenshot - iPhone 15 Pro - 2023-11-13 at 19.25.34.png" alt="Simulator Screenshot" width="300" height="600">
<img src="Simulator Screenshot - iPhone 15 Pro - 2023-11-13 at 19.25.44.png" alt="Simulator Screenshot" width="300" height="600">
<br></br>
<img src="Simulator Screenshot - iPhone 15 Pro - 2023-11-13 at 19.25.55.png" alt="Simulator Screenshot" width="300" height="600">
