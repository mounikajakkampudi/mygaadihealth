//
//  UploadReview.swift
//  ModernMVVM
//
//  Created by Mounika Jakkampudi on 5/22/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import SwiftUI
struct UploadReview: View {
    @ObservedObject var viewModel: AddReviewModel
     @Environment(\.presentationMode) var presentationMode
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    @State var message: String = ""
    @State var review_source: String = ""
    @State var source_url: String = ""
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
         case .onAddReviewRequest(_):
             return LoadingView(isShowing: .constant(true)) {
                 self.signupFieldsView()
             }.eraseToAnyView()
         }
     }
    private func list(of movies: AddReviewModel.SignUpDetails) -> some View {
         return Text(movies.message ?? "").eraseToAnyView()
    }
    func signupAction() {
        self.viewModel.send(event: .onAddReviewRequestAction(["message": message, "review_source": review_source, "source_url": source_url]))
        }
private func signupFieldsView() -> some View {
    ScrollView {
        VStack(spacing: 10.0) {
            Image("logo")
            Text("MyGaadiHealth")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(appColor)
            TextField("Title", text: $message)
            .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Description", text: $review_source)
           .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          TextField("Vehicle Model", text: $source_url)
          .padding(.horizontal)
          .textFieldStyle(RoundedBorderTextFieldStyle())
            if image != nil {
                           Image(uiImage: image!)
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                       }
            Button(action: {
              self.showImagePicker.toggle()
            }) {
                Text("Upload Image")
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
            }
            .frame(width: Constants.deviceWidth * 0.8, height: 40.0)
            .background(Color.gray)
            .clipped()
            .cornerRadius(5.0)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                       
                   }
                   .sheet(isPresented: $showImagePicker) {
                       ImagePickerView(sourceType: .photoLibrary) { image in
                           self.image = image
                       }
                   }
            Button(action: {
              self.signupAction()
            }) {
                Text("Add Request")
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
            }
            .frame(width: Constants.deviceWidth * 0.8, height: 40.0)
            .background(appColor)
            .clipped()
            .cornerRadius(5.0)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(.all)
    }
      
}
//const review = {
//    message: req.body.message,
//    rating: parseFloat(req.body.rating) || 0,
//    review_source: req.body.review_source || 'website',
//    user_id: req.body.user_id,
//    organization_id:req.body.organization_id,
//    deal_id:req.body.deal_id,
//    service_id:req.body.service_id,
//    source_url:req.body.source_url || ''
//}
