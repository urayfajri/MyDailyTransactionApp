//
//  AddIncomeViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/04/22.
//

import UIKit

class AddIncomeViewController: UIViewController {

    @IBOutlet weak var incomeNameTextField: UITextField!
    @IBOutlet weak var incomeAmountTextField: UITextField!
    @IBOutlet weak var incomeSourceTextField: UITextField!
    @IBOutlet weak var incomeDescriptionTextView: UITextView!
    @IBOutlet weak var addIncomeButton: UIButton!
    
    @IBOutlet weak var validateIncomeName: UILabel!
    @IBOutlet weak var validateIncomeAmount: UILabel!
    @IBOutlet weak var validateIncomeSource: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var transaction: Transaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetForm()
        setUpElements()
    }
    
    func setUpElements() {
        
        CustomElements.styleTextField(incomeNameTextField)
        CustomElements.styleTextField(incomeAmountTextField)
        CustomElements.styleTextField(incomeSourceTextField)
        CustomElements.styleTextView(incomeDescriptionTextView)
        CustomElements.styleFilledButtonAdd(addIncomeButton)
    }
    
    func resetForm() {
        addIncomeButton.isEnabled = false
        
        validateIncomeName.isHidden = false
        validateIncomeAmount.isHidden = false
        validateIncomeSource.isHidden = false
            
        // empty text field
        incomeNameTextField.text = ""
        incomeAmountTextField.text = ""
        incomeSourceTextField.text = ""
        incomeDescriptionTextView.text = ""
    
    }
    
    @IBAction func incomeNameChanged(_ sender: Any) {
        if let incomeName = incomeNameTextField.text
        {
            if let errorMessage = invalidIncomeName(incomeName)
            {
                validateIncomeName.text = errorMessage
                validateIncomeName.isHidden = false
            } else
            {
                validateIncomeName.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func incomeAmountChanged(_ sender: Any) {
        if let incomeAmount = incomeAmountTextField.text
        {
            if let errorMessage = invalidIncomeAmount(incomeAmount)
            {
                validateIncomeAmount.text = errorMessage
                validateIncomeAmount.isHidden = false
            } else
            {
                validateIncomeAmount.isHidden = true
            }
        }
        checkValidForm()
    }

    @IBAction func incomeSourceChanged(_ sender: Any) {
        if let incomeSource = incomeSourceTextField.text
        {
            if let errorMessage = invalidIncomeSource(incomeSource)
            {
                validateIncomeSource.text = errorMessage
                validateIncomeSource.isHidden = false
            } else
            {
                validateIncomeSource.isHidden = true
            }
        }
        checkValidForm()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Add Income", message: "Are you sure want to add this Income", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            
            if incomeDescriptionTextView.text.isEmpty
            {
                incomeDescriptionTextView.text = ""
            }
            
            let newIncome = Income(context: self.context)
            newIncome.incomeName = incomeNameTextField.text
            newIncome.incomeAmount = Double(incomeAmountTextField.text ?? "0") ?? 0.0
            newIncome.incomeSource = incomeSourceTextField.text
            newIncome.incomeDescription = incomeDescriptionTextView.text
            newIncome.createdAt = Date()
            
            transaction?.addToIncomes(newIncome)

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
    
    func invalidIncomeName(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Income Name is Required"
        }
        return nil
    }
    
    func invalidIncomeAmount(_ value: String) -> String? {
        
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set)
        {
            return "Income Amount only contain numbers"
        }
        if value.isEmpty
        {
            return "Income Amount is Required"
        }
        return nil
    }
    
    func invalidIncomeSource(_ value: String) -> String? {
        
        if value.isEmpty
        {
            return "Income source is Required"
        }
        return nil
    }
    
    func checkValidForm() {
        if(validateIncomeName.isHidden && validateIncomeAmount.isHidden && validateIncomeSource.isHidden)
        {
            addIncomeButton.isEnabled = true
        }
        else
        {
            addIncomeButton.isEnabled = false
        }
    }
}
