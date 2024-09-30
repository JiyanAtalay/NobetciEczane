//
//  SelectedLocationPharmaciesViewModel.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 30.09.2024.
//

import Foundation

class SelectedLocationPharmaciesViewModel: ObservableObject {
    @Published var pharmacies = [Result]()
    
    @Published var cities: [TurkishCity] = TurkishCity.allCases
    @Published var selectedCity: TurkishCity? = nil {
        didSet {
            Task {
                if let city = selectedCity {
                    await downloadDistricts(il: city.plateNumber)
                } else {
                    self.districts.removeAll(keepingCapacity: false)
                }
            }
        }
    }
    
    @Published var districts: [DistrictModel] = []
    @Published var selectedDistrict: DistrictModel? = nil {
        didSet {
            if let city = selectedCity, let district = selectedDistrict {
                Task {
                    await downloadPharmacies(il: city.rawValue, ilce: district.name)
                }
            }
        }
    }
    
    let service = WebService()
    
    func downloadDistricts(il: String) async {
        do {
            if let urlRequest = Urls.doUrlGetDistricts(il: il) {
                let data = try await service.downloadDistricts(url: urlRequest)
                
                if let data {
                    DispatchQueue.main.async {
                        self.districts = data.districts
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func downloadPharmacies(il: String, ilce: String) async {
        do {
            if let urlRequest = Urls.doUrlWithDistrict(il: il, ilce: ilce) {
                let data = try await service.downloadDatas(url: urlRequest)
                //let data = try await service.downloadDatas(fileName: "LocalDatas")
                
                if let data {
                    if data.success {
                        DispatchQueue.main.async {
                            self.pharmacies = data.result
                        }
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        
        guard phoneNumber.count == 10 else {
            return phoneNumber
        }
        
        let alanKodu = String(phoneNumber.prefix(3))
        let ortaKisim = String(phoneNumber.dropFirst(3).prefix(3))
        let sonKisimIlk = String(phoneNumber.dropFirst(6).prefix(2))
        let sonKisimSon = String(phoneNumber.dropFirst(8))
        
        return "(0\(alanKodu)) \(ortaKisim) \(sonKisimIlk) \(sonKisimSon)"
    }
}
