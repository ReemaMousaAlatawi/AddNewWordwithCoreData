//
//  ViewController.swift
//  ExCoreD
//
//  Created by Reema Mousa on 11/09/1443 AH.
//

import UIKit
import CoreData

class ViewController: UIViewController,
                      UITableViewDataSource ,
                      UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listItemArray  = [ListItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var squerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        squerView.round()
        loadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for : indexPath)
        cell.backgroundColor = .clear
        
        cell.textLabel?.text = listItemArray[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Updtate The Word", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Update", style: .default) { (action) in
            self.listItemArray[indexPath.row].setValue(textField.text, forKey: "name")
            self.saveData()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Word"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {


        if(editingStyle == .delete){
            context.delete(listItemArray[indexPath.row])
            listItemArray.remove(at: indexPath.row)
            saveData()
        }
        
        
    }
    
    @IBAction func addbuttonPressed(_ sender: Any) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Word", message: "", preferredStyle: .alert)


        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            let addNewWord = ListItem(context: self.context)
            addNewWord.name = textFeild.text
            self.listItemArray.append(addNewWord)
            self.saveData()
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Word"
            textFeild = alertTextField
        }
        present(alert, animated: true, completion: nil)
 
    }

    
    func saveData(){
        do {
        try  context.save()
        }
        catch{
            print(error)
        }
        tableView.reloadData()

    }
    func loadData(){
        let request : NSFetchRequest<ListItem> = ListItem.fetchRequest()
        do {
            listItemArray =  try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}

extension UIView{
    func round(){
        self.layer.cornerRadius = 15
    }
}
