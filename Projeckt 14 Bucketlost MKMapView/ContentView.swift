//
//  ContentView.swift
//  Projeckt 14 Bucketlost MKMapView
//
//  Created by Артем Волков on 19.02.2021.
//

import SwiftUI
import MapKit
import  LocalAuthentication

struct ContentView: View {
    @State var centerCoordinate = CLLocationCoordinate2D()
    @State var locations = [CodableMKPointAnnotation]()
    @State var selectedPlace: MKPointAnnotation?
    @State var showingPlaceDetail = false
    @State var showingEditScrenn = false
    @State var isUnlocked = false
    
    var body: some View {
        ZStack{
            if isUnlocked{
               NewMapView(centerCoordinate: $centerCoordinate, locations: $locations, selectedPlace: $selectedPlace, showingPlaceDetail: $showingPlaceDetail, showingEditScrenn: $showingEditScrenn)
            } else {
                Button("Unlock"){
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white )
                .clipShape(Circle())
            }

        }
        .alert(isPresented: $showingPlaceDetail){
            Alert(title: Text(selectedPlace?.title ?? "Unknowne"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton: .default(Text("Ok")), secondaryButton: .default(Text("Edit")){
                self.showingEditScrenn = true
            })
        }
        .sheet(isPresented: $showingEditScrenn, onDismiss: saveData){
            if self.selectedPlace != nil{
                EditView(placeMark: self.selectedPlace!)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }
        
        func loadData() {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

            do {
                let data = try Data(contentsOf: filename)
                locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
            } catch {
                print("Unable to load saved data.")
            }
        }
        
        func saveData() {
            do {
                let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
                let data = try JSONEncoder().encode(self.locations)
                try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
    
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Please authenticete to unlock your places."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (succes, authError) in
                DispatchQueue.main.async {
                    if succes{
                        self.isUnlocked = true
                    } else {
                        //error
                    }
                }
            }
        } else {
            // no biometry
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


