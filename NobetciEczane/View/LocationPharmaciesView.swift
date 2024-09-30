//
//  ContentView.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 25.09.2024.
//

import SwiftUI
import CoreLocation

struct LocationPharmaciesView: View {
    
    @ObservedObject var viewModel = LocationPharmaciesViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State private var showMapSelection = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.pharmacies) { pharmacy in
                    GroupBox {
                        VStack {
                            HStack {
                                Text(pharmacy.name)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .bold()
                                    .font(.title3)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }.padding(.vertical, 2)
                            HStack {
                                Image(systemName: "location.circle.fill")
                                /*Text(pharmacy.address)
                                    .frame(maxWidth: .infinity)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .padding(.vertical, 2)*/
                                
                                Button(pharmacy.address) {
                                    showMapSelection = true
                                    let coordinates = pharmacy.loc.components(separatedBy: ",")
                                    
                                    if coordinates.count == 2 {
                                        if let latitude = Double(coordinates[0]), let longitude = Double(coordinates[1]) {
                                            self.latitude = latitude
                                            self.longitude = longitude
                                        }
                                    }
                                }
                            }.padding(.vertical, 2)
                            HStack {
                                if pharmacy.phone.isEmpty {
                                    Text("No Phone Number")
                                } else {
                                    Button {
                                        if let url = URL(string: "tel://\(pharmacy.phone)"), UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    } label: {
                                        Image(systemName: "phone")
                                            .foregroundStyle(.black)
                                        Text(viewModel.formatPhoneNumber(pharmacy.phone))
                                    }
                                }
                            }.padding(.vertical, 2)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
                .navigationTitle("Nobetci Eczaneler")
                .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear {
            self.locationManager.startUpdatingLocation()
        }
        .onChange(of: locationManager.city) {
            if !locationManager.city.isEmpty {
                Task {
                    await viewModel.downloadPharmacies(il: self.locationManager.city, ilce: self.locationManager.district)
                }
            }
        }
        .confirmationDialog("Harita Secin", isPresented: $showMapSelection, titleVisibility: .visible) {
            Button("Apple Maps") {
                openAppleMaps()
            }
            Button("Google Maps") {
                openGoogleMaps()
            }
            Button("İptal", role: .cancel) {}
        }
    }
    
    func openAppleMaps() {
        let mapUrl = "http://maps.apple.com/?ll=\(latitude),\(longitude)"
        if let url = URL(string: mapUrl) {
            UIApplication.shared.open(url)
        }
    }
        
    func openGoogleMaps() {
        let mapUrl = "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)"
        if let url = URL(string: mapUrl) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    LocationPharmaciesView()
}
