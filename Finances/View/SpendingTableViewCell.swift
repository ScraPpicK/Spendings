//
//  SpendingTableViewCell.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/6/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

import UIKit

struct SpendingData {
    let placeName: String
    let amount: String
    let purpose: SpendingPurpose
    let editable: Bool
}

class SpendingTableViewCell: UITableViewCell, Reusable {
    // MARK: Private Properties
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var purposeTextField: UITextField!
    @IBOutlet private weak var amountTextField: UITextField!
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
    
    // MARK: Public Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        placeTextField.delegate = self
        purposeTextField.delegate = self
        amountTextField.delegate = self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if editable == true {
            placeTextField.becomeFirstResponder()
        }
    }
    
    func configure(_ data: SpendingData) {
        spendingData = data
    }
    
    func setFirstResponder() {
        if editable == true {
            placeTextField.becomeFirstResponder()
        }
    }
    
    // MARK: Private Methods
    func setTextFieldsEditable(_ editable: Bool) {
        guard let placeTextField = placeTextField,
            let purposeTextField = purposeTextField,
            let amountTextField = amountTextField else { return }
        [placeTextField, purposeTextField, amountTextField].forEach { textField in
            textField.isUserInteractionEnabled = editable
        }
    }
}

extension SpendingTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case placeTextField:
            purposeTextField.becomeFirstResponder()
        case purposeTextField:
            amountTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
