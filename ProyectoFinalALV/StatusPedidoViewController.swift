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
 
    
    var idPedido: String?
    var origenPedido: String?
    var destinoPedido: String?
    var status: String?
    var progreso: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtIdPedido.text = self.idPedido!
        txtStatus.text = self.status!
        //progresStatus.setProgress(progreso!, animated: true)
        
        // let db = Firestore.firestore()

        let direccionOrigen = origenPedido!.split(separator: " ")
        let direccionDestino = destinoPedido!.split(separator: " ")
        
        let oLat = Double(direccionOrigen[0])
        let oLong = Double(direccionOrigen[1])
        
        let dLat = Double(direccionDestino[0])
        let dLong = Double(direccionDestino[1])
        
        let sourceLocation = CLLocationCoordinate2D(latitude: oLat!, longitude: oLong!)
        let destinationLocation = CLLocationCoordinate2D(latitude: dLat!, longitude: dLong!)
        let sourcePin = customPin(pintitle: "Sucursal", pinSubtitle: "Pro", location: sourceLocation)
        let destinationPin = customPin(pintitle: "Tec", pinSubtitle: "Pro", location: destinationLocation)
        
        
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
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
