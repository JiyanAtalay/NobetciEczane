//
//  WebService.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 25.09.2024.
//

import Foundation

class WebService {
    func downloadDatas(url: URLRequest) async throws -> PharmacyModel? {
        do {
            let (data, response) = try await URLSession.shared.data(for: url)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                return try JSONDecoder().decode(PharmacyModel.self, from: data)
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func downloadDistricts(url: URLRequest) async throws -> CityModel? {
        do {
            let (data, response) = try await URLSession.shared.data(for: url)
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                return try JSONDecoder().decode(CityModel.self, from: data)
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
