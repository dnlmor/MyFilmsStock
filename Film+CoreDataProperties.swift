//
//  Film+CoreDataProperties.swift
//  myfilms
//
//  Created by Daniel Moreno Wellinski Siahaan on 03/02/2025.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var apiId: Int64
    @NSManaged public var filmDescription: String?
    @NSManaged public var genre: String?
    @NSManaged public var id: UUID?
    @NSManaged public var posterURL: String?
    @NSManaged public var rating: Double
    @NSManaged public var title: String?
    @NSManaged public var year: Int16

}

extension Film : Identifiable {

}
