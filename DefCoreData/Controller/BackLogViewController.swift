/*
//  BackLogViewController.swift
//  GHKanbanViewController
//
//  Created by Ana Rebollo Pin on 14/7/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//
//  This class controls the behaivour of the BackLogViewController
//  screen that shows the issues of the repo in whit doing status.
//
//  TO-DO: This code will be the same as DoneViewController,
//  DoingViewController and NextViewController for this reason
//  in a future refactor is important create only one ViewController
//  called IssueViewController that received the filtered issues per status.
*/

import UIKit
import CoreData

class BackLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var backLogIssues = [IssueModel]()
    var repoName: String!
    var newRepo: NSManagedObject!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchBackLogRepos()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return backLogIssues.count

    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.textLabel?.text = backLogIssues[indexPath.row].title
        cell.detailTextLabel?.text = backLogIssues[indexPath.row].explanation
        cell.imageView?.image = #imageLiteral(resourceName: "lowLevel")
        
        return cell
    }
    
    func fetchBackLogRepos() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Issue")
        request.predicate = NSPredicate(format: "status = %@", "backLog")
        //request.predicate = NSPredicate(format: "ANY repo = %@", "GHKanban")

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let title = data.value(forKey: "title") as? String,
                let explanation = data.value(forKey: "explanation") as? String,
                let repo = data.value(forKey: "repo") as? NSManagedObject
                {
                    let issue = IssueModel(title:title,
                                        explanation: explanation)
                    self.backLogIssues.append(issue)
                    print(repo)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: -Adding swipe actions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let backlogAction = UIContextualAction(style: .destructive, title: "backlog") { (action, view, handler) in
            print("backlog")
            self.changeStatus(repoName: self.backLogIssues[indexPath.row].title, status: "backlog")
        }
        backlogAction.backgroundColor = .gray
        
        let nextlogAction = UIContextualAction(style: .destructive, title: "next") { (action, view, handler) in
            print("next")
            self.changeStatus(repoName: self.backLogIssues[indexPath.row].title, status: "next")

        }
        nextlogAction.backgroundColor = .blue
        
        let doneAction = UIContextualAction(style: .destructive, title: "done") { (action, view, handler) in
            print("done")
            self.changeStatus(repoName: self.backLogIssues[indexPath.row].title, status: "done")

        }
        doneAction.backgroundColor = .orange
        
        let doingAction = UIContextualAction(style: .destructive, title: "doing") { (action, view, handler) in
            print("doing")
            self.changeStatus(repoName: self.backLogIssues[indexPath.row].title, status: "doing")

        }
        doingAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [backlogAction, nextlogAction,
                                                     doneAction, doingAction])
    }
    
    @IBAction func addBackLogIssue(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Issue",
                                            message: "Enter issue details",
                                            preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter issue name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter issue explanation"
        }
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            let title = alertController.textFields?[0].text
            let explanation = alertController.textFields?[1].text
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let repoEntity = NSEntityDescription.entity(forEntityName: "Repo", in: context)!
            self.newRepo = NSManagedObject(entity: repoEntity, insertInto: context)
            self.newRepo.setValue("Wiki-Plant", forKey: "name")
            
            let entity = NSEntityDescription.entity(forEntityName: "Issue", in: context)
            let newIssue = NSManagedObject(entity: entity!, insertInto: context)
            
            newIssue.setValue(title, forKey: "title")
            newIssue.setValue(explanation, forKey: "explanation")
            newIssue.setValue("backLog", forKey: "status")
            newIssue.setValue(self.newRepo!, forKey: "repo")
        
            do {
                try context.save()
            } catch {
                print("Failed saving repos in DB")
            }
            self.backLogIssues.removeAll()
            self.fetchBackLogRepos()
            self.tableView.reloadData()
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeStatus(repoName: String, status: String) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Issue")
        let predicate = NSPredicate(format: "title = @", "repoName")
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "title") as? String) != nil {
                    data.setValue("backlog", forKey: "status")
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
