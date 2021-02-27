//
//  NewMapView.swift
//  Projeckt 14 Bucketlost MKMapView
//
//  Created by Артем Волков on 26.02.2021.
//

import SwiftUI
import MapKit

struct NewMapView: View{
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetail: Bool
    @Binding var showingEditScrenn: Bool
    
    
    var body: some View{
        Group{
            MapView(centerCoordinate: $centerCoordinate,selectedPlace: $selectedPlace, showingPlaceDetail: $showingPlaceDetail,  annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill()
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.title = "Example"
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                        
                        self.selectedPlace = newLocation
                        self.showingEditScrenn = true
                    }, label: {
                        Image(systemName: "plus")
                        
                    })
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding()
                }
            }
        }
    }
}



