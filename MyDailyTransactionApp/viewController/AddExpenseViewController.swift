//
//  AddExpenseViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var expenseNeedsTextField: UITextField!
    @IBOutlet weak var expenseDescriptionTextView: UITextView!
    
    @IBOutlet weak var validateExpenseName: UILabel!
    @IBOutlet weak var validateExpenseAmount: UILabel!
    @IBOutlet weak var validateExpenseNeeds: UILabel!
    
    @IBOutlet weak var addExpenseButton: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var transaction: Transaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
        setUpElements()

    }
    
    func setUpElements() {
        
        CustomElements.styleTextField(expenseNameTextField)
        CustomElements.styleTextField(expenseAmountTextField)
        CustomElements.styleTextField(expenseNeedsTextField)
        CustomElements.styleTextView(expenseDescriptionTextView)
        CustomElements.styleFilledButtonAdd(addExpenseButton)
    }
    
    func resetForm() {
        addExpenseButton.isEnabled = false
        
        validateExpenseName.isHidden = false
        validateExpenseAmount.isHidden = false
        validateExpenseNeeds.isHidden = false
            
        // empty text field
        expenseNameTextField.text = ""
        expenseAmountTextField.text = ""
        expenseNeedsTextField.text = ""
        expenseDescriptionTextView.text = ""
    
    }
    
    @IBAction func expenseNameChanged(_ sender: Any) {
        if let expenseName = expenseNameTextField.text
        {
            if let errorMessage = invalidExpenseName(expenseName)
            {
                validateExpenseName.text = errorMessage
                validateExpenseName.isHidden = false
            } else
            {
                validateExpenseName.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func expenseAmountTapped(_ sender: Any) {
        if let expenseAmount = expenseAmountTextField.text
        {
            if let errorMessage = invalidExpenseAmount(expenseAmount)
            {
                validateExpenseAmount.text = errorMessage
                validateExpenseAmount.isHidden = false
            } else
            {
                validateExpenseAmount.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func expenseNeedsChanged(_ sender: Any) {
        if let expenseNeeds = expenseNeedsTextField.text
        {
            if let errorMessage = invalidExpenseNeeds(expenseNeeds)
            {
                validateExpenseNeeds.text = errorMessage
                validateExpenseNeeds.isHidden = false
            } else
            {
                validateExpenseNeeds.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func addExpenseTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Add Expense", message: "Are you sure want to add this Expense", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            
            if expenseDescriptionTextView.text.isEmpty
            {
                expenseDescriptionTextView.text = ""
            }
            
            let newExpense = Expense(context: self.context)
            newExpense.expenseName = expenseNameTextField.text
            newExpense.expenseAmount = Double(expenseAmountTextField.text ?? "0") ?? 0.0
            newExpense.expenseNeeds = expenseNeedsTextField.text
            newExpense.expenseDescription = expenseDescriptionTextView.text
            newExpense.createdAt = Date()
            
            transaction?.addToExpenses(newExpense)

            do{
                try context.save()
                // balik ke satu halaman sebelumnnya
                self.navigationController?.popViewController(animated: true)
                
                // balik ke root controller (halaman pertama kali launch)
                // self.navigationController?.popToRootViewController(animated: true)

            }
            catch
            {
                
            }
            
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func invalidExpenseName(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Expense Name is Required"
        }
        return nil
    }
    
    func invalidExpenseAmount(_ value: String) -> String? {
        
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "Expense Amount only contain numbers"
        }
        if value.isEmpty
        {
            return "Expense Amount is Required"
        }
        return nil
    }
    
    func invalidExpenseNeeds(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Expense Needs is Required"
        }
        return nil
    }
    
    func checkValidForm() {
        if(validateExpenseName.isHidden && validateExpenseAmount.isHidden && validateExpenseNeeds.isHidden)
        {
            addExpenseButton.isEnabled = true
        }
        else
        {
            addExpenseButton.isEnabled = false
        }
    }
}
