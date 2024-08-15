//
//  BreweryEntity+CoreDataProperties.swift
//  BeerTest
//
//  Created by Owner on 8/13/24.
//
//

import Foundation
import CoreData


extension BreweryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BreweryEntity> {
        return NSFetchRequest<BreweryEntity>(entityName: "BreweryEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var breweryType: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var stateProvince: String?
    @NSManaged public var postalCode: String?
    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?
    @NSManaged public var phone: String?
    @NSManaged public var websiteURL: String?
    @NSManaged public var adress1: String?
    @NSManaged public var adress2: String?
    @NSManaged public var adress3: String?
    @NSManaged public var street: String?
    @NSManaged public var state: String?

}

extension BreweryEntity : Identifiable {

}
