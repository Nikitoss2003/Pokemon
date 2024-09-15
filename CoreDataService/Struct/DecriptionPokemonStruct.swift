struct DecriptionPokemonResponse: Decodable{
    var height: Int16
    var id: Int
    var name: String
    var weight: Int16
    var types: [TypeSlot]
}

struct PokemonType: Decodable {
    var name: String
    var url: String
}

struct TypeSlot: Decodable {
    var slot: Int
    var type: PokemonType
}

struct newDecription{
    var height: Int
    var id: Int
    var name: String
    var weight: Double
    var types: String?
}
