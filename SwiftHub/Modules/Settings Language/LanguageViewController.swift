//
//  LanguageViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 3/25/18.
//  Copyright © 2018 Sygnoos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.languageCell.identifier

class LanguageViewController: TableViewController {

    var viewModel: LanguageViewModel!

    lazy var saveButtonItem: BarButtonItem = {
        let view = BarButtonItem(title: "",
                                 style: .plain, target: self, action: nil)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = "Language"
            self?.saveButtonItem.title = "Save"
        }).disposed(by: rx.disposeBag)

        navigationItem.rightBarButtonItem = saveButtonItem
        tableView.register(R.nib.languageCell)
        tableView.headRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(Observable.just(()),
                                    languageChanged.asObservable()).merge()
        let input = LanguageViewModel.Input(trigger: refresh,
                                            saveTrigger: saveButtonItem.rx.tap.asDriver(),
                                            selection: tableView.rx.modelSelected(LanguageCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: LanguageCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.saved.drive(onNext: { () in
            logDebug("Language changed")
        }).disposed(by: rx.disposeBag)

        output.fetching.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        output.error.drive(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }
}
