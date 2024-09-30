//
//  CityModel.swift
//  NobetciEczane
//
//  Created by Mehmet Jiyan Atalay on 30.09.2024.
//

import Foundation

struct CityModel: Codable {
    let districts: [DistrictModel]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        self.districts = try dataContainer.decode([DistrictModel].self, forKey: .districts)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var dataContainer = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        try dataContainer.encode(districts, forKey: .districts)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }

    private enum DataKeys: String, CodingKey {
        case districts
    }
}

struct DistrictModel: Codable, Hashable {
    let id: Int
    let name: String
    let population: Int
    let area: Int
}
