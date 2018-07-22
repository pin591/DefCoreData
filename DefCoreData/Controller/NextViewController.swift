/*
//  NextViewController.swift
//  GHKanbanViewController
//
//  Created by Ana Rebollo Pin on 14/7/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//
//  This class controls the behaivour of the NextViewController
//  screen that shows the issues of the repo in whit doing status.
//
//  TO-DO: This code will be the same as DoingViewController,
//  BackLogViewController and DoneViewController for this reason
//  in a future refactor is important create only one ViewController
//  called IssueViewController that received the filtered issues per status.
*/

import UIKit
import CoreData

class NextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var nextIssues = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchNextIssues()
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return nextIssues.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.textLabel?.text = nextIssues[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "mediumLevel")
        return cell
    }
    
    func fetchNextIssues() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Issue")
        request.predicate = NSPredicate(format: "status = %@", "next")
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let title = data.value(forKey: "title") as? String {
                    self.nextIssues.append(title)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let backlogAction = UIContextualAction(style: .destructive, title: "backlog") { (action, view, handler) in
            print("backlog")
        }
        backlogAction.backgroundColor = .gray
        
        let nextlogAction = UIContextualAction(style: .destructive, title: "next") { (action, view, handler) in
            print("next")
        }
        nextlogAction.backgroundColor = .blue
        
        let doneAction = UIContextualAction(style: .destructive, title: "done") { (action, view, handler) in
            print("done")
        }
        doneAction.backgroundColor = .orange
        
        let doingAction = UIContextualAction(style: .destructive, title: "doing") { (action, view, handler) in
            print("doing")
        }
        doingAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [backlogAction, nextlogAction,
                                                     doneAction, doingAction])
    }
    
    @IBAction func addNextIssue(_ sender: Any) {
        let alertController = UIAlertController(title: "Add issue",
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
            let entity = NSEntityDescription.entity(forEntityName: "Issue", in: context)
            
            let newIssue = NSManagedObject(entity: entity!, insertInto: context)
            newIssue.setValue(title, forKey: "title")
            newIssue.setValue(explanation, forKey: "explanation")
            newIssue.setValue("next", forKey: "status")
            
            do {
                try context.save()
            } catch {
                print("Failed saving repos in DB")
            }
            self.nextIssues.removeAll()
            self.fetchNextIssues()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
