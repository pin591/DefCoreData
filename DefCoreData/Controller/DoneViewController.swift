/*
//  DoneViewController.swift
//  GHKanbanViewController
//
//  Created by Ana Rebollo Pin on 14/7/18.
//  Copyright © 2018 Ana Rebollo Pin. All rights reserved.
//
//  This class controls the behaivour of the DoneViewController
//  screen that shows the issues of the repo in whit doing status.
//
//  TO-DO: This code will be the same as DoingViewController,
//  BackLogViewController and NextViewController for this reason
//  in a future refactor is important create only one ViewController
//  called IssueViewController that received the filtered issues per status.
*/

import UIKit
import CoreData

class DoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var doneIssues = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchDoneIssues()
        self.tabBarController?.tabBar.isHidden = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return doneIssues.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        cell.textLabel?.text = doneIssues[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "lowLevel")
        
        return cell
    }
        
    func fetchDoneIssues() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Issue")
        request.predicate = NSPredicate(format: "status = %@", "done")

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let title = data.value(forKey: "title") as? String {
                    self.doneIssues.append(title)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
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
            newIssue.setValue("done", forKey: "status")
            
            do {
                try context.save()
            } catch {
                print("Failed saving repos in DB")
            }
            self.doneIssues.removeAll()
            self.fetchDoneIssues()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
