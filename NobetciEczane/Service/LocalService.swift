//
//  LocalService.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 25.09.2024.
//

import Foundation

class LocalService {
    func downloadDatas(fileName: String) async throws -> PharmacyModel? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Path not found")
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        
        return try JSONDecoder().decode(PharmacyModel.self, from: data)
    }
}
