//
//  Transaction+CoreDataProperties.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var transactionName: String?
    @NSManaged public var transactionDate: Date?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var incomes: NSSet?
    @NSManaged public var expenses: NSSet?

}

// MARK: Generated accessors for incomes
extension Transaction {

    @objc(addIncomesObject:)
    @NSManaged public func addToIncomes(_ value: Income)

    @objc(removeIncomesObject:)
    @NSManaged public func removeFromIncomes(_ value: Income)

    @objc(addIncomes:)
    @NSManaged public func addToIncomes(_ values: NSSet)

    @objc(removeIncomes:)
    @NSManaged public func removeFromIncomes(_ values: NSSet)

}

// MARK: Generated accessors for expenses
extension Transaction {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension Transaction : Identifiable {

}
