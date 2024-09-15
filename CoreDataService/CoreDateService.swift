import Foundation
import CoreData

class CoreDataService{
    static var shared = CoreDataService()
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pokemon")
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
            for url in urls {
                let newUrl = UrlPokemon(context: self.context)
                newUrl.name = url.name
                newUrl.url = url.url
            }
            self.saveContext()
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
    
    
    func saveDecriptionPokemon(with decriptions: DecriptionPokemonResponse) {
        context.perform { [weak self] in
            guard let self = self else { return }
            let newDecription = DescriptionPokemon(context: self.context)
            newDecription.name = decriptions.name
            newDecription.id = Int16(decriptions.id)
            let typesNames = decriptions.types.map { $0.type.name }.joined(separator: ", ")
            newDecription.types = typesNames
            newDecription.weight = decriptions.weight
            newDecription.height = decriptions.height
            
            self.saveContext()
        }
    }
    
    func fetchDescription(byName name: String) -> DescriptionPokemon? {
        let fetchRequest: NSFetchRequest<DescriptionPokemon> = DescriptionPokemon.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let descriptions = try context.fetch(fetchRequest)
            return descriptions.first
        } catch {
            print("Failed to fetch description by name: \(error)")
            return nil
        }
    }
    
    func saveImagePokemon(with images: Data) {
        context.perform { [weak self] in
            guard let self = self else { return }
            let newImage = ImagePokemon(context: self.context)
            newImage.image = images
            self.saveContext()
        }
    }
    
    func fetchImage() -> Data? {
        let fetchImage: NSFetchRequest<ImagePokemon> = ImagePokemon.fetchRequest()
        
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

