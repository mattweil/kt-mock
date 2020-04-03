import Foundation
import SwiftUI
import MapKit

struct TranslocAPI {
    
    struct StopCollection {
        let stops: [Stop]
        
        init(arr: Array<[String: Any]>) {
            stops = arr.map {s in Stop(item: s)!}
        }
    }
    
    struct Stop {
        let name: String
        let stopID: String
        let location: CLLocationCoordinate2D
//        let routes: Array<String>

        init?(item: [String : Any]) {

            var loc = item["location"] as? [String : Any]
            
            name = item["name"] as! String
            stopID = item["stop_id"] as! String
            location = CLLocationCoordinate2D(latitude: loc!["lat"] as! CLLocationDegrees, longitude: loc!["lng"] as! CLLocationDegrees)
            print(name)
        }

    }

    static func getStops(completion: @escaping (StopCollection) -> ()){

        let headers = [
            "x-rapidapi-host": "transloc-api-1-2.p.rapidapi.com",
            "x-rapidapi-key": "dfbde1c89dmsh8697f36b261c293p150e54jsn8092ee0a4232"
        ]

        let url = URL(string: "https://transloc-api-1-2.p.rapidapi.com/stops.json?callback=call&agencies=1323");
        
        
        let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, res, error) in guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                let out = StopCollection(arr: json["data"] as! Array<[String : Any]>)
//                print(json["data"])
            } catch let err {
                
            }
        }
        
        task.resume()
        
    }
}
