//
//  AddPaymentViewController.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/05/07.
//  Copyright © 2017年 blk. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import Eureka

class AddPaymentViewController: FormViewController, StoreSubscriber {

    // MARK: - Private properties

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Search")
            <<< IntRow("itemId") { row in
                row.title = "Item id"
                row.placeholder = "ex)15510, 95100, ..."
                row.cell.textField.rx.text
                    .throttle(1.5, latest: true, scheduler: MainScheduler.instance)
                    .subscribe(onNext: { (text) in
                        // Fetch part info
                        guard let itemId = self.form.rowBy(tag: "itemId")?.baseValue as? Int, itemId > 0 else {
                            return
                        }
                        store.dispatch(FetchPartAction(id: "\(itemId)"))
                    })
                    .disposed(by: self.disposeBag)
                let formatter = NumberFormatter()
                formatter.numberStyle = .none
                formatter.groupingSize = 0
                row.formatter = formatter
            }
        +++ Section("Payment Information")
            <<< TextRow("name") { row in
                row.title = "Title"
                row.placeholder = "ミニ四駆モーターケース"
            }
            <<< IntRow("price") { row in
                row.title = "Price (yen)"
                row.placeholder = "324"
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.groupingSeparator = ","
                formatter.groupingSize = 3
                row.formatter = formatter
            }
            <<< PushRow<String>("store") { row in
                row.title = "Store / Circuit"
                row.selectorTitle = "Pick store or circuit"
                row.options = ["yodobashi.com",
                               "Amazon.co.jp",
                               "フォースラボ",
                               "TPF新橋",
                               "ヨドバシ実店舗",
                               "その他サーキット",
                               "その他ショップ"]
            }
            <<< DateRow("date") { row in
                row.title = "Date"
                row.value = Date()
            }
        +++ Section()
            <<< ButtonRow() { row in
                row.title = "Save"
                row.onCellSelection({ (cell, row) in
                    store.dispatch(
                        AddPaymentAction(id: UUID().uuidString,
                                         itemId: "\(self.form.rowBy(tag: "itemId")?.baseValue as? Int ?? 0)",
                                         name: self.form.rowBy(tag: "name")?.value,
                                         price: (self.form.rowBy(tag: "price")?.baseValue as? Int) ?? 0,
                                         store: self.form.rowBy(tag: "store")?.value,
                                         date: self.form.rowBy(tag: "date")?.value))
                    self.navigationController?.popViewController(animated: true)
                })
            }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: - StoreSubscriber

    func newState(state: State) {
        if let name = state.partState.name {
            let row = self.form.rowBy(tag: "name")
            row?.baseValue = name
            row?.updateCell()
        }
        if let price = state.partState.price {
            let row = self.form.rowBy(tag: "price")
            row?.baseValue = price
            row?.updateCell()
        }
    }
}
