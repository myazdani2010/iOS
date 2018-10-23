//
//  ViewController.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/16/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

//UITableViewController manages the table and takes care of delegate as well
class TodoListViewController: SwipteTableViewController {
    
    var items : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    
    // This will be called one the view is loaded and ready to apear.
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.backgroundColor else {
            fatalError("backgroundColor does not exist")
        }
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        guard let navBarColor = UIColor(hexString: colorHex) else {
            fatalError("'colorHex' is empty or wrong format")
        }
        
        //change the title in the nav bar
        title = selectedCategory!.name
        //navigation bar background color
        navBar.barTintColor = navBarColor
        //assign contrast color for the Navigation bar title text
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        //assign contrast color to the foreground of the navigation bar
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        //search bar background color
        searchBar.barTintColor = navBarColor
        
    }
    
    
    
    //MARK - Tableview Datasource Methods
    
    //cellForRowAt : used to display date in the cell at the given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        if let color = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        }
        
        return cell
    }
    
    
    
    //numberOfRowInSection: to create the required number of cells in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error savinf done status, \(error)")
            }
        }
        
        tableView.reloadData()
        //deselect the row after gets selected each time to remove the gray background 
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    //MARK - Delete Data from Swipte
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.items?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error while deleting Item, \(error)")
            }
        }
    }
    
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //the closure here will be invoked after completion entire code in the addButtonPressed()

            if let currectCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.dateCreated = Date()
                        item.title = textField.text!
                        currectCategory.items.append(item)
                    }
                } catch {
                    print("Erro saving new item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK - Model manipulation Methods
    
    
    //load data
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }


}



//MARK - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar : UISearchBar){
        items = items?.filter("title CONTAINS[dc] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

