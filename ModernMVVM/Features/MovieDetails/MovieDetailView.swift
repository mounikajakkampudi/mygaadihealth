//
//  MovieDetailView.swift
//  ModernMVVMList
//
//  Created by Vadim Bulavin on 3/18/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI
import Combine
struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Environment(\.imageCache) var cache: ImageCache
    @State var toggle: Bool = true
    @State var isUser: Bool = true
    @State var replyText: String = ""

    let appColor = Constants.appColor
    var body: some View {
        content
            .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return spinner.eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let movie):
            return self.isUser ? self.loadDetailView(movie).eraseToAnyView() : self.movie(movie).eraseToAnyView()
        }
    }
    
    private func movie(_ movie: MovieDetailViewModel.MovieDetail) -> some View {
        ScrollView {
            VStack {
//                Text(movie.name)
                Text("Car breakdown")
                    .font(.title)
                    .multilineTextAlignment(.center)
//                HStack {
//                    Text(movie.industry)
//                    Text(movie.address)
//                    Text(movie.name)
//                }
                   
                poster(of: movie)
                Text("Perhaps the most common cause of a breakdown is either a faulty or a flat battery.")
                    .font(.body).padding(.vertical)
                Spacer()
                
                HStack {
                    Text("Service Bids:").font(.headline)
                    .foregroundColor(Constants.appColor)

                    Spacer()
                }
                genres(of: movie)
                genres2(of: movie)
                
            } .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
        }
        .padding(.bottom)
    }
    private func loadDetailView(_ movie: MovieDetailViewModel.MovieDetail) -> some View {
            ScrollView {
                VStack {
                    Text("Car breakdown")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    poster(of: movie)
                    Text("Perhaps the most common cause of a breakdown is either a faulty or a flat battery.")
                        .font(.body).padding(.vertical)
                    Spacer()
                    MultilineTextView(text: $replyText).frame(width: Constants.deviceWidth - 20, height: 100, alignment: .center)
                    HStack{
                                   Spacer()
                    Button(action: {
//                                 self.signupAction()
                               }) {
                                   Text("Send Bid")
                                       .foregroundColor(Color.white)
                                       .fontWeight(.medium)
                                   .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
                               }
                               .frame(width: 100, height: 40.0)
                               .background(appColor)
                               .clipped()
                               .cornerRadius(5.0)
                               .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                    }
                   
                } .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            }
            .padding(.bottom)
        }
        
    private func poster(of movie: MovieDetailViewModel.MovieDetail) -> some View {
        movie.thumbUrl.map { url in
            AsyncImage(
                url: url,
                cache: cache,
                placeholder: Image("org1"),
                configuration: { $0.resizable() }
            )
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private var spinner: Spinner { Spinner(isAnimating: true, style: .large) }
    
    private func genres(of movie: MovieDetailViewModel.MovieDetail) -> some View {
        VStack {
            ForEach(movie.reviews, id: \.self) { genre in
                VStack {
                HStack {
                VStack(alignment: .leading) {
//                    Text("username456: $ \(String(genre.rating))").font(.body).multilineTextAlignment(.leading)
//                    Text(genre.message)
//                        .multilineTextAlignment(.leading)
                    Text("username456: $ 50").font(.headline).multilineTextAlignment(.leading)
                    Text("We provide best service in market.")
                        .lineLimit(nil)

//                   Text("username456: $ 70").font(.body).multilineTextAlignment(.leading)
//                    Text("Customer satisfaction is assured.").multilineTextAlignment(.leading)
//                    Text("username456: $ 60").font(.body).multilineTextAlignment(.leading)
//                    Text("Can negotiate upto 10%. Reliable service.").multilineTextAlignment(.leading)
                }
                    Spacer()
              Button(action: {
                self.toggle.toggle()

              }) {

                Text(self.toggle ? "Accepted" : "Accept")
                                        .fontWeight(.medium)
                                            .foregroundColor(Constants.appColor)
                                                .padding(.all)
                                         }
                                     }
                    Divider()
                }
                .padding(.horizontal)

            }
        }
    }
    private func genres2(of movie: MovieDetailViewModel.MovieDetail) -> some View {
            VStack {
                ForEach(movie.reviews, id: \.self) { genre in
                    VStack {
                    HStack {
                    VStack(alignment: .leading) {
    
                       Text("username456: $ 70").font(.headline).multilineTextAlignment(.leading)
                        Text("Customer satisfaction is assured.").multilineTextAlignment(.leading)
    .lineLimit(nil)

                    }
                        Spacer()
                  Button(action: {
                    self.toggle.toggle()

                  }) {

                    Text(self.toggle ? "Accept" : "Accepted")
                                            .fontWeight(.medium)
                                                .foregroundColor(Constants.appColor)
                                                    .padding(.all)
                                             }
                                         }
                        Divider()
                    }
                    .padding(.horizontal)

                }
            }
        }
    
    private func openReviewURL() {
        guard let url = URL(string: "https://rb.gy/eznxeo") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
