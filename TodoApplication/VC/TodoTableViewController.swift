//
//  TodoTableViewController.swift
//  TodoApplication
//
//  Created by Karim on 25/08/2019.
//  Copyright © 2019 Karim. All rights reserved.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate {

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
        resultsController.delegate = self
        
        //Fetch
        do {
            try resultsController.performFetch()
        }
        catch{
            print("Perform fetch error" , error)
        }
        
    }
    
    // Implement these methods to show updated data in table rows
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        return cell
    }
    
    // Action for deleting Todo
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //TODO : delete todo
            let todo = self.resultsController.object(at: indexPath)
            print(todo)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            }
            catch {
                print("Delete Fail", error)
                completion(false)
            }
        }
//        action.image = UIImage(named: "trash")
        action.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [action]);
    }
    
    // Action for marking todo as done
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
            vc.managedContext = resultsController.managedObjectContext
        }
    }
 

}
