enum ErrorAPI: Error {
    case invalidURL
    case noData
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        }
    }
}


