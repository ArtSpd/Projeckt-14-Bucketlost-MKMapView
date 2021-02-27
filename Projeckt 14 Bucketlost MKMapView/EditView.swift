//
//  EditView.swift
//  Projeckt 14 Bucketlost MKMapView
//
//  Created by Артем Волков on 25.02.2021.
//

import SwiftUI
import MapKit

struct EditView: View {
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var placeMark: MKPointAnnotation
    @State private var loadingState = LoadingState.loaded
    @State private var pages = [Page]()
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
        
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place name", text: $placeMark.wrappedTitle)
                    TextField("Place desription", text: $placeMark.wrappedSubtitle)
                }
                Section(header: Text("Nearby")){
                    if loadingState == .loaded{
                        List(pages, id:\.pageid){ page in
                            Text(page.title)
                                .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                                .italic()
                        }
                    } else if loadingState == .loading{
                        Text("Loading...")
                    } else {
                        Text("Try it again")
                    }
                }
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done"){
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: fetchNearbyPlaces)
        }
    }
    
    func fetchNearbyPlaces(){
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placeMark.coordinate.latitude)%7C\(placeMark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bed URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url){ data, response, error in
            if let data = data{
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data){
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }
            }
            self.loadingState = .failed
        }.resume()
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placeMark: MKPointAnnotation.example)
    }
}
