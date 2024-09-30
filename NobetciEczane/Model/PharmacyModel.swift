//
//  PharmcyModel.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 25.09.2024.
//

import Foundation

struct PharmacyModel: Codable {
    let success: Bool
    let result: [Result]
}

struct Result: Codable, Identifiable {
    var id = UUID()
    let name, dist, address, phone: String
    let loc: String
    
    enum CodingKeys: String, CodingKey {
        case name, dist, address, phone, loc
    }
}
