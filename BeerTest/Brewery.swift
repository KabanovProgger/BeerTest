// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let beerBrewer = try? JSONDecoder().decode(BeerBrewer.self, from: jsonData)

import Foundation

// MARK: - BeerBrewerElement
struct Brewery: Codable {
    let id, name, breweryType : String?
    let address1, address2, address3, city, stateProvince: String?
    let postalCode, country, longitude, latitude: String?
    let phone: String?
    let websiteURL: String?
    let state, street: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case breweryType = "brewery_type"
        case address1 = "address_1"
        case address2 = "address_2"
        case address3 = "address_3"
        case city
        case stateProvince = "state_province"
        case postalCode = "postal_code"
        case country, longitude, latitude, phone
        case websiteURL = "website_url"
        case state, street
    }

}

typealias Breweries = [Brewery]
