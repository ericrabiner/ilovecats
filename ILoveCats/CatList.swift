//
//  CatList.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

class CatList: UITableViewController, CatAddDelegate {
    
    // MARK: - Instance variables
    var m: DataModalManager!
    var items = [Cat]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Waiting for cats..."
        
        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(forName: Notification.Name("WebApiDataIsReady"), object: nil, queue: OperationQueue.main, using: { notification in
            
            // Code that runs when the notification happens
            self.title = "Cat List (\(self.m.catsCount()))"
            self.items = self.m.catGetData()
            self.tableView.reloadData()
        })
        
        // Fetch the data
        m.catGetAll()
    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave item: Cat) {
        if m.catAdd(item) != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m.cats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = m.cats[indexPath.row].catName
        cell.detailTextLabel?.text = m.cats[indexPath.row].ownerName
        
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        if segue.identifier == "toCatScene" {
            let vc = segue.destination as! CatScene
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = items[indexPath!.row]
            vc.item = selectedData
            vc.m = m
            vc.title = "Cat Scene"
        }
        
        if segue.identifier == "toCatAdd" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CatAdd
            vc.title = "Add Cat"
            vc.m = m
            vc.delegate = self
        }
    }
    
    
}

