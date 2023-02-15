//
//  DetailViewController.swift
//  TestingTaskVRG
//
//  Created by Evgeniy Lemish on 09.02.2023.
//

import Foundation
import UIKit
import Alamofire
import CoreData
import SafariServices



class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var article: Result?
    var articleFromCoreData: Article?
    
    // CoreData
    
    var articlesCoreData : [Article] = .init()
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var articleStackView: UIStackView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var forMoreInfo: UILabel!
    

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleText.text = article?.abstract ?? articleFromCoreData?.articlesAbstract
        articleTitle.text = article?.title ?? articleFromCoreData?.articlesTitle
        forMoreInfo.text = "More info: " + (article?.url ?? articleFromCoreData?.articlesLink ?? " ")
        articleText.isEditable = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageLoad()
        buttonDissappear()
    }
    
    // MARK: - Actions
    
    @IBAction func addToFavoritesButton(_ sender: Any) {
        saveArticles()
        favoritesButton.isEnabled = false
        favoritesButton.setTitle("Saved in Favorites", for: UIControl.State.normal)
    } 
    
    
    // MARK: - CoreData
    
    
    func saveArticles() {
        
        guard let artID = article?.id else { return }
        
        let entity = Article(context: context)
        entity.articlesTitle = article?.title
        entity.articlesAbstract = article?.abstract
        entity.articlesLink = article?.url
        entity.articleID = Int64(artID)
        entity.atritlesImage = articleImage.image?.jpegData(compressionQuality: 1)
        
        do {
            try context.save()
            articlesCoreData.append(entity)
            print("Saved! Good Job!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func buttonDissappear() {
        if articleFromCoreData != nil {
            favoritesButton.isHidden = true
        }
    }
    
    func imageLoad() {
        if let absoluteUrlString = article?.media?.filter({$0.type == .image }).first?.mediaMetadata?.filter({ $0.format == .mediumThreeByTwo440 }).first?.url {
            guard let url = URL(string: absoluteUrlString ) else {return}
            AF.request(url).responseData { response in
                guard let data = response.data else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.articleImage.image = image
                }
            }.resume()
        } else {
            if let imageData = articleFromCoreData?.atritlesImage {
                self.articleImage.image = UIImage(data: imageData)
            } else {
                self.articleImage.isHidden = true
            }
        }
    }
}

