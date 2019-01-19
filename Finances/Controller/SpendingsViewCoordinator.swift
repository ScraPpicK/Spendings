//
//  SpendingsViewCoordinator.swift
//  Finances
//
//  Created by Vadym Patalakh on 1/6/19.
//  Copyright © 2019 Vadym Patalakh. All rights reserved.
//

import MagicalRecord

enum SpendingPurpose: String, CaseIterable {
    case food = "Еда"
    case snacks = "Снэки"
    case entertainment = "Развлечения"
    case transport = "Транспорт"
    case apartment = "Дом"
    case apartmentServices = "Комуналка"
    case clothes = "Одежда"
    case other = "Другое"
    
    static func stringToPurpose(_ string: String) -> SpendingPurpose {
        var purpose = SpendingPurpose.other
        SpendingPurpose.allCases.forEach { (purposeCase) in
            if purposeCase.rawValue == string {
                purpose = purposeCase
            }
        }
        return purpose
    }
}

struct SpendingData {
    let id: String
    var placeName: String
    var amount: String
    var purpose: SpendingPurpose
    var editable: Bool
    
    init() {
        id = UUID().uuidString
        placeName = ""
        amount = ""
        purpose = .other
        editable = true
    }
    
    init(_ spending: Spending) {
        id = spending.id ?? UUID().uuidString
        self.placeName = spending.place_name ?? ""
        self.amount = spending.amount ?? ""
        let purposeString = spending.purpose ?? "Еда"
        self.purpose = SpendingPurpose.stringToPurpose(purposeString)
        self.editable = false
    }
}

class SpendingsViewCoordinator {
    // MARK: Private properties
    private weak var controller: SpendingsViewController!
    private let localContext = NSManagedObjectContext.mr_default()
    private var amountLeft = monthLimit
    
    // MARK: Public Methods
    init(controller: SpendingsViewController) {
        self.controller = controller
        let spendingsData = getSpendings()
        controller.updateTableView(spendingsData)
        let amountLeft = calculateLeftAmount(spendingsData)
        controller.update(currentLimit: amountLeft)
    }
    
    func updateOrAddSpendingIfNeeded(_ spendingData: SpendingData) {
        let spending = Spending.mr_findFirstOrCreate(byAttribute: "id", withValue: spendingData.id)
        updateAndSaveSpending(spending, withData: spendingData)
    }
    
    func deleteSpending(_ spendingData: SpendingData, completion: @escaping SuccessCompletion) {
        guard let spending = Spending.mr_findFirst(byAttribute: "id", withValue: spendingData.id) else { return }
        let deletingSuccess = spending.mr_deleteEntity(in: localContext)
        var savingSuccess = false
        localContext.mr_saveToPersistentStore { (success, error) in
            savingSuccess = success
            completion(deletingSuccess && savingSuccess)
        }
    }
    
    // MARK: Private Methods
    private func getSpendings() -> [SpendingData] {
        guard let spendings = Spending.mr_findAll() as? [Spending] else { return [SpendingData]() }
        var spendingsData = [SpendingData]()
        spendings.forEach { (spending) in
            spendingsData.append(SpendingData(spending))
        }
        spendingsData.reverse()
        return spendingsData
    }
    
    private func updateAndSaveSpending(_ spending: Spending, withData spendingData: SpendingData) {
        spending.id = spendingData.id
        spending.amount = spendingData.amount
        spending.place_name = spendingData.placeName
        spending.purpose = spendingData.purpose.rawValue
        localContext.mr_saveToPersistentStore { (success, error) in
            if success {
                self.updateLeftAmount(withSpending: Float(spendingData.amount) ?? 0)
            }
        }
    }
    
    private func updateLeftAmount(withSpending spending: Float) {
        amountLeft -= spending
        controller.update(currentLimit: amountLeft)
    }
    
    private func calculateLeftAmount(_ spendings: [SpendingData]) -> Float {
        spendings.forEach { (spending) in
            amountLeft -= Float(spending.amount) ?? 0
        }
        return amountLeft
    }
}

extension SpendingsViewCoordinator: SpendingTableViewCellDelegate {
    func spendingTableViewCellUpdatedValue(_ newValue: SpendingData) {
        updateOrAddSpendingIfNeeded(newValue)
    }
}
