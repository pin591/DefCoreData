/*
//  RemoteRepoViewController.swift
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

class RemoteRepoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var repos = [String]()
    var pressedRow: Int!
    
    var url = URL(string: "https://api.github.com/users/pin591/repos")!
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    typealias JSONDictionaryHandler = (([String:Any]?) -> Void)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .none
        downloadJSONFromURL(_completion: { (data) in })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    func downloadJSONFromURL(_completion: @escaping JSONDictionaryHandler)
    {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request)
        {(data, response,error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data {
                            do {
                                let reposJSON = try JSONDecoder().decode([RepoModel].self, from:data)
                                for repo in reposJSON {
                                    self.repos.append(repo.name)
                                    DispatchQueue.main.async { [unowned self] in
                                        self.tableView.reloadData()
                                    }
                                }
                            } catch let error as NSError {
                                print ("Error processing json data: \(error.localizedDescription)")
                            }
                        }
                    default:
                        print("HTTP Response Code: \(httpResponse.statusCode)")
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
        dataTask.resume()
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
        self.pressedRow = indexPath.row
        performSegue(withIdentifier: "backLogSegue", sender: nil)
    }
    
    // MARK: Swipe action to mark repo as local

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Local") { (action, view, handler) in
            self.repos.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.saveRepoLocally(row: indexPath.row)
        }
        deleteAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func saveRepoLocally(row: Int) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Repo", in: context)
        let newRepo = NSManagedObject(entity: entity!, insertInto: context)
        
        
        newRepo.setValue(repos[row], forKey: "name")
        do {
            try context.save()
        } catch {
            print("Failed saving repos in DB")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backLogSegue" {
            if let vc = segue.destination as? BackLogViewController {
                vc.repoName = repos[pressedRow]
            }
        }
    }
}

