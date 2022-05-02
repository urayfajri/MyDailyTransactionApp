//
//  Income+CoreDataProperties.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 02/05/22.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var incomeAmount: Double
    @NSManaged public var incomeDescription: String?
    @NSManaged public var incomeName: String?
    @NSManaged public var incomeSource: String?
    @NSManaged public var incomeTransaction: Transaction?

}

extension Income : Identifiable {

}
