import Foundation
import SwiftUI

struct TranslocAPI {
    
    struct StopCollection {
        
    }
    
    struct Stop {
        let name: String
        let stopID: String
//        let location: CLLocationCoordinate2D
        let routes: Array<String>
        
//        init?(item: [String : Any]) {
            
//            guard let prop = item["properties"] as? [String : Any] else {return nil}
//            name = prop["BldgName"] as! String
//            number = prop["BldgNum"] as! Int
//            centerpoint = CLLocationCoordinate2D(latitude: prop["Latitude"] as! Double, longitude: prop["Longitude"] as! Double)
//            
//
//            guard let geo = item["geometry"] as? [String : Any] else {return nil}
//            let type = geo["type"] as! String
//            let coord = geo["coordinates"]
//
//            if type == "MultiPolygon" {
//                let ex = coord as! Array<Array<Array<Array<Double>>>>
//                coordinates = ex
//                    .flatMap{$0}
//                    .flatMap{$0}
//                    .map{d in CLLocationCoordinate2D(latitude: d[1], longitude: d[0])}
//            } else {
//                let ls = coord as! Array<Array<Array<Double>>>
//                coordinates = ls
//                    .flatMap{$0}
//                    .map{d in CLLocationCoordinate2D(latitude: d[1], longitude: d[0])}
//            }
//        }
        
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
                print(json)
//                let out = FeatureCollection(arr: json["features"] as! Array<[String : Any]>)
//                completion(out)
            } catch let err {
                
            }
        }
        
        task.resume()
        
    }
}
