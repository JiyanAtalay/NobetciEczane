//
//  MainView.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 1.10.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            LocationPharmaciesView()
                .tabItem {
                    Label("Nobetci Eczaneler", systemImage: "mappin.and.ellipse")
                }
            SelectedLocationPharmaciesView()
                .tabItem {
                    Label("Nobetci Eczane Ara", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    MainView()
}
