//
//  UICollectionView+TypedCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 01/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit

/// Defines interface for all cells, which are able to identify itself
protocol TypedCell {
    /// Defines project-wide unique identifier for given cell,
    /// it's used to dequeue cell from pool.
    static var identifier: String { get }
}

extension UICollectionView {

    /// Conviniet method to registed TypedCells object.
    /// Cells registered with this method may be dequeued with `dequeueTypedCell(for:)`
    /// by it's type.
    ///
    /// - Parameter cellClass: Class to be registered as collection view cell
    func registerTypedCell<Cell>(cellClass: Cell.Type) where Cell: UICollectionViewCell, Cell: TypedCell {
        register(cellClass, forCellWithReuseIdentifier: Cell.identifier)
    }

    /// Allows to safely dequeue typed cell from object pool. The type of
    /// returned cell is automatically infered.
    /// Only cells registered with `registerTypedCell(cellClass:)` should be dequeued
    /// with this method, otherwise runtime errors may occure.
    ///
    /// - Parameter indexPath: IndexPath of cell to be dequeued
    /// - Returns: Cell from object pool dequeued by it's type identifier
    func dequeueTypedCell<Cell>(for indexPath: IndexPath)
        -> Cell where Cell: UICollectionViewCell, Cell: TypedCell {
            // It's safe to force cast the cell type while the user safely registered
            return dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
    }
}
