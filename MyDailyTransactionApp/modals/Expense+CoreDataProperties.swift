//
//  Expense+CoreDataProperties.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var expenseName: String?
    @NSManaged public var expenseAmount: Double
    @NSManaged public var expenseNeeds: String?
    @NSManaged public var expenseDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var expenseTransaction: Transaction?

}

extension Expense : Identifiable {

}
