//
//  Urls.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 25.09.2024.
//

import Foundation

struct Urls {
    static func doUrlWithDistrict(il: String, ilce: String) -> URLRequest? {
        let urlString = "https://api.collectapi.com/health/dutyPharmacy?ilce=\(ilce)&il=\(il)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("apikey ", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    static func doUrlGetDistricts(il: String) -> URLRequest? {
        let urlString = "https://turkiyeapi.dev/api/v1/provinces/\(il)"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        return request
    }
}
