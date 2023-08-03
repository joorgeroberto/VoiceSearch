//
//  Vehicle.swift
//  VoiceSearch
//
//  Created by Jorge de Carvalho on 15/05/23.
//

import Foundation

struct VehicleList: Codable {
    let vehicles: [Vehicle]

    enum CodingKeys: String, CodingKey {
        case vehicles = "modelos"
    }
}

struct Vehicle: Codable {
    let code: Int
    let name: String

    enum CodingKeys: String, CodingKey {
      case code = "codigo"
      case name = "nome"
    }
}
