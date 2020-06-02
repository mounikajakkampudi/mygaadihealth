//
//  ForgotPWView.swift
//  ModernMVVM
//
//  Created by Mounika Jakkampudi on 5/12/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import SwiftUI
struct ForgotPWView: View {
    @ObservedObject var viewModel: ForgotPWViewModel
     @Environment(\.presentationMode) var presentationMode
    @State var username: String = "maheshbabu.somineni@gmail.com"
  let appColor = Constants.appColor
   var body: some View {
    content
    }
     private var content: some View {
         switch viewModel.state {
         case .idle:
             return signupFieldsView().eraseToAnyView()
         case .loading:
             return Spinner(isAnimating: true, style: .large).eraseToAnyView()
         case .error(let error):
             return Text(error.localizedDescription).eraseToAnyView()
         case .loaded(let movies):
             return list(of: movies).eraseToAnyView()
         case .onLoginRequest(_):
             return LoadingView(isShowing: .constant(true)) {
                 self.signupFieldsView()
             }.eraseToAnyView()
         }
     }
    private func list(of movies: ForgotPWViewModel.SignUpDetails) -> some View {
        return Text(movies.message ?? "").eraseToAnyView()
    }
    func signupAction() {
        self.viewModel.send(event: .onLoginAction(username))
        }
private func signupFieldsView() -> some View {
    NavigationView {
        VStack(alignment: .center, spacing: 10.0) {
//            Spacer()
//                .frame(height: deviceWidth * 0.1)
            Image("logo")
            Text("MyGaadiHealth")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(appColor)
//            Text("Review & Earn").font(.subheadline).fontWeight(.regular).foregroundColor(appColor).lineLimit(nil)
            Spacer()
                .frame(height: Constants.deviceWidth * 0.07)
            TextField("UserName", text: $username)
           .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
              self.signupAction()
            }) {
                Text("Reset Password")
                    .foregroundColor(Color.white)
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
            }
            .frame(width: Constants.deviceWidth*0.81, height: 40.0)
            .background(appColor)
            .clipped()
            .cornerRadius(5.0)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
             Spacer()
        }
        .padding(.all)
    }
      .navigationBarTitle("")
      .navigationBarHidden(true)
}
}
