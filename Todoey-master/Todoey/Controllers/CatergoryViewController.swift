//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 小海 on 11/05/2018.
//  Copyright © 2018 Xiaohai Sun. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CatergoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else{fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D98F6")

        return cell
    }
    

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        //Deselects a given row identified by index path, with an option to animate the deselection.
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category:Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    //MARK: -Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category,\(error)")
            }
            // tableView.reloadData()
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new Category"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
   
    
}



