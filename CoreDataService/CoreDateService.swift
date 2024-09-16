import Foundation
import UIKit
import CoreData

class CoreDataService{
    static var shared = CoreDataService()
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pokemons")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func saveUrlPokemon(with urls: [UrlPokemonStruct]) {
        context.perform { [weak self] in
            guard let self = self else { return }
            let existingNames = self.fetchUrl()
            if !existingNames.isEmpty {
                let fetchRequest: NSFetchRequest<UrlPokemon> = UrlPokemon.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name IN %@", existingNames)
                
                do {
                    let existingPokemons = try self.context.fetch(fetchRequest)
                    for existingPokemon in existingPokemons {
                        if let urlStruct = urls.first(where: { $0.name == existingPokemon.name }) {
                            existingPokemon.url = urlStruct.url
                        }
                    }
                    self.saveContext()
                    print("Объекты обновлены в UrlPokemon")
                } catch let error as NSError {
                    print("Ошибка при обновлении объектов \(error), \(error.userInfo)")
                }
            }
        }
    }


    
    func fetchUrl() -> [String] {
        let fetchUrlPokemons: NSFetchRequest<UrlPokemon> = UrlPokemon.fetchRequest()
        
        
        do {
            let urlPokemon = try context.fetch(fetchUrlPokemons)
            let pokemonUrl = urlPokemon.compactMap{$0.name }
            return pokemonUrl
        } catch {
            print("Failed to fetch  names: \(error)")
            return []
        }
    }
    
    
    func saveDescriptionPokemon(with description: DecriptionPokemonResponse) {
        context.perform { [weak self] in
            guard let self = self else { return }
            let existingDescriptions = self.fetchDescription(name: description.name)
            
            if let existingDescription = existingDescriptions.first {
                existingDescription.id = Int16(description.id)
                let typesNames = description.types.map { $0.type.name }.joined(separator: ", ")
                existingDescription.types = typesNames
                existingDescription.weight = description.weight
                existingDescription.height = description.height
            } else {
                let newDescription = DescriptionPokemon(context: self.context)
                newDescription.name = description.name
                newDescription.id = Int16(description.id)
                let typesNames = description.types.map { $0.type.name }.joined(separator: ", ")
                newDescription.types = typesNames
                newDescription.weight = description.weight
                newDescription.height = description.height
            }
            self.saveContext()
        }
    }

    func fetchDescription(name: String) -> [DescriptionPokemon] {
        let fetchRequest: NSFetchRequest<DescriptionPokemon> = DescriptionPokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        

        
        do {
            let descriptions = try context.fetch(fetchRequest)
            return descriptions
        } catch {
            print("Failed to fetch descriptions: \(error)")
            return []
        }
    }

    
    func saveImagePokemon(with imageData: Data, name: String) {
        context.perform { [weak self] in
            guard let self = self else { return }
            let existingImages = self.fetchImageResult(name: name)
            
            if let existingImage = existingImages.first {
                existingImage.image = imageData
            } else {
                let newImage = ImagePokemon(context: self.context)
                newImage.name = name
                newImage.image = imageData
            }
            self.saveContext()
        }
    }

 private   func fetchImageResult(name: String) -> [ImagePokemon] {
        let fetchRequest: NSFetchRequest<ImagePokemon> = ImagePokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch image: \(error)")
            return []
        }
    }


    func fetchImage(name: String) -> Data? {
        let fetchImage: NSFetchRequest<ImagePokemon> = ImagePokemon.fetchRequest()
        fetchImage.predicate = NSPredicate(format: "name == %@", name)
        
        
        do {
            let images = try context.fetch(fetchImage)
            if let imagePokemon = images.first {
                return imagePokemon.image
            }
        } catch {
            print("Failed to fetch image: \(error)")
        }
        return nil
    }
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}



