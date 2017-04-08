//
//  Disposable+CompositeDisposable.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 08/04/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import ReactiveSwift

extension Disposable {
    /// Adds `self` to given composite disposable.
    ///
    /// - Parameter compositeDisposable: Composite disposable where should be `self` added to.
    /// - Returns: Handle which allows to remove `self` from composite disposable.
    @discardableResult
    func addTo(compositeDisposable: CompositeDisposable) -> CompositeDisposable.DisposableHandle {
        return compositeDisposable.add(self)
    }
}
