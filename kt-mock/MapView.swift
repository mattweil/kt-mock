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
    @Binding var polylines: [MGLPolylineFeature]
    
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    
    // MARK: - Configuring UIViewRepresentable protocol
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        updateAnnotations()
        updateBuildings()
        updateRoutes()
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
        
        mapView.style?.addLayer(fillLayer)
    }
    
    
    // http://mapbox.github.io/mapbox-gl-native/macos/0.7.1/Classes/MGLPolyline.html
    private func updateRoutes(){
        
        if let currentRoutes = mapView.style?.source(withIdentifier: "routeSource") {
            mapView.style?.removeSource(currentRoutes)
            print("exists")
        }
        
        let shapeSource = MGLShapeSource(identifier: "routeSource", features: polylines, options: nil)
        
        let layer = MGLLineStyleLayer(identifier: "routes", source: shapeSource)
        layer.sourceLayerIdentifier = "routeSource"

        layer.lineColor = NSExpression(forConstantValue: UIColor.green)
        layer.lineCap = NSExpression(forConstantValue: "round")
        
        
        mapView.style?.addSource(shapeSource)
        mapView.style?.addLayer(layer)
        
        
        
    }
    
//    private func updateStops(){
//        let layer = MGLCircleStyleLayer(identifier: "circles", source: population)
//        layer.sourceLayerIdentifier = "population"
//        layer.circleColor = NSExpression(forConstantValue: UIColor.green)
//        layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)",
//                                          [12: 2,
//                                           22: 180])
//        layer.circleOpacity = NSExpression(forConstantValue: 0.7)
//        layer.predicate = NSPredicate(format: "%K == %@", "marital-status", "married")
//        mapView.style?.addLayer(layer)
//
//    }
    
    // MARK: - Implementing MGLMapViewDelegate
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            


        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
         
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
    }
    
}
