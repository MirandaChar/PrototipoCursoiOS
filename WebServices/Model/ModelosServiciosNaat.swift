//
//  ModelosServiciosNaat.swift
//  WebServices
//
//  Created by Carlos on 09/11/21.
//

import Foundation

//Creamos una estructura que representa nuestro JSON de respuesta
struct QuoteData: Decodable {
    var type: String
    var joke: String?
    var setup: String?
    var delivery: String?
}

struct NewActivity: Codable {
    var key: String
    var name: String
    var description: String
}


