//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/18/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipteTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - TableView Datasource Methods
    
    //cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.backgroundColor) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }

        return cell
    }
    
    
    //numberOfRowInSection:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    //if clicked on any item in the category list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    //MARK: - Data manipulation methods
    
    //save to DB
    func saveCategories(category : Category) {
        
        do {
            try realm.write {
                category.backgroundColor = UIColor.randomFlat.hexValue()
                realm.add(category)
            }
        } catch {
            print("Exception saving categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //load from DB
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //MARK - Delete Data from Swipte
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error while deleting category, \(error)")
            }
        }
    }
    
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //the closure here will be invoked after completion entire code in the addButtonPressed()
            let category = Category()
            category.name = textField.text!
            self.saveCategories(category: category)
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
}

