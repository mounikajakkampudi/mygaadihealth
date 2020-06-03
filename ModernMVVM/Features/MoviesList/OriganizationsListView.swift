//
//  MoviesListView.swift
//  ModernMVVM
//
//  Created by Vadym Bulavin on 2/20/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Combine
import SwiftUI

struct OriganizationsListView: View {
    @ObservedObject var viewModel: OriganizationsListViewModel
    @State var toggle: Bool = true

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Recent Requests")
            .navigationBarItems(trailing: toggleButton)
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
    }
    private var toggleButton: some View {
           Button(action: {
               self.toggle.toggle()
               self.viewModel.send(event: .loadMovies)
           }) {Text(toggle ? "Map" : "List")}
       }
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let movies):
        var landmarks = [Landmark]()
       for movie in movies {
           landmarks.append(Landmark(name: movie.name, location: .init(latitude: -33.852222, longitude: 151.210556)))
       }
       return toggle ? list(of: movies).eraseToAnyView() : BizMapView(landmarks: landmarks).eraseToAnyView()
        }
    }
    private func list(of movies: [OriganizationsListViewModel.ListItem]) -> some View {
//        var moviesArr = [OriganizationsListViewModel.ListItem]()
//        moviesArr.append(OriganizationsListViewModel.ListItem(object: OrganizationDTO(id: "1", name: "Car breakdown", industry: "Sudden loss of ability to function efficiently", address: "1678 Monroe Street", thumb_url: "n/a", reviews: [ReviewsDTO]())))
//        moviesArr.append(OriganizationsListViewModel.ListItem(object: OrganizationDTO(id: "2", name: "Battery Replacement", industry: "A slow starting engine", address: "2345 Augustine drive", thumb_url: "n/a", reviews: [ReviewsDTO]())))
          return  ZStack {
                 List(movies) { movie in
                           NavigationLink(
                               destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id), isUser: false),
                               label: { MovieListItemView(movie: movie) }
                           )
                       }.environment(\.defaultMinListRowHeight, 60)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                       floatingButton()
                    }
                }
            }
        
    }
    
    private func floatingButton()  -> some View{
        Button(action: {
           // self.items.append(Item(value: "Item"))
        }, label: {
            NavigationLink(destination: UploadReview(viewModel: AddReviewModel())){
            Text("+")
                .font(.system(.largeTitle))
                .frame(width: 50, height: 44)
                .foregroundColor(Color.white)
                .padding(.bottom, 7)
            }
        })
            .background(Constants.appColor)
        .cornerRadius(38.5)
        .padding()
        .shadow(color: Color.black.opacity(0.3),
                radius: 3,
                x: 3,
                y: 3)
    }
}

struct MovieListItemView: View {
    let movie: OriganizationsListViewModel.ListItem
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        HStack(alignment: .top){
                poster.frame(height: 60)
                VStack{
                    title
                    industry
                    address
                }
            }.frame(height: 60)
    }
    
    private var title: some View {
        Text(movie.name)
            .font(.headline)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }
    private var industry: some View {
           Text(movie.industry)
            .font(.subheadline)
               .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
       }
    private var address: some View {
           Text(movie.address)
            .font(.footnote)
               .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
       }
    
    private var poster: some View {
        movie.thumbUrl.map { url in
            AsyncImage(
                url: url,
                cache: cache,
                placeholder: spinner,
                configuration: { $0.resizable().renderingMode(.original) }
            )
        }
        .aspectRatio(contentMode: .fit)
        .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3) // 2:3 aspect ratio
    }
    
    private var spinner: some View {
       // Spinner(isAnimating: true, style: .medium)
        Image("biz_placeholder")
    }
}

//struct OriganizationsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        OriganizationsListView(viewModel: OriganizationsListViewModel(), toggle: true, movies: [OriganizationsListViewModel.ListItem]())
//    }
//}
