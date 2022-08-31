//
//  RequestPermissions.swift
//  Black_Kiwi
//
//  Created by Alessandro Benetton on 31/08/22.
//

import SwiftUI
import PermissionsSwiftUILocation

struct RequestPermissions: View {
       @State var showModal = true
       var body: some View {
           Button(action: {
               showModal=true
           }, label: {
               Text("Ask user for permissions")
           })
           .JMAlert(showModal: $showModal, for: [.location], autoDismiss: true)
           .setPermissionComponent(for: .location, description: "Allow access to user location while using the app.")
       }
   }

struct RequestPermissions_Previews: PreviewProvider {
    static var previews: some View {
        RequestPermissions()
    }
}
