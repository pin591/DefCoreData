/*
 //  LocalRepoViewController.swift
 //  GHKanbanViewController
 //
 //  Created by Ana Rebollo Pin on 13/7/18.
 //  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
 //
 // This class list all the user repos in the firstTab.
 // And the local repos stored in the device in the secondTab.
 // To store a repo locally swipe the cell and select store in
 // the first tab.
 // To remove a repo for the local memory of the device swipe
 // the cell and select delete in the second tab.
 */

import UIKit
import CoreData

class LocalRepoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var repos = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .none
        fetchLocalRepos()
        self.tabBarController?.tabBar.isHidden = false

    }
        
    override func viewWillAppear(_ animated: Bool) {
        fetchLocalRepos()
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }

    func fetchLocalRepos() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Repo")
    
        do {
            let result = try context.fetch(request) 
            for data in result as! [NSManagedObject] {
                if let name = data.value(forKey: "name") as? String {
                     repos.append(name)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return repos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.textLabel?.text = repos[indexPath.row]
        cell.detailTextLabel?.text = "Ana Rebollo"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.selectionStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        repos.removeAll()
    }
}


