//
//  MostSharedViewController.swift
//  TestingTaskVRG
//
//  Created by Evgeniy Lemish on 09.02.2023.
//

import UIKit
import Alamofire

class MostSharedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: - Properties
    
    var result: [Result] = .init()
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMostPopular(type: .shared, period: .period30Days)
        createTable()
    }

    
    // MARK: - UITableViewDataDelegate
    
    func createTable() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = result[indexPath.row]
        cell.textLabel?.text = article.title

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = result[indexPath.row]
        
        guard let detailViewController = UIStoryboard(name: "DetailView", bundle: nil).instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {return}
        detailViewController.article = article
        
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.modalPresentationStyle = .automatic
        present (detailViewController, animated: true)
        }
    
    
    // MARK: - API
    
    func fetchMostPopular (type: MostPopular, period: Period) {
        APIManager.apiManager.fetchContent(type: type, period: period) { [weak self] (results) in
                self?.result += results
                self?.tableView.reloadData()
        }
    }
}

