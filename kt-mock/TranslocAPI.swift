import Foundation
import SwiftUI
import MapKit
import Polyline

struct TranslocAPI {
    
    struct SegmentCollection {
        let segments: [Segment]
        
        init(dic: Dictionary<String, String>) {
            segments = dic.map {(a,b) in Segment(item: b)! }
        }
    }
    
    struct Segment {
        let path: [CLLocationCoordinate2D]
        init?(item: String) {
            path = decodePolyline(item)!
        }
    }
    
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
        }

    }
    
    static func getSegments(routes: Array<String>, completion: @escaping (SegmentCollection) -> ()){
            let headers = [
                "x-rapidapi-host": "transloc-api-1-2.p.rapidapi.com",
                "x-rapidapi-key": "dfbde1c89dmsh8697f36b261c293p150e54jsn8092ee0a4232"
            ]

            let url = URL(string: "https://transloc-api-1-2.p.rapidapi.com/segments.json?routes=4012632&callback=call&agencies=1323");
            
            
            let request = NSMutableURLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, res, error) in guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                    let out = SegmentCollection(dic: json["data"] as! Dictionary<String, String>)
                    completion(out)
                } catch let err {
                    print("err on segs")
                }
            }
            
            task.resume()
        
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
                completion(out)
            } catch let err {
                
            }
        }
        
        task.resume()
        
    }
}
