//
//  RecipeTableVCTableViewController.swift
//  ProyectoFinalALV
//
//  Created by Alvise on 12/9/18.
//  Copyright © 2018 Alvise. All rights reserved.
//

import UIKit

class RecipeTableVCTableViewController: UITableViewController {

    var recipes: [Recipe] = []
    
    struct webJson: Decodable {
        let results: [Recipe]
    }
    struct Recipe: Decodable {
        let title: String
        let ingredients: String
        let thumbnail: String
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let busqueda = "apple"
        let jsonURL = "http://www.recipepuppy.com/api/?q=\(busqueda)"
        
        guard let url = URL(string: jsonURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let datajson = try JSONDecoder().decode(webJson.self, from: data)
                    self.recipes = datajson.results
                    print( self.recipes.count)
                    print( self.recipes)
                    
                    self.tableView.reloadData()
                } catch let errorr {  }
            }
        }.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)

        
        if recipes[indexPath.row].thumbnail != "" {
            print( "\(recipes[indexPath.row].thumbnail)" )
        }
        cell.textLabel?.text = recipes[indexPath.row].title
        cell.detailTextLabel?.text = recipes[indexPath.row].ingredients
 
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
        if segue.identifier == "detallesSegue" {
            let detailRecipe = segue.destination as! DetallesyOrdenarViewController
            
            if let index = tableView.indexPathForSelectedRow?.row {
                detailRecipe.rtitle = recipes[index].title
                detailRecipe.ringredients = recipes[index].ingredients
                detailRecipe.rimg = recipes[index].thumbnail
            } else {
                return
            }
        }
    }
 

}
