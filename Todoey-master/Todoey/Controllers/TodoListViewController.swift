//
//  ViewController.swift
//  Todoey
//
//  Created by 小海 on 17/04/2018.
//  Copyright © 2018 Xiaohai Sun. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    var todoitems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        
        guard let colorhex = selectedCategory?.color else{ fatalError()}
        
        updateNavBar(withHexCode: colorhex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBar(withHexCode: "1D9BF6")
    }
    //MARK: - nav bar setup methods
    func updateNavBar(withHexCode colorHexCode : String){
        
        
        
        guard let navBar = navigationController?.navigationBar else{fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else{fatalError()}
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }

    //MARK: - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoitems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoitems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage : CGFloat(indexPath.row) / CGFloat(todoitems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoitems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status\(error)")
            }

        }
        tableView.reloadData()
        
        //Deselects a given row identified by index path, with an option to animate the deselection.
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Itmes
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            //what will happen when user clicks the add item button on our alert
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Wrong in save items\(error)")
                }
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item"
            textfield = alertTextField

        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)


    }
    
    
    
    //MARK: - Model Manupuation Methods
    

    
    
    func loadItems(){
        
        todoitems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoitems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                
            }
        }
        
    }

    
}

//MARK: -Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoitems = todoitems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

}








