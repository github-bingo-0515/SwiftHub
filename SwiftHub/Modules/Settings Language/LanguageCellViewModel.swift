//
//  LanguageCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 3/25/18.
//  Copyright © 2018 Sygnoos. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LanguageCellViewModel {

    let title: Driver<String>

    var language: String

    init(with language: String) {
        self.language = language
        title = Driver.just("\(displayName(forLanguage: language))")
    }
}

func displayName(forLanguage language: String) -> String {
    let local = Locale(identifier: language)
    if let displayName = local.localizedString(forIdentifier: language) {
        return displayName.capitalized(with: local)
    }
    return String()
}
