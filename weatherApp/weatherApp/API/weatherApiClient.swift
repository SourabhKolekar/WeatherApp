
import Foundation

class weatherApiClient: ApiClient {
    var session: URLSession
    
    init(session:URLSession = URLSession.shared) {
        self.session=session
    }
    

    func weatherData(with endpoint: weatherEndpoint, completion: @escaping (dataResponse<Daily,APIError>) -> Void){
        let request = endpoint.request
        
        self.fetchData(with: request) { (dataResponse: dataResponse<weatherApi, APIError>) in
            switch dataResponse{
                
            case .value(let weatherObj):
                let weather = weatherObj.daily
                completion(.value(weather))
            
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
