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
        coordinator.updateOrAddSpendingIfNeeded(newSpendingData)
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
        
        cell.delegate = coordinator
        return cell
    }
}

extension SpendingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SpendingTableViewCell else { return }
        cell.configure(tableViewData[indexPath.row])
    }
}
