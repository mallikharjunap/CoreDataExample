//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Apple on 13/02/24.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
  
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView : UITableView = {
        let table =  UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [TodoList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "CoreData To Do List"
        view.addSubview(tableView)
        getAllitem()
        tableView.delegate =  self
        tableView.dataSource = self
        tableView.frame = view.bounds
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        print(model.name!)
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text =  model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item =  models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default,handler: { _ in
            
            let alert =  UIAlertController(title: "Edit Item", message: "Edit Your Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text =  item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel,handler: { [weak self] _ in
                
                guard let field = alert.textFields?.first,let newName = field.text ,!newName.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newName: newName)
                
                
            }))
            
            self.present(alert, animated: true)
            
            
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: { [weak self]_ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
    
    
    
   @objc private func didTapAdd(){
       let alert =  UIAlertController(title: "New Item", message: "Enter New Item", preferredStyle: .alert)
       alert.addTextField(configurationHandler: nil)
       alert.addAction(UIAlertAction(title: "Submit", style: .cancel,handler: { [weak self] _ in
           
           guard let field = alert.textFields?.first,let text = field.text ,!text.isEmpty else {
               return
           }
           
           self?.createItme(name: text)
           
           
       }))
       
       present(alert, animated: true)
    }
    func getAllitem(){
        
        do {
            models = try contex.fetch(TodoList.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("error")
        }
        
    }
    
    func createItme(name:String){
        let newItem = TodoList(context: contex)
        newItem.name = name
        newItem.createdate = Date()
        
        
        do{
            try contex.save()
            getAllitem()
        }
        catch{
            
        }
        
    }
    func deleteItem(item:TodoList){
        contex.delete(item)
        
        do{
            try contex.save()
            getAllitem()
        }catch{
            
        }
        
        
    }
    func updateItem(item:TodoList,newName:String){
        
        item.name = newName
        do{
            try contex.save()
            getAllitem()
        }catch{
            
        }
    }

}

