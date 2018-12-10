//
//  StatusPedidoViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/10/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class customPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(pintitle: String, pinSubtitle: String, location: CLLocationCoordinate2D) {
        self.title = pintitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
}

class StatusPedidoViewController: UIViewController, MKMapViewDelegate {

    var idPedido: String?
    var origenPedido: String?
    var destinoPedido: String?
    
    var ubicaciones: [Ubicacion] = []
    
    struct Ubicacion {
        let nombre: String
        let lat: Double
        let long: Double
        init(nom: String, lat: Double, long: Double) {
            self.nombre = nom
            self.lat = lat
            self.long = long
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()

        db.collection("ubicaciones").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ubicaciones.removeAll()
                for document in querySnapshot!.documents {
                    var data = document.data()
                    data["nombre"] = document.documentID
                    let ubi = Ubicacion(nom: data["nombre"] as! String, lat: data["lat"] as! Double, long: data["long"] as! Double)
                    self.ubicaciones.append(ubi)
                    print("mira => \(ubi) ")
                    print("\(self.ubicaciones.count) ")
                }
            }
        }
        
        var sourceLocation: CLLocationCoordinate2D?
        var destinationLocation: CLLocationCoordinate2D?
        
        for u in self.ubicaciones{
            if u.nombre == origenPedido {
                sourceLocation = CLLocationCoordinate2DMake(u.lat, u.long)
                var sourcePin = customPin(pintitle: u.nombre, pinSubtitle: "Sucursal", location: sourceLocation!)
            }
            if u.nombre == destinoPedido {
                destinationLocation = CLLocationCoordinate2DMake(u.lat, u.long)
                var destinationPin = customPin(pintitle: u.nombre, pinSubtitle: "Destino", location: destinationLocation!)
            }
        }
        
        // self.mapView.addAnotation(sourcePin)
        // self.mapView.addAnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation!)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation!)
        
        let directionReq = MKDirections.Request()
        directionReq.source = MKMapItem(placemark: sourcePlaceMark)
        directionReq.destination = MKMapItem(placemark: destinationPlaceMark)
        directionReq.transportType = .automobile
        
        let directions = MKDirections(request: directionReq)
        directions.calculate{ (response, error) in
            guard let directionsResponse = response else {
                if let error = error {
                    print("pinchi error \(error.localizedDescription)  ")
                }
                return
            }
            let route = directionsResponse.routes[0]
            // self.mapView.add(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            // self.mapView.setRegion(MKCordinateRegionForMapRect(rect), animated: true )
        }
        
        //self.mapView.delegate = self
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 4.5
        return renderer
    }

}
