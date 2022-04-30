//
//  DetailExpenseViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class DetailExpenseViewController: UIViewController {
    
    @IBOutlet weak var expenseNameLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    @IBOutlet weak var expenseNeedsLabel: UILabel!
    @IBOutlet weak var expenseDescriptionTextView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var expense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initExpense()
    }
    
    func initExpense() {
        expenseNameLabel.text = expense?.expenseName
        
        let expenseAmountTxt = expense?.expenseAmount ?? 0.0
        expenseAmountLabel.text = "Rp. \(expenseAmountTxt)"
        expenseNeedsLabel.text = expense?.expenseNeeds
        expenseDescriptionTextView.text = expense?.expenseDescription
        expenseDescriptionTextView.isEditable = false


    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "edit_expense") as! EditExpenseViewController
        vc.expense = expense
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Delete", message: "Are you sure want to delete this Expense?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            self.deleteItem(item: expense!)
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func deleteItem(item: Expense)
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
}
