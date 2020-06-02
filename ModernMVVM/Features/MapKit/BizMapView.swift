//
//  BizMapView.swift
//  Zomsi
//
//  Created by Mounika Jakkampudi on 5/5/20.
//  Copyright © 2020 SPTCSAPPS. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Landmark: Equatable {
    static func ==(lhs: Landmark, rhs: Landmark) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID().uuidString
    let name: String
    let location: CLLocationCoordinate2D
}

struct BizMapView: View {
    @State var landmarks = [Landmark]()
    @State var selectedLandmark: Landmark? = nil
    @State var movies = [OriganizationsListViewModel.ListItem]()

    var body: some View {
        ZStack {
            MapView(landmarks: $landmarks,
                    selectedLandmark: $selectedLandmark)
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                Spacer()
                Button(action: {
                    self.selectNextLandmark()
                }) {
                    Text("Next")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .padding(.bottom)
                }
            }
        }
    }
    
    private func selectNextLandmark() {
        if let selectedLandmark = selectedLandmark, let currentIndex = landmarks.firstIndex(where: { $0 == selectedLandmark }), currentIndex + 1 < landmarks.endIndex {
            self.selectedLandmark = landmarks[currentIndex + 1]
        } else {
            selectedLandmark = landmarks.first
        }
    }
}

//#if DEBUG
//struct BizMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        BizMapView(landmarks: landmarks)
//    }
//}
//#endif
