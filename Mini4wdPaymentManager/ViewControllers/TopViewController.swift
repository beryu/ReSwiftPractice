//
//  TopViewController.swift
//  Mini4wdPaymentManager
//
//  Created by beryu on 2017/04/30.
//  Copyright © 2017 blk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import APIKit
import Result
import AlamofireImage

class TopViewController: UITableViewController {

    // MARK: - Private properties

    private var disposeBag = DisposeBag()
    fileprivate var payments: Variable<[Payment]> = Variable<[Payment]>([])
    fileprivate weak var footerView: GeneralInfoFooterView?

    // MARK: - Override methods

    override func loadView() {
        super.loadView()

        self.tableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.payments.asObservable().bind(to: tableView.rx.items(cellIdentifier: "PaymentCell")) { index, model, cell in
            guard let cell = cell as? PaymentCell else {
                return
            }
            if let itemId = model.itemId,
               let url = URL(string: "http://www.tamiya.com/japan/products/\(itemId)/top.jpg") {
                cell.thumbnailImageView.af_setImage(withURL: url)
            }
            cell.nameLabel.text = model.name
            cell.memoLabel.text = model.store
            cell.priceLabel.text = "¥\(model.price ?? 0)"
        }.disposed(by: self.disposeBag)

        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    // MARK: - Internal properties

    fileprivate func updateTotalPrice() {
        var totalPrice: Int = 0
        self.payments.value.forEach { (payment) in
            totalPrice += payment.price ?? 0
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        self.footerView?.totalPriceLabel.text = formatter.string(from: NSNumber(integerLiteral: totalPrice))
    }

    // MARK: - IBAction

    @IBAction private func editButtonWasTapped() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }

    @IBAction private func addButtonWasTapped() {
        let addPaymentVC = AddPaymentViewController()
        self.navigationController?.pushViewController(addPaymentVC, animated: true)
    }
}

extension TopViewController: StoreSubscriber {
    func newState(state: State) {
        self.payments.value = state.paymentState.payments
        self.updateTotalPrice()
    }
}

// MARK: - UITableViewDataSource

extension TopViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let nib = UINib(nibName: "GeneralInfoFooterView", bundle: nil)
        guard let view = nib.instantiate(withOwner: GeneralInfoFooterView.self, options: nil).first as? GeneralInfoFooterView else {
            return UIView()
        }
        self.footerView = view
        self.updateTotalPrice()
        return view
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 48
    }
}
