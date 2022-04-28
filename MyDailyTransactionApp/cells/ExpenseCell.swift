//
//  ExpenseCell.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class ExpenseCell: UICollectionViewCell {
    
    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var expenseNeeds: UILabel!
    @IBOutlet weak var expenseAmountSymbol: UIImageView!
    @IBOutlet weak var expenseNeedsSymbol: UIImageView!
}
