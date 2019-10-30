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
        //title = "Waiting for cats..."
        items = m.catGetData()
        
        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("WebApiDataIsReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("CatPostWasSuccessful"), object: nil)
        
        // Fetch the data
        m.catGetAll()
    }
    
    // Code that runs when the notification happens
    @objc func reloadTableView() {
        title = "Cat List (\(self.m.catsCount()))"
        items = m.catGetData()
        tableView.reloadData()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        items = m.catGetData()
//        tableView.reloadData()
//    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave item: Cat) {
        m.catPostNew(item)
        dismiss(animated: true, completion: nil)
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCatScene" {
            let vc = segue.destination as! CatScene
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = items[indexPath!.row]
            vc.item = selectedData
            vc.m = m
            //vc.title = "Cat Scene"
        }
        
        if segue.identifier == "toCatAdd" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CatAdd
            //vc.title = "Add Cat"
            vc.m = m
            vc.delegate = self
        }
    }
}
