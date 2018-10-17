//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/16/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import UIKit

//UITableViewController manages the table and takes care of delegate as well
class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        let item1 = Item()
        item1.title = "Find Milk"
        item1.done = true
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "Buy Eggos"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "Destroy Demogorgon"
        itemArray.append(item3)
        
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
            let item = Item()
            item.title = textField.text!
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //load and decode the data
    func laodItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }

}

