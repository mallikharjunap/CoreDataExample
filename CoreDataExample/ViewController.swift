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
        }catch{
            
        }
        
        
    }
    func updateItem(item:TodoList,newName:String){
        
        item.name = newName
        do{
            try contex.save()
        }catch{
            
        }
    }

}

