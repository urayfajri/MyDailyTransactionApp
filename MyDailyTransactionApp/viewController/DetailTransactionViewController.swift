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
    
    @IBOutlet weak var emptyIncomeLabel: UILabel!
    @IBOutlet weak var emptyExpenseLabel: UILabel!
    
    @IBOutlet weak var addIncomeButton: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    @IBOutlet weak var expenseCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var transaction: Transaction?
    var incomes =  [Income]()
    var expenses = [Expense]()
    
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var totalBudgetLabel: UILabel!
    @IBOutlet weak var totalBudgetCurrLabel: UILabel!
    @IBOutlet weak var totalBudgetTextLabel: UILabel!
    
    var totalIncome:Double = 0
    var totalExpense:Double = 0
    var totalBudget:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTransaction()
        fetchIncome()
        fetchExpense()
        calculateTransactionBudget()
        
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
        expenseCollectionView.setCollectionViewLayout(expenseLayout, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initTransaction()
        fetchIncome()
        incomeCollectionView.reloadData()
        
        fetchExpense()
        expenseCollectionView.reloadData()
        
        calculateTransactionBudget()
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
        if let datas = transaction?.incomeArray {
            incomes = datas
        }
        
        totalIncome = 0
        if(incomes.isEmpty) {
            incomeCollectionView.isHidden = true
            emptyIncomeLabel.isHidden = false
            
            totalIncomeLabel.text = "0"
        } else {
            incomeCollectionView.isHidden = false
            emptyIncomeLabel.isHidden = true
            
            for income in incomes {
                totalIncome += income.incomeAmount
            }
            
            let totalIncomeFormatNumber = CustomElements.formatNumber(totalIncome)
            totalIncomeLabel.text = "\(totalIncomeFormatNumber)"
        }
    }
    
    func fetchExpense()
    {
        if let datas = transaction?.expenseArray {
            expenses = datas
        }
        
        totalExpense = 0
        if(expenses.isEmpty) {
            expenseCollectionView.isHidden = true
            emptyExpenseLabel.isHidden = false
            
            totalExpenseLabel.text = "0"
        } else {
            expenseCollectionView.isHidden = false
            emptyExpenseLabel.isHidden = true
    
            for expense in expenses {
                totalExpense += expense.expenseAmount
            }
            
            let totalExpenseFormatNumber = CustomElements.formatNumber(totalExpense)
            totalExpenseLabel.text = "\(totalExpenseFormatNumber)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == expenseCollectionView) {
            return expenses.count
        } else {
            return incomes.count
        }
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
            
            let incomeFormatNumber = CustomElements.formatNumber(incomes.incomeAmount)
            
            let textIncomeAmount = "Rp. \(incomeFormatNumber)"
            cell.incomeAmount.text = textIncomeAmount
            cell.incomeSource.text = incomes.incomeSource
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "expense_cell", for: indexPath) as! ExpenseCell
            let expenses = expenses[indexPath.row]

            cell.backgroundColor = .systemRed
            cell.layer.cornerRadius = 15
            cell.expenseName.textColor = .white
            cell.expenseAmount.textColor = .white
            cell.expenseNeeds.textColor = .white
            cell.expenseNeedsSymbol.tintColor = .white
            cell.expenseAmountSymbol.tintColor = .white

            cell.expenseName.text = expenses.expenseName
            
            let expenseFormatNumber = CustomElements.formatNumber(expenses.expenseAmount)

            let textExpenseAmount = "Rp. \(expenseFormatNumber)"
            cell.expenseAmount.text = textExpenseAmount
            cell.expenseNeeds.text = expenses.expenseNeeds

            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == incomeCollectionView) {
            let income = incomes[indexPath.row]
            let sheet = UIAlertController(title: "Action for Income", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "See Detail", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "income_detail") as! DetailIncomeViewController
                vc.income = income
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_income") as! EditIncomeViewController
                vc.income = income
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]_ in
                self?.deleteIncome(income: income)
                collectionView.reloadData()
            }))
            
            present(sheet, animated: true)
        } else {
            let expense = expenses[indexPath.row]
            let sheet = UIAlertController(title: "Action for Expense", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "See Detail", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "expense_detail") as! DetailExpenseViewController
                vc.expense = expense
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_expense") as! EditExpenseViewController
                vc.expense = expense
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]_ in
                self?.deleteExpense(expense: expense)
                collectionView.reloadData()
            }))
            
            present(sheet, animated: true)
        }
    }

    @IBAction func trashButtonTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Delete", message: "Are you sure want to delete this transaction?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            self.deleteItem(item: transaction!)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func deleteItem(item: Transaction)
    {
        context.delete(item)
        
        do
        {
            try context.save()
        }
        catch
        {

        }
    }
    
    func deleteIncome(income: Income)
    {
        context.delete(income)
        
        do
        {
            try context.save()
            fetchIncome()
            fetchExpense()
            calculateTransactionBudget()
        }

        catch
        {

        }
    }
    
    func deleteExpense(expense: Expense)
    {
        context.delete(expense)
        
        do
        {
            try context.save()
            fetchIncome()
            fetchExpense()
            calculateTransactionBudget()
        }

        catch
        {

        }
    }
    @IBAction func editButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_transaction") as! EditTransactionViewController
        vc.transaction = transaction
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addIncomeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "add_income") as! AddIncomeViewController
        vc.transaction = transaction
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addExpenseTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "add_expense") as! AddExpenseViewController
        vc.transaction = transaction
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calculateTransactionBudget() {
        if (totalIncome >= totalExpense) {
            totalBudget = totalIncome - totalExpense
            totalBudgetLabel.textColor = .systemGreen
            totalBudgetCurrLabel.textColor = .systemGreen
            totalBudgetTextLabel.textColor = .systemGreen
            
            let totalBudgetFormatNumber = CustomElements.formatNumber(totalBudget)
            totalBudgetLabel.text = "\(totalBudgetFormatNumber)"
        } else {
            totalBudget = totalExpense - totalIncome
            totalBudgetLabel.textColor = .systemRed
            totalBudgetCurrLabel.textColor = .systemRed
            totalBudgetTextLabel.textColor = .systemRed
            
            let totalBudgetFormatNumber = CustomElements.formatNumber(totalBudget)
            totalBudgetLabel.text = "\(totalBudgetFormatNumber)"
        }
        updateTransactionStatus(item: transaction!)
    }
    
    func updateTransactionStatus(item: Transaction) {
        if (totalIncome >= totalExpense) {
            item.transactionStatus = "Good"
            item.transactionBudget = totalIncome - totalExpense
        } else {
            item.transactionStatus = "Not Good"
            item.transactionBudget = totalExpense - totalIncome
        }
        do{
            try context.save()
        }
        catch
        {
            
        }
    }
}
