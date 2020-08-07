//
//  FoldersViewController.swift
//  FileStorageApp
//
//  Created by Damian Lopez on 7/30/20.
//  Copyright © 2020 Damian Lopez. All rights reserved.
//

import UIKit
import CoreData

class FoldersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var addedContext: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Folders"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Folder Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Folder")
        
        
        do {
            addedContext = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
//    MARK: Tapping the Add Button
    @IBAction func addFolderButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Folder", message: "Add new folder", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                    return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            managedContext.delete(addedContext[indexPath.row])
            addedContext.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            appDelegate.saveContext()
        }
    }
    
    func save(name: String) {
            
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
       
        let managedContext = appDelegate.persistentContainer.viewContext
            
        let entity = NSEntityDescription.entity(forEntityName: "Folder", in: managedContext)!
            
        let folder = NSManagedObject(entity: entity, insertInto: managedContext)
        
            folder.setValue(name, forKeyPath: "name")
            
        
        do { try managedContext.save()
            addedContext.append(folder)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
        }
    }
        
}

extension FoldersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return addedContext.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let folder = addedContext[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Folder Cell",
                                              for: indexPath)
            cell.textLabel?.text =
                folder.value(forKeyPath: "name") as? String
            return cell
    }
}
