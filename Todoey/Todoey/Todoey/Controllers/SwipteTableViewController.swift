//
//  SwipteTableViewController.swift
//  Todoey
//
//  Created by Mohammad Yazdani on 10/23/18.
//  Copyright © 2018 MYazdani. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipteTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //"Cell" is the identifirer that is given in the attribute inspecture -> Table view Cell -> identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    //responsible for what should happened after user swipes to right
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted.")
            
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    
    //explansion style
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        //delete cell from table
        options.expansionStyle = .destructive
        return options
    }
    
    
    func updateModel(at indexPath: IndexPath){
        //Update data model
    }

}
