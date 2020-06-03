//
//  HomeTabView.swift
//  ModernMVVM
//
//  Created by Mounika Jakkampudi on 6/2/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation
import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            OriganizationsListView(viewModel: OriganizationsListViewModel())
             .tabItem {
                Image(systemName: "text.badge.plus")
                Text("Requests")
              }

            AccountDetailView()
             .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
              }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
