//
//  MKPoinitAnnotation-Observable.swift
//  Projeckt 14 Bucketlost MKMapView
//
//  Created by Артем Волков on 25.02.2021.
//

import MapKit

extension MKPointAnnotation: ObservableObject{
    public var wrappedTitle: String {
        get{
            self.title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String{
        get{
            self.subtitle ?? "Unknown value"
        }
        set {
            subtitle = newValue
        }
    }
}
