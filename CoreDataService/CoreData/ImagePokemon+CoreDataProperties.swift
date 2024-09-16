//
//  ImagePokemon+CoreDataProperties.swift
//  Pokemons
//
//  Created by НИКИТА ПЕСНЯК on 16.09.24.
//
//

import Foundation
import CoreData


extension ImagePokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagePokemon> {
        return NSFetchRequest<ImagePokemon>(entityName: "ImagePokemon")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var descriptionPokemon: DescriptionPokemon?

}

extension ImagePokemon : Identifiable {

}
