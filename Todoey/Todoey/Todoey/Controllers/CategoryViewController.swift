//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/18/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    //cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //numberOfRowInSection:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    
    //MARK: - TableView Delegate Methods
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    
    //MARK: - Data manipulation methods

    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Exception saving categories: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error in laoding categories from DB : \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //the closure here will be invoked after completion entire code in the addButtonPressed()
            
            let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
}
