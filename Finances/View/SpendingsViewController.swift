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
    private var coordinator: SpendingsViewCoordinator!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator = SpendingsViewCoordinator(controller: self)
        addButton.layer.cornerRadius = 5
    }
    
    func update(currentLimit limit: Float) {
        title = String(limit)
    }
    
    func updateTableView(_ tableViewData: [SpendingData]) {
        self.tableViewData = tableViewData
        tableView.reloadData()
    }
    
    // MARK: Private Method
    @IBAction private func addButtonTap(_ sender: Any) {
        let newSpendingData = SpendingData()
        tableViewData.insert(newSpendingData, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
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
        cell.delegate = coordinator
        return cell
    }
}

extension SpendingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (_, indexPath) in
            self.tableViewData[indexPath.row].editable = true
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        editAction.backgroundColor = .orange
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let spending = self.tableViewData[indexPath.row]
            self.coordinator.deleteSpending(spending, completion: { success in
                if success {
                    self.tableViewData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
        return [deleteAction, editAction]
    }
}
