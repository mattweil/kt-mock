import Foundation
import MapKit

struct FeatureCollection {
    let features: [Feature]
    
    init(arr: Array<[String: Any]>) {
        features = arr.map {f in Feature(item: f)!}
    }
}

struct Feature {
    let name: String
    let number: Int
    let centerpoint: CLLocationCoordinate2D
    let coordinates: Array<CLLocationCoordinate2D>
    
    init?(item: [String : Any]) {
        
        guard let prop = item["properties"] as? [String : Any] else {return nil}
        name = prop["BldgName"] as! String
        number = prop["BldgNum"] as! Int
        centerpoint = CLLocationCoordinate2D(latitude: prop["Latitude"] as! Double, longitude: prop["Longitude"] as! Double)
        
        
        guard let geo = item["geometry"] as? [String : Any] else {return nil}
        let type = geo["type"] as! String
        let coord = geo["coordinates"]
        
        if type == "MultiPolygon" {
            let ex = coord as! Array<Array<Array<Array<Double>>>>
            coordinates = ex
                .flatMap{$0}
                .flatMap{$0}
                .map{d in CLLocationCoordinate2D(latitude: d[1], longitude: d[0])}
        } else {
            let ls = coord as! Array<Array<Array<Double>>>
            coordinates = ls
                .flatMap{$0}
                .map{d in CLLocationCoordinate2D(latitude: d[1], longitude: d[0])}
        }
    }
}

struct AgisAPI {
    
    
    static func getBuildings(completion: @escaping (FeatureCollection) -> ()) {
        let xMin = "-75.314648"
        let yMin = "39.844001"
        let xMax = "-73.963602"
        let yMax = "40.837580"
        
        let str = "https://services1.arcgis.com/ze0XBzU1FXj94DJq/arcgis/rest/services/Rutgers_University_Buildings/FeatureServer/0/query?geometry=%7B%22xmin%22%3A+\(xMin)%2C+%22ymin%22%3A+\(yMin)%2C+%22xmax%22%3A+\(xMax)%2C+%22ymax%22%3A+\(yMax)%7D&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&returnGeodetic=false&outFields=BldgName%2C+BldgNum%2C+Latitude%2C+Longitude&returnGeometry=true&returnCentroid=false&featureEncoding=esriDefault&multipatchOption=xyFootprint&outSR=4326&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=true&cacheHint=false&returnZ=false&returnM=false&returnExceededLimitFeatures=true&sqlFormat=none&f=geojson"
        
        let url = URL(string: str)
        
        guard let aurl = url else {
            print("Url is not working, check if valid?")
            return}
        let task = URLSession.shared.dataTask(with: aurl) {(data, response, error) in
            guard let data = data else { return }
            //let json = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
            do {
                // let collection = try JSONDecoder().decode(FeatureCollection.self, from: data)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                let out = FeatureCollection(arr: json["features"] as! Array<[String : Any]>)
                completion(out)
            } catch let jsonErr {
                print("Error parsing", jsonErr)
            }
        }
        
        task.resume()
        
    }
}
/*
 Future<dynamic> getParking() async {
 final url = "https://services1.arcgis.com/ze0XBzU1FXj94DJq/arcgis/rest/services/Rutgers_University_Parking/FeatureServer/0/query?f=geojson&outFields=Parking_ID%2C%20Lot_Name%2C%20Latitude%2C%20Longitude&outSR=4326&returnDistinctValues=true&where=1%3D1&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&geometry=%7B%22xmin%22%3A+$xMin%2C+%22ymin%22%3A+$yMin%2C+%22xmax%22%3A+$xMax%2C+%22ymax%22%3A+$yMax%7D";
 final response = await http.get(url);
 if (response.statusCode == 200) {
 return json.decode(response.body);
 } else {
 throw "Getting parking returned response code ${response.statusCode}";
 }
 }
 */
