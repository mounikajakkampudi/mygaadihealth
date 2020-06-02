//
//  ContentView.swift
//  Zomsi
//
//  Created by Mounika Jakkampudi on 5/5/20.
//  Copyright © 2020 SPTCSAPPS. All rights reserved.
//

import SwiftUI
struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Spinner(isAnimating: true, style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State var username: String = "maheshbabu.somineni@gmail.com"
    @State var password: String = "1234"
    @State var isLoggedIn = false
    
    let appColor = Constants.appColor
     var body: some View {
        content
     }
    var disableForm: Bool {
        username.count < 1 || password.count < 1
    }
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return loginFieldsView().eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let movies):
            return list(of: movies).eraseToAnyView()
        case .onLoginRequest(_, _):
            return LoadingView(isShowing: .constant(true)) {
                self.loginFieldsView()
            }.eraseToAnyView()
        }
    }
    private func list(of movies: AuthViewModel.LoginDetails) -> some View {
        if (movies.token != nil) {
            return OriganizationsListView(viewModel: OriganizationsListViewModel()).eraseToAnyView()
        } else {
            return Text(movies.message ?? "").eraseToAnyView()
        }
       }
    func loginAction() {
        self.viewModel.send(event: .onLoginAction(username, password))
    }
    
    private func loginFieldsView() -> some View {
        NavigationView {
                      VStack(spacing: 10.0) {
//                          Spacer()
                          Image("logo")
                          Text("MyGaadiHealth")
                              .font(.headline)
                              .fontWeight(.semibold)
                              .foregroundColor(appColor)
//                          Text("Bid & Earn").font(.subheadline).fontWeight(.regular).foregroundColor(appColor).lineLimit(nil)
                          Spacer()
                            .frame(height: Constants.deviceWidth * 0.07)
                        Group {
                        TextField("UserName", text: $username)
                            .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Password", text: $password)
                            .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        NavigationLink(destination: ForgotPWView(viewModel: ForgotPWViewModel())){
                            Text("Forgot Password ?")
                        }
                        Spacer()
                        .frame(height: Constants.deviceWidth * 0.07)
                          Button(action: {
                              self.loginAction()
                          }){
                                  
                             HStack {
                                 Spacer()
                                Text("LOGIN")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.white)
                                .padding(.horizontal)
                                Spacer()
                             }
                          }
                          .disabled(disableForm)
                          .frame(width: Constants.deviceWidth * 0.8, height: 40.0)
                            .background(appColor.opacity(self.disableForm ? 0.7 : 1))
                          .clipped()
                          .cornerRadius(5.0)
                           HStack {
                              Text("Don't have an account?")
                              Button(action: {}) {
                                NavigationLink(destination: SignUpView(viewModel: SignupViewModel())){
                                      Text("Sign up now")
                                  }
                              }
                          }
                          Spacer()
                      }.padding(.all)
                  }
    }
}





//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(viewModel: AuthViewModel())
//    }
//}
