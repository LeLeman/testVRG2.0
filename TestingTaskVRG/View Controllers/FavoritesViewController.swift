//
//  FavoritesViewController.swift
//  TestingTaskVRG
//
//  Created by Evgeniy Lemish on 09.02.2023.
//

import UIKit
import Alamofire
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // CoreData
    
    var articlesCoreDate: [Article] = .init()
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromCoreData()
    }
   
    
    // MARK: - UITableViewDataDelegate
    
    func createTable() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
       let articleToDelete = articlesCoreDate[indexPath.row]
       guard editingStyle == .delete else { return }
    
        articlesCoreDate.remove(at: indexPath.row)
        context.delete(articleToDelete)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesCoreDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = articlesCoreDate[indexPath.row].articlesTitle

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = articlesCoreDate[indexPath.row]
        
        guard let detailViewController = UIStoryboard(name: "DetailView", bundle: nil).instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {return}
        detailViewController.articleFromCoreData = article
        
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.modalPresentationStyle = .automatic
        present (detailViewController, animated: true)
    }
    
    
    // MARK: - CoreData
    
    func fetchDataFromCoreData () {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        do{
            articlesCoreDate = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

