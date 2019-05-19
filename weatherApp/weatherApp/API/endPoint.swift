
import Foundation


protocol endPoint {
    var baseUrl : String {get}
    var path: String {get}
    var queryItems:[URLQueryItem] {get}
}

let apiKey="b362bd5813e8f9c106c0ab05a3a6e780"
let locationLat="-37.814"               // melbourne for now as  trial
let locationLong="144.96332"


enum weatherEndpoint: endPoint{

    case foreCast(latitude: Double, longitude: Double)
    
    var baseUrl: String
    {
        return "https://api.darksky.net"
    }
    
    var path: String
    {
        switch self {
            //-37.814,144.96332
        case .foreCast(let latitude, let longitude):
            return "/forecast/\(apiKey)/\(latitude),\(longitude)"
        }
    }
    
    var queryItems: [URLQueryItem]
    {
        return []
    }
}


extension endPoint{
    var urlComponent:URLComponents{
        var component=URLComponents(string: baseUrl)
        component?.path=path
        component?.queryItems=queryItems
        
        return component!
    }
    
    var request: URLRequest{
        return URLRequest(url: urlComponent.url!)
    }
}
