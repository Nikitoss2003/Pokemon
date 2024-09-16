
protocol DecriptionPokemoProtocol{
    func resultDescription() -> newDecription?
}

final class DecriptionPokemonModel: DecriptionPokemoProtocol{
        let pokemon: Pokemon

        init(pokemon: Pokemon) {
            self.pokemon = pokemon
        }
    
    func resultDescription() -> newDecription?{
        if let result = CoreDataService.shared.fetchDescription(name: pokemon.name){
            let output = newDecription(
                height: Int(result.height),
                    id:  Int(result.id),
                name: result.name ?? "" ,
                weight: Int(result.weight),
                types: result.types,
                imageData: pokemon.imageData
            )
            return output
        }
        return nil
    }
       
    }


