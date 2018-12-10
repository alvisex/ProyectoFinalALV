//
//  ViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/8/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var txtQuery: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "busquedaSegue" {
            let busqueda = segue.destination as! RecipeTableVCTableViewController
            
            if let query = txtQuery.text {
                busqueda.busquedaa = query
            } else {
                return
            }
        }
    }


}

