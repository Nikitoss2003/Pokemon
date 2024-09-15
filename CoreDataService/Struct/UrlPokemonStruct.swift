struct UrlPokemonResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [UrlPokemonStruct]
}

struct UrlPokemonStruct: Decodable{
    var name: String
    var url: String
}
