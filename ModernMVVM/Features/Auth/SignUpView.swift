//
//  SignUpView.swift
//  Zomsi
//
//  Created by Mounika Jakkampudi on 5/5/20.
//  Copyright © 2020 SPTCSAPPS. All rights reserved.
//

import Foundation
import SwiftUI
struct SignUpView: View {
    @ObservedObject var viewModel: SignupViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var username: String = "maheshbabu.somineni@gmail.com"
    @State var password: String = "1234"
    @State var passwordCfm: String = "1234"
    @State var mobile: String = ""
    @State var landmarks: [Landmark] = [Landmark]()
    @State var showsAlert = true
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
            return showErrorMessage(errorMsg: error.localizedDescription).eraseToAnyView()
         case .loaded(let movies):
             return list(of: movies).eraseToAnyView()
         case .onLoginRequest(_, _):
             return LoadingView(isShowing: .constant(true)) {
                 self.signupFieldsView()
             }.eraseToAnyView()
         }
     }
    private func showErrorMessage(errorMsg: String) -> some View {
        return self.signupFieldsView().alert(isPresented: self.$showsAlert) {
           Alert(title: Text(errorMsg))
        }
    }
    private func list(of movies: SignupViewModel.SignUpDetails) -> some View {
        if (movies.success ?? false) {
            self.presentationMode.wrappedValue.dismiss()
            return showErrorMessage(errorMsg: "Registration Successful").eraseToAnyView()
     } else {
            return showErrorMessage(errorMsg: movies.message ?? "error").eraseToAnyView()
     }
    }
    func signupAction() {
        self.showsAlert = true
        self.viewModel.send(event: .onLoginAction(username, password))
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
            TextField("Mobile", text: $mobile)
            .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
           .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          SecureField("Confirm Password", text: $passwordCfm)
          .padding(.horizontal)
          .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
              self.signupAction()
            }) {
                Text("Register")
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
            }
            .frame(width: Constants.deviceWidth * 0.8, height: 40.0)
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
