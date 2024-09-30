//
//  ContentViewModel.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 25.09.2024.
//

import Foundation

class LocationPharmaciesViewModel : ObservableObject {
    @Published var pharmacies = [Result]()
    
    let service = WebService()
    //let service = LocalService()
    
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
