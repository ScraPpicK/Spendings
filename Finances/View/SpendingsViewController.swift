//
//  ViewController.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/6/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

import UIKit

class SpendingsViewController: UIViewController {
    // MARK: Private Properties
    private var tableViewData = [SpendingData]()
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 5
        let spendingData = SpendingData(placeName: "Сильпо", amount: "1000", purpose: .food, editable: false)
        var i = 0
        while i < 10 {
            tableViewData.append(spendingData)
            i += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    // MARK: Private Method
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction private func addButtonTap(_ sender: Any) {
        let newSpendingData = SpendingData(placeName: "", amount: "", purpose: .other, editable: true)
        tableViewData.insert(newSpendingData, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
//        let cell = tableView.cellForRow(at: indexPath) as? SpendingTableViewCell
//        cell?.setFirstResponder()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else { return }
        let keyboardHeight = keyboardRect.size.height
        tableViewBottomConstraint.constant = keyboardHeight
        animatedLayout()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        tableViewBottomConstraint.constant = 0
        animatedLayout()
    }
    
    private func animatedLayout() {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SpendingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendingTableViewCell.reuseIdentifier(), for: indexPath) as? SpendingTableViewCell
        else {
            return SpendingTableViewCell()
        }
        
        cell.configure(tableViewData[indexPath.row])
        return cell
    }
}

extension SpendingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
