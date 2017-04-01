//
//  SlicerCellViewModelTests.swift
//  OctoPhone
//
//  Created by Josef Dolezal on 31/03/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Nimble
import Quick
@testable import OctoPhone

class SlicerCellViewModelTests: QuickSpec {
    override func spec() {
        describe("Slicer cell View Model") {
            let slicerID = "cura"
            let slicerName = "Cura"
            let isDefault = true

            var subject: SlicerCellViewModelType!

            context("provide name") {
                it("provides slicer name if it's not empty") {
                    let slicer = Slicer(ID: slicerID, name: slicerName, isDefault: isDefault)
                    subject = SlicerCellViewModel(slicer: slicer)

                    expect(subject.outputs.slicerName.value) == slicerName
                }

                it("provides placeholder text if slicer name is empty") {
                    let slicer = Slicer(ID: slicerID, name: nil, isDefault: isDefault)

                    subject = SlicerCellViewModel(slicer: slicer)

                    expect(subject.outputs.slicerName.value) == "Unknown slicer"
                }
            }
        }
    }
}
