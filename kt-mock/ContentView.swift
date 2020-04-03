import SwiftUI
import Mapbox

struct ContentView: View {
    
    @State private var isOpen: Bool = false
    @State private var searchText: String = ""
    @State private var polygons: [MGLPolygonFeature] = []
    
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 40.5008, longitude: -74.4518))
    ]
    
    
    
    var body: some View {
        ZStack {
            MapView(annotations: $annotations, polygons: $polygons).centerCoordinate(.init(latitude: 40.5008, longitude: -74.4518)).zoomLevel(16)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                HStack {
                    Spacer()
                    TextField("Search", text: $searchText, onEditingChanged: { (b) in
                        
                    }).padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white))
                        .padding()
                    
                    Button(action: {print("hit!")}) {
                        Text("Btn")
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        AgisAPI.getBuildings(completion: {fc in
                            DispatchQueue.main.async {
                                
                                let buildings: [MGLPolygonFeature] = fc.features.map { i in
                                    MGLPolygonFeature(coordinates: i.coordinates, count: UInt(i.coordinates.count))
                                }
                                self.polygons = buildings
                            }
                        });
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        TranslocAPI.getStops(completion: { fc in
                            
    //                            DispatchQueue.main.async {
    //
    //                                let buildings: [MKPolygon] = fc.features.map { i in
    //                                    MKPolygon(coordinates: i.coordinates, count: i.coordinates.count)
    //                                }
    //                                self.polygons = buildings
    //                            }
                            
                            
                        });
                    }) {
                        Image(systemName: "heart")
                    }
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
                Spacer()
                BottomSheetView(isOpen: $isOpen, maxHeight: 600) {
                    Rectangle().fill(Color.red)
                }
            }
        }
    }
}
