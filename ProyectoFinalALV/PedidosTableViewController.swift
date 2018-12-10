//
//  PedidosTableViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/10/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit
import Firebase

class PedidosTableViewController: UITableViewController {

    
    var pedidos: [[String : Any]] = []
    
    // var quoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
    /*
        db.collection("pedidos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    self.pedidos.append(data)
                    print("\(document.documentID) => \(data)")
                    print("\(document.documentID) => \(data["titulo"] ?? "fasd") ")
                    print("\(self.pedidos.count) ")
                }
            }
 
        }
 
       */
        DispatchQueue.main.async {
        db.collection("pedidos").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.pedidos.removeAll()
                for document in querySnapshot!.documents {
                    var data = document.data()
                    data["idd"] = document.documentID
                    self.pedidos.append(data)
                    print("\(document.documentID) => \(data)")
                    print("\(document.documentID) => \(data["titulo"] ?? "fasd") ")
                    print("\(self.pedidos.count) ")
                    self.tableView.reloadData()
                }
            }
        }
        }
 
        
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pedidos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pedidoCell", for: indexPath)
        cell.textLabel?.text = pedidos[indexPath.row]["titulo"] as? String ?? "tit"
        cell.detailTextLabel?.text = pedidos[indexPath.row]["fecha"] as? String ?? "fech"
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statusSegue" {
            let detailPedido = segue.destination as! StatusPedidoViewController
            
            if let index = tableView.indexPathForSelectedRow?.row {
                detailPedido.idPedido = (pedidos[index]["idd"] as! String)
                detailPedido.origenPedido = (pedidos[index]["origen"] as! String)
                detailPedido.destinoPedido = (pedidos[index]["destino"] as! String)
            } else {
                return
            }
        }
    }
    

}
