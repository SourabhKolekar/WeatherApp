
import Foundation

enum dataResponse<V, E:Error> {
    case value(V)
    case error(E)
}


enum APIError:Error {
    case apiError
    case badResponse
    case jsonDecoder
    case unknown(String)
}
protocol ApiClient {
    var session: URLSession{ get }
    func fetchData<V: Codable>(with request:URLRequest, completion:@escaping(dataResponse<V, APIError>)-> Void)
}

extension ApiClient
{
    func fetchData<V: Codable>(with request:URLRequest, completion:@escaping(dataResponse<V, APIError>)-> Void)
    {
        let requestTask=session.dataTask(with: request) { (data, response, error) in
            guard error==nil else
            {
                completion(.error(.apiError))
                return
            }
            
            guard let response=response as? HTTPURLResponse, 200..<300 ~= response.statusCode else{
                completion(.error(.badResponse))
                return
            }
            
            guard let decodeData=try? JSONDecoder().decode(V.self, from: data!) else
            {
                completion(.error(.jsonDecoder))
                return
            }
            
            completion(.value(decodeData))
        }
        requestTask.resume()
    }

}
