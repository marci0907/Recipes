import Alamofire
import RxSwift
import RxAlamofire

enum NetworkError: Error {
    case decodeFailed
    case networkError
    case wrongURL

    var localizedDescription: String {
        switch self {
        case .decodeFailed:
            return "Network data couldn't be decoded."
        case .networkError:
            return "There was a problem during requesting network data."
        case .wrongURL:
            return "Data was requested from an invalid URL."
        }
    }
}

class NetworkManager {

    private var apiKey: String
    private var baseUrl: String
    private var headers: [HTTPHeader]

    init(apiKey: String, baseUrl: String, headers: [HTTPHeader]) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.headers = headers
    }

    func sendRequest<T: Decodable>(method: HTTPMethod, toEndPoint endPoint: String, withParameters param: [String: String], additionalHeaders: [HTTPHeader]? = nil) -> Single<T> {
        guard let finalUrl = URL(string: baseUrl + endPoint + apiKey) else {
            return .error(NetworkError.wrongURL)
        }

        return RxAlamofire.request(method, finalUrl, parameters: param, headers: HTTPHeaders(headers + (additionalHeaders ?? [])))
            .validate(statusCode: 200...299)
            .responseData()
            .catchError { error in Observable.error(NetworkError.networkError) }
            .asSingle()
            .flatMap { [unowned self] in self.decodeJSON($1) }
    }

    private func decodeJSON<T: Decodable> (_ data: Data) -> Single<T> {
        Single<T>.create { single in
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                single(.success(decodedData))
            } catch {
                single(.error(NetworkError.decodeFailed))
            }
            return Disposables.create()
        }
    }
}
