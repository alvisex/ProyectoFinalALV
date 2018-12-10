//
//  RecipesTableVC.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/9/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit

class RecipesTableVC: UITableViewController {
    
    var search : String?
    var arrayPlaces = Array<Venue>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let find = search {
            // Se crea el Observer para el Notification deben tener los mismos nombres ("VenuesRetrieve")
            NotificationCenter.default.addObserver(self, selector: #selector(venuesResult(notification:)), name: NSNotification.Name(rawValue: "VenuesRetrieve"), object: nil)
            
            let con = VenueConnection(search: find)
            con.toDo()
            
        } else {
            return
        }
    }
    
    @objc private func venuesResult(notification: Notification) {
        // Se obtiene la informacion de la notificacion a traves del key "places" definido en userInfo en la notificacion
        if let places = notification.userInfo!["places"] {
            // Se transforma a arreglo de Venue
            arrayPlaces = places as! Array<Venue>
            
            // Para unificar los diferentes hilos se utiliza una cola de sincronizacion
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath)
        
        cell.textLabel?.text = arrayPlaces[indexPath.row].id!
        cell.detailTextLabel?.text = arrayPlaces[indexPath.row].name!
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            let detailVenue = segue.destination as! DetailViewController
            
            if let index = tableView.indexPathForSelectedRow?.row {
                detailVenue.id = arrayPlaces[index].id
            } else {
                return
            }
        }
        
    }
    
}
