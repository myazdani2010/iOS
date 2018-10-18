//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/16/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import UIKit
import CoreData

//UITableViewController manages the table and takes care of delegate as well
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //get the singleton AppDelegate  context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        laodItems()
    }
    
    
    
    //MARK - Tableview Datasource Methods
    
    //cellForRowAt : used to display date in the cell at the given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //"ToDoItemCell" is the identifirer that is given in the attribute inspecture -> Table view Cell -> identifier
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    
    //numberOfRowInSection: to create the required number of cells in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //deselect the row after gets selected each time to remove the gray background 
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Itme", style: .default) { (action) in
            //the closure here will be invoked after completion entire code in the addButtonPressed()
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            self.itemArray.append(item)
            
            self.saveItems()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK - Model manipulation Methods
    
    //Encode and save data in the phone plist file
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //load and decode the data
    func laodItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }

}

