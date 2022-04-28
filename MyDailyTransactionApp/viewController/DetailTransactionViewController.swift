//
//  DetailTransactionViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class DetailTransactionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    @IBOutlet weak var expenseCollectionView: UICollectionView!
    var transaction: Transaction?
    
    let dummyIncome = [
        (incomeName: "income 1", incomeAmount: "Rp. 200.000.00", incomeSource: "dari orang tua"),
        (incomeName: "income 2", incomeAmount: "Rp. 300.000.00", incomeSource: "dari orang tua"),
        (incomeName: "income 3", incomeAmount: "Rp. 500.000.00", incomeSource: "dari orang tua"),
        (incomeName: "income 4", incomeAmount: "Rp. 600.000.00", incomeSource: "dari orang tua")
    ]
    
    let dummyExpense = [
        (expenseName: "expense 1", expenseAmount: "Rp. 200.000.00", expenseNeeds: "makan siang"),
        (expenseName: "expense 2", expenseAmount: "Rp. 500.000.00", expenseNeeds: "makan siang"),
        (expenseName: "expense 3", expenseAmount: "Rp. 700.000.00", expenseNeeds: "makan siang"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        incomeCollectionView.delegate = self
        incomeCollectionView.dataSource = self
        
        let incomeLayout = UICollectionViewFlowLayout()
        incomeLayout.scrollDirection = .horizontal
        incomeLayout.minimumLineSpacing = 10
        incomeLayout.minimumInteritemSpacing = 10
        incomeCollectionView.setCollectionViewLayout(incomeLayout, animated: true)
        
        
        expenseCollectionView.delegate = self
        expenseCollectionView.dataSource = self

        let expenseLayout = UICollectionViewFlowLayout()
        expenseLayout.scrollDirection = .horizontal
        expenseLayout.minimumLineSpacing = 10
        expenseLayout.minimumInteritemSpacing = 10
        expenseCollectionView.setCollectionViewLayout(incomeLayout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: 117)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == incomeCollectionView) {
            return dummyIncome.count
        } else {
            return dummyExpense.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == incomeCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "income_cell", for: indexPath) as! IncomeCell
            let incomes = dummyIncome[indexPath.row]
            
            cell.backgroundColor = .systemGreen
            cell.layer.cornerRadius = 15
            
            cell.incomeName.text = incomes.incomeName
            cell.incomeAmount.text = incomes.incomeAmount
            cell.incomeSource.text = incomes.incomeSource
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "expense_cell", for: indexPath) as! ExpenseCell
            let expenses = dummyExpense[indexPath.row]
            
            cell.backgroundColor = .systemRed
            cell.layer.cornerRadius = 15
            
            cell.expenseName.text = expenses.expenseName
            cell.expenseAmount.text = expenses.expenseAmount
            cell.expenseNeeds.text = expenses.expenseNeeds
            
            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == incomeCollectionView) {
            print(indexPath.row)
        } else {
            print(indexPath.row)
        }
    }

}
