//
//  NetworkPrinterCollectionViewCell.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 10/05/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift

/// Network printer cell
class NetworkPrinterCollectionViewCell: UICollectionViewCell, TypedCell {

    /// Reuse identifier of cell
    static let identifier = "NetworkPrinterCollectionViewCell"

    // MARK: Public API

    /// Cell logic
    let viewModel = MutableProperty<NetworkPrinterCellViewModelType?>(nil)

    // MARK: Private properties

    /// Label for printer address
    private let addressLabel = NetworkPrinterCollectionViewCell.createLabel(fontStyle: .body)

    /// Label for printer name
    private let nameLabel = NetworkPrinterCollectionViewCell.createLabel(fontStyle: .caption1)

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(addressLabel)
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = .white

        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        addressLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(7)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(addressLabel)
            make.top.equalTo(addressLabel.snp.bottom)
        }
    }

    // MARK: Internal logic

    /// Binds available view model outputs to view
    private func bindViewModel() {
        let vm = viewModel.producer.skipNil()

        addressLabel.reactive.text <~ vm.flatMap(.latest) { return $0.outputs.address }
        nameLabel.reactive.text <~ vm.flatMap(.latest) { return $0.outputs.name }
    }

    /// Creates preconfigured label of given font size.
    ///
    /// - Parameter fontStyle: Font size of label
    /// - Returns: New label configured with given font size
    private static func createLabel(fontStyle: UIFontTextStyle) -> UILabel {
        let label = UILabel()

        label.font = .preferredFont(forTextStyle: fontStyle)

        return label
    }
}
