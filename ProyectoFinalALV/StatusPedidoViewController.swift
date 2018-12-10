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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtIdPedido: UILabel!
    @IBOutlet weak var txtStatus: UILabel!
    @IBOutlet var statusProgresB: UIView!
    
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

        ubicaciones.append(Ubicacion(nom: "Tec", lat: 19.72239, long: -101.185485))
        ubicaciones.append(Ubicacion(nom: "Camelinas", lat: 19.682621, long: -101.159651))
        ubicaciones.append(Ubicacion(nom: "Matriz", lat: 19.697988, long: -101.180227))
        ubicaciones.append(Ubicacion(nom: "Centro", lat: 19.702392, long: -101.193664))
        
        var sourceLocation: CLLocationCoordinate2D?
        var destinationLocation: CLLocationCoordinate2D?
        var sourcePin : customPin?
        var destinationPin: customPin?
        
        for u in self.ubicaciones{
            if u.nombre == origenPedido {
                sourceLocation = CLLocationCoordinate2DMake(u.lat, u.long)
                sourcePin = customPin(pintitle: u.nombre, pinSubtitle: "Sucursal", location: sourceLocation!)
            }
            if u.nombre == destinoPedido {
                destinationLocation = CLLocationCoordinate2DMake(u.lat, u.long)
                destinationPin = customPin(pintitle: u.nombre, pinSubtitle: "Destino", location: destinationLocation!)
            }
        }
        
        self.mapView.addAnnotation(sourcePin!)
        self.mapView.addAnnotation(destinationPin!)
        
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
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true )
        }
        
        self.mapView.delegate = self
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 4.5
        return renderer
    }

}
