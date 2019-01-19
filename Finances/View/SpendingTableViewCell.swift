//
//  SpendingTableViewCell.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/6/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

import UIKit
import CoreData

protocol SpendingTableViewCellDelegate: class {
    func spendingTableViewCellUpdatedValue(_ newValue: SpendingData)
}

class SpendingTableViewCell: UITableViewCell, Reusable {
    // MARK: Private Properties
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var purposeTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
    private var textfields: [UITextField]?
    private var editable = false {
        didSet {
            setTextFieldsEditable(editable)
        }
    }
    private var spendingData: SpendingData? {
        didSet {
            placeTextField.text = spendingData?.placeName
            amountTextField.text = spendingData?.amount
            purposeTextField.text = spendingData?.purpose.rawValue
            editable = spendingData?.editable ?? false
        }
    }
    
    // MARK: Public Properties
    weak var delegate: SpendingTableViewCellDelegate?
    
    // MARK: Public Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        placeTextField.delegate = self
        purposeTextField.delegate = self
        amountTextField.delegate = self
        setupTextFields()
    }
    
    func configure(_ data: SpendingData) {
        spendingData = data
    }
    
    // MARK: Private Methods
    private func setupTextFields() {
        textfields = [placeTextField, purposeTextField, amountTextField]
    }

    func setTextFieldsEditable(_ editable: Bool) {
        guard let textFields = self.textfields else { return }
        textFields.forEach { textField in
            runOnMainAvoidDeadlock {
                textField.isUserInteractionEnabled = editable
            }
        }
        setFirstResponderIfNeeded()
    }
    
    private func setFirstResponderIfNeeded() {
        if editable == true {
            placeTextField.becomeFirstResponder()
        } else {
            guard let textFields = self.textfields else { return }
            textFields.forEach { textField in
                textField.resignFirstResponder()
            }
        }
    }
}

extension SpendingTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case placeTextField:
            self.spendingData?.placeName = textField.text ?? ""
            purposeTextField.becomeFirstResponder()
        case purposeTextField:
            self.spendingData?.purpose = .other
            amountTextField.becomeFirstResponder()
        case amountTextField:
            let newAmount = textField.text ?? "0"
            guard var spending = spendingData else {
                textField.resignFirstResponder()
                return true
            }
            spending.amount = newAmount
            
            delegate?.spendingTableViewCellUpdatedValue(spending)
            editable = false
        default:
            break
        }
        return true
    }
}
