//
//  SelectedLocationPharmaciesView.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 30.09.2024.
//

import SwiftUI

struct SelectedLocationPharmaciesView: View {
    
    @StateObject var viewmodel = SelectedLocationPharmaciesViewModel()
    
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State private var showMapSelection = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Picker("İl Seçin", selection: $viewmodel.selectedCity) {
                        ForEach(viewmodel.cities, id: \.self) { city in
                            Text(city.rawValue).tag(city as TurkishCity?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("İlçe Seçin", selection: $viewmodel.selectedDistrict) {
                        if viewmodel.districts.isEmpty {
                            Text("Ilce Seciniz")
                        } else {
                            ForEach(viewmodel.districts, id: \.self) { district in
                                Text(district.name).tag(district as DistrictModel?)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }.frame(height: 150)
                    .padding(.bottom)
                
                if !viewmodel.pharmacies.isEmpty {
                    ScrollView {
                        ForEach(viewmodel.pharmacies) { pharmacy in
                            GroupBox {
                                VStack {
                                    HStack {
                                        Text(pharmacy.name)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .bold()
                                            .font(.title3)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
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
                                    }
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
                                                    .foregroundStyle(.blue)
                                                Text(viewmodel.formatPhoneNumber(pharmacy.phone))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SelectedLocationPharmaciesView()
}
