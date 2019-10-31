//
//  CatList.swift
//  ILoveCats
//
//  Created by eric on 2019-10-22.
//  Copyright © 2019 Eric Rabiner. All rights reserved.
//

import UIKit

class CatList: UITableViewController, CatAddDelegate, CatDetailDelegate {
    
    // MARK: - Instance variables
    var m: DataModalManager!
    var cats = [Cat]()
    private var catPhotos = [String: Data]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "Waiting for cats..."
        cats = m.catGetData()
        
        // Listen for a notification that new data is available for the list
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("WebApiDataIsReady"), object: nil)
        
        // Fetch the data
        m.catGetAll()
    }
    
    // Code that runs when the notification happens
    @objc func reloadTableView() {
        cats = m.catGetData()
        title = "Cat List (\(self.cats.count))"
        tableView.reloadData()
        
    }
    
    func addTaskDidCancel(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addTask(_ controller: UIViewController, didSave item: Cat) {
        dismiss(animated: true, completion: nil)
    }
    
    func detailTaskDidFinish(_ controller: UIViewController, didSave item: Cat) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    // Row number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Row count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    // Row contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = cats[indexPath.row].catName
        cell.detailTextLabel?.text = cats[indexPath.row].ownerName
        
        if let image = catPhotos[cats[indexPath.row].photoUrl] {
            cell.imageView?.image = UIImage(data: image)
        }
        else {
            
            cell.imageView?.image = UIImage(named: "catPlaceholder")
            
            if cats[indexPath.row].photoUrl.contains("https://") {
                let photoFetch = URLSession.shared.dataTask(with: URL(string: cats[indexPath.row].photoUrl)!, completionHandler: {data, response, error in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode)
                        else {
                            // Show the URL and response status code in the debug console
                            if let httpResponse = response as? HTTPURLResponse {
                                print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                            }
                            return
                    }
                    
                    if let mimeType = httpResponse.mimeType,
                        mimeType.starts(with: "image/"),
                        let results = data {
                        
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: results)
                            self.catPhotos[self.cats[indexPath.row].photoUrl] = results
                        }
                    }
                })
                photoFetch.resume()
            }
        }

        return cell
    }
    
    // Row Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCatScene" {
            let vc = segue.destination as! CatScene
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = cats[indexPath!.row]
            vc.cat = selectedData
            vc.m = m
        }
        
        if segue.identifier == "toCatAdd" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! CatAdd
            vc.m = m
            vc.delegate = self
        }
        
        if segue.identifier == "toCatDetail" {
            let vc = segue.destination as! CatDetail
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let selectedData = cats[indexPath!.row]
            vc.cat = selectedData
            vc.m = m
        }
    }
}
