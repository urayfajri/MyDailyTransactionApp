//
//  EditIncomeViewController.swift
//  MyDailyTransactionApp
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 29/04/22.
//

import UIKit

class EditIncomeViewController: UIViewController {
    
    
    @IBOutlet weak var incomeNameTextField: UITextField!
    @IBOutlet weak var incomeAmountTextField: UITextField!
    @IBOutlet weak var incomeSourceTextField: UITextField!
    @IBOutlet weak var incomeDescriptionTextView: UITextView!
    
    @IBOutlet weak var editIncomeButton: UIButton!
    
    @IBOutlet weak var validateIncomeName: UILabel!
    @IBOutlet weak var validateIncomeAmount: UILabel!
    @IBOutlet weak var validateIncomeSource: UILabel!
    
    var income: Income?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEditedIncome()
        updateForm()
        setUpElements()

    }
    
    func setUpElements() {
        
        CustomElements.styleTextField(incomeNameTextField)
        CustomElements.styleTextField(incomeAmountTextField)
        CustomElements.styleTextField(incomeSourceTextField)
        CustomElements.styleTextView(incomeDescriptionTextView)
        CustomElements.styleFilledButtonEdit(editIncomeButton)
    }
    
    func updateForm() {
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
    
    @IBAction func incomeSource(_ sender: Any) {
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
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let alertControl = UIAlertController(title: "Edit Income", message: "Are you sure want to edit this income?", preferredStyle: .alert)
        alertControl.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            alertControl.dismiss(animated: true, completion: nil)
        }))
        alertControl.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self]_ in
            
            if incomeDescriptionTextView.text.isEmpty
            {
                incomeDescriptionTextView.text = ""
            }
            
            updateIncome(item: income!)
        }))
        
        self.present(alertControl, animated: true)
    }
    
    func updateIncome(item: Income) {
        item.incomeName = incomeNameTextField.text
        item.incomeAmount = Double(incomeAmountTextField.text ?? "0") ?? 0.0
        item.incomeSource = incomeSourceTextField.text
        item.incomeDescription = incomeDescriptionTextView.text
        
        do{
            
            try context.save()
            
            self.navigationController?.popViewController(animated: true)
        }
        catch
        {
            
        }
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
            editIncomeButton.isEnabled = true
        }
        else
        {
            editIncomeButton.isEnabled = false
        }
    }
    
    func fetchEditedIncome()
    {
        incomeNameTextField.text = income?.incomeName
        incomeSourceTextField.text = income?.incomeSource
        incomeDescriptionTextView.text = income?.incomeDescription

        let amountMoneyTxt = "\(Int(income?.incomeAmount ?? 0))"
        incomeAmountTextField.text = amountMoneyTxt

    }
}
