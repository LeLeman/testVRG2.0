//
//  Articles+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Lemish on 13.02.2023.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var articleTitle: String?
    @NSManaged public var articleAbstract: String?
    @NSManaged public var articleLink: String?
    @NSManaged public var atritleImage: Data?

}
