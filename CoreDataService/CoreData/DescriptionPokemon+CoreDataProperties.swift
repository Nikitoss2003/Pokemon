//
//  DescriptionPokemon+CoreDataProperties.swift
//  Pokemons
//
//  Created by НИКИТА ПЕСНЯК on 16.09.24.
//
//

import Foundation
import CoreData


extension DescriptionPokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DescriptionPokemon> {
        return NSFetchRequest<DescriptionPokemon>(entityName: "DescriptionPokemon")
    }

    @NSManaged public var height: Int16
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var types: String?
    @NSManaged public var weight: Int16
    @NSManaged public var imagePokemon: ImagePokemon?
    @NSManaged public var urlPokemon: UrlPokemon?

}

extension DescriptionPokemon : Identifiable {

}
