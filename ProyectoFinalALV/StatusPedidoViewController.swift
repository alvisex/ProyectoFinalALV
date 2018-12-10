//
//  StatusPedidoViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/10/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit
import Firebase


class StatusPedidoViewController: UIViewController {

    var idPedido: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        let docRef = db.collection("pedidos").document(idPedido ?? "F0VMuNrH8uR6SAvuEwQk")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                print("Document data: \(data)")
                print("Origen: \(data["origen"] ?? "orig")")
                
            } else {
                print("Document does not exist")
            }
        }
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
