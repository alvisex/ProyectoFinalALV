//
//  DetallesyOrdenarViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/9/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit

class DetallesyOrdenarViewController: UIViewController {

    var rtitle : String?
    var ringredients : String?
    var rimg : String?
    
    let sucursales = ["Matriz","Camelinas","Centro"]
    var sucursal = ""
    
    @IBOutlet weak var recipeImgV: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var sucursalUIPicker: UIPickerView!
    
    
    @IBAction func clickPedirBtn(_ sender: Any) {
        print(sucursal)
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
