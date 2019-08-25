//
//  TodoTableViewController.swift
//  TodoApplication
//
//  Created by Karim on 25/08/2019.
//  Copyright © 2019 Karim. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {

    // MARK : properties
    
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        let request : NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "date", ascending: true)
        
        //Init
        request.sortDescriptors = [sortByDate]
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        //Fetch
        do {
            try resultsController.performFetch()
        }
        catch{
            print("Perform fetch error" , error)
        }
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 10;
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //TODO : delete todo
            completion(true)
        }
//        action.image = UIImage(named: "trash")
        action.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [action]);
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            //TODO : delete todo
            completion(true)
        }
//        action.image = UIImage(named: "right")
        action.backgroundColor = UIColor.green
        return UISwipeActionsConfiguration(actions: [action]);
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTodoViewController{
            vc.managedContext = coreDataStack.managedContext
        }
    }
 

}
