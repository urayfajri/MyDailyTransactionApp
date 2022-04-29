//
//  DetailTransactionViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit
import CoreData

class DetailTransactionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionNoteTextView: UITextView!
    
    
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    @IBOutlet weak var expenseCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var transaction: Transaction?
    var incomes =  [Income]()
    var expenses = [Expense]()
    
    let dummyExpense = [
        (expenseName: "expense 1", expenseAmount: "Rp. 200.000.00", expenseNeeds: "makan siang"),
        (expenseName: "expense 2", expenseAmount: "Rp. 500.000.00", expenseNeeds: "makan siang"),
        (expenseName: "expense 3", expenseAmount: "Rp. 700.000.00", expenseNeeds: "makan siang"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        initTransaction()
        fetchIncome()
        fetchExpense()
        print(incomes.count)
        print(expenses.count)
        
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
    
    func initTransaction() {
        transactionNameLabel.text = transaction?.transactionName
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        transactionDateLabel.text = dateFormatter.string(from: (transaction?.transactionDate!)!)
                                                        
        transactionNoteTextView.text = transaction?.transactionDescription
        transactionNoteTextView.isEditable = false
        
        addIncomeButton.tintColor = .systemGreen
        addExpenseButton.tintColor = .systemRed

    }
    
    func fetchIncome()
    {
        incomes = []
        let fetchReq: NSFetchRequest<Income> = Income.fetchRequest()
        
//        let pred = NSPredicate(format: "incomeTransaction CONTAINS '\(transaction)'")
//
//        fetchReq.predicate = pred
        
        do
        {
            incomes = try context.fetch(fetchReq)
        }
        
        catch
        {
            
        }
    }
    
    func fetchExpense()
    {
        expenses = []
        let fetchReq: NSFetchRequest<Expense> = Expense.fetchRequest()
        
//        let pred = NSPredicate(format: "incomeTransaction CONTAINS '\(transaction)'")
//
//        fetchReq.predicate = pred
        
        do
        {
            expenses = try context.fetch(fetchReq)
        }
        
        catch
        {
            
        }
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
        if(collectionView == expenseCollectionView) {
            return dummyExpense.count
        }
        return incomes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == incomeCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "income_cell", for: indexPath) as! IncomeCell
            let incomes = incomes[indexPath.row]
            
            cell.backgroundColor = .systemGreen
            cell.layer.cornerRadius = 15
            cell.incomeName.textColor = .white
            cell.incomeAmount.textColor = .white
            cell.incomeSource.textColor = .white
            cell.incomeAmountSymbol.tintColor = .white
            cell.incomeSourceSymbol.tintColor = .white
            
            cell.incomeName.text = incomes.incomeName
            
            let textIncomeAmount = "\(Int(incomes.incomeAmount))"
            cell.incomeAmount.text = textIncomeAmount
            cell.incomeSource.text = incomes.incomeSource
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "expense_cell", for: indexPath) as! ExpenseCell
            let expenses = dummyExpense[indexPath.row]

            cell.backgroundColor = .systemRed
            cell.layer.cornerRadius = 15
            cell.expenseName.textColor = .white
            cell.expenseAmount.textColor = .white
            cell.expenseNeeds.textColor = .white
            cell.expenseNeedsSymbol.tintColor = .white
            cell.expenseAmountSymbol.tintColor = .white

            cell.expenseName.text = expenses.expenseName

//            let textExpenseAmount = "\(Int(expenses.expenseAmount))"
//            cell.expenseAmount.text = textExpenseAmount
            cell.expenseNeeds.text = expenses.expenseNeeds

            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == incomeCollectionView) {
            let item = incomes[indexPath.row]
            let sheet = UIAlertController(title: "Action for Income", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "See Detail", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "income_detail") as! DetailIncomeViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_income") as! EditIncomeViewController
                // vc.income = item
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]_ in
            }))
            
            present(sheet, animated: true)
        } else {
            let item = dummyExpense[indexPath.row]
            let sheet = UIAlertController(title: "Action for Expense", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "See Detail", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "expense_detail") as! DetailExpenseViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_expense") as! EditExpenseViewController
                // vc.income = item
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]_ in
            }))
            
            present(sheet, animated: true)
        }
    }

}
