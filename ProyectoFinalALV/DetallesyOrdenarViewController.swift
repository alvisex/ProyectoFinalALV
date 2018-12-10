//
//  DetallesyOrdenarViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/9/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit
import Firebase

class DetallesyOrdenarViewController: UIViewController {
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

    var rtitle : String?
    var ringredients : String?
    var rimg : String?
    
    let sucursales = ["Matriz","Camelinas","Centro"]
    var sucursal = ""
    var origen = ""
    
    @IBOutlet weak var recipeImgV: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var sucursalUIPicker: UIPickerView!
    
    
    @IBAction func clickPedirBtn(_ sender: Any) {
        ubicaciones.append(Ubicacion(nom: "Tec", lat: 19.72239, long: -101.185485))
        ubicaciones.append(Ubicacion(nom: "Camelinas", lat: 19.682621, long: -101.159651))
        ubicaciones.append(Ubicacion(nom: "Matriz", lat: 19.697988, long: -101.180227))
        ubicaciones.append(Ubicacion(nom: "Centro", lat: 19.702392, long: -101.193664))
        for u in self.ubicaciones{
            if u.nombre == sucursal {
                origen = "\(u.lat) \(u.long)"
            }
        }

        print(origen)

        print(sucursal)
        var ref: DocumentReference!
        let db = Firestore.firestore()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let fecha = formatter.string(from: Date())
        
        ref = db.collection("pedidos").addDocument(data: [
            "titulo": rtitle ?? "Titulo",
            "img": rimg ?? "ImagenURL",
            "ingredientes": ringredients ?? "Ingredientes",
            "fecha": fecha,
            "destino":"19.72239 -101.185485",
            "origen": origen,
            "status": "iniciado" ,
            "valor": 0.1,
            "moto": origen
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sucursalUIPicker.delegate = self
        sucursalUIPicker.dataSource = self
        
        recipeTitleLabel.text = rtitle
        recipeIngredientsLabel.text = ringredients
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetallesyOrdenarViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sucursales.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sucursal = sucursales[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sucursales[row]
    }
    
}
