import SwiftUI
import Mapbox

extension MGLPointAnnotation {
    convenience init(title: String, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.coordinate = coordinate
    }
}

struct MapView: UIViewRepresentable {

    @Binding var annotations: [MGLPointAnnotation]
    @Binding var polygons: [MGLPolygonFeature]
    
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    
    // MARK: - Configuring UIViewRepresentable protocol
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        updateAnnotations()
        updateBuildings()
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Configuring MGLMapView
    
    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
        return self
    }
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }
    
    func zoomLevel(_ zoomLevel: Double) -> MapView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    
    private func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotations(annotations)
    }
    
    private func updateBuildings() {
        if let currentBuildings = mapView.style?.source(withIdentifier: "buildingSource") {
            mapView.style?.removeSource(currentBuildings)
            print("exists")
        }
        
        
        let shapeSource = MGLShapeSource(identifier: "buildingSource", features: polygons, options: nil)
        mapView.style?.addSource(shapeSource)
        
        let fillLayer = MGLFillStyleLayer(identifier: "buildingFillLayer", source: shapeSource)
        fillLayer.fillColor = NSExpression(forConstantValue: UIColor.blue)
        fillLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
        
        mapView.style?.addLayer(fillLayer)
    }
    
    // MARK: - Implementing MGLMapViewDelegate
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            
//            let coordinates = [
//                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
//                CLLocationCoordinate2D(latitude: 37.791591, longitude: -122.396566),
//                CLLocationCoordinate2D(latitude: 37.791147, longitude: -122.396009),
//                CLLocationCoordinate2D(latitude: 37.790883, longitude: -122.396349),
//                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
//            ]
//
//            let buildingFeature = MGLPolygonFeature(coordinates: coordinates, count: 5)
//            let shapeSource = MGLShapeSource(identifier: "buildingSource", features: [buildingFeature], options: nil)
//            mapView.style?.addSource(shapeSource)
//
//            let fillLayer = MGLFillStyleLayer(identifier: "buildingFillLayer", source: shapeSource)
//            fillLayer.fillColor = NSExpression(forConstantValue: UIColor.blue)
//            fillLayer.fillOpacity = NSExpression(forConstantValue: 0.5)
//
//            mapView.style?.addLayer(fillLayer)

        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
         
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
    }
    
}
