//
//  StackingFooterViewController.swift
//  BrickKit
//
//  Created by Ruben Cagnie on 9/23/16.
//  Copyright © 2016 Wayfair LLC. All rights reserved.
//

import BrickKit

private let StickySection = "Sticky Section"
private let BuyButton = "BuyButton"
private let BuySection = "BuySection"
private let TotalLabel = "TotalLabel"

class StackingFooterViewController: BrickApp.BaseBrickController {

    override class var title: String {
        return "Stacking Footers"
    }
    override class var subTitle: String {
        return "Example how to stack footers"
    }
    
    let numberOfLabels = 50
    var repeatLabel: LabelBrick!
    var titleLabelModel: LabelBrickCellModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .brickBackground

        let layout = self.brickCollectionView.layout
        layout.zIndexBehavior = .BottomUp

        self.brickCollectionView.registerBrickClass(ButtonBrick.self)
        self.brickCollectionView.registerBrickClass(LabelBrick.self)

        let sticky = StickyFooterLayoutBehavior(dataSource: self)
        sticky.canStackWithOtherSections = true
        behavior = sticky

        let buyButton = ButtonBrick(BuyButton, backgroundColor: .brickGray1, title: "BUY") { cell in
            cell.configure()
        }

        let totalLabel = LabelBrick(TotalLabel, backgroundColor: .brickGray2, text: "TOTAL") { cell in
            cell.configure()
        }

        let section = BrickSection(bricks: [
            BrickSection(bricks: [
                LabelBrick(BrickIdentifiers.repeatLabel, width: .Ratio(ratio: 0.5), height: .Auto(estimate: .Fixed(size: 200)), backgroundColor: .lightGrayColor(), dataSource: self),
                totalLabel
                ], inset: 10, edgeInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
            BrickSection(BuySection, bricks: [
                buyButton
                ])
            ])
        section.repeatCountDataSource = self

        self.setSection(section)
    }
}

extension StackingFooterViewController: BrickRepeatCountDataSource {
    func repeatCount(for identifier: String, with collectionIndex: Int, collectionIdentifier: String) -> Int {
        if identifier == BrickIdentifiers.repeatLabel {
            return numberOfLabels
        } else {
            return 1
        }
    }
}

extension StackingFooterViewController: LabelBrickCellDataSource {
    func configureLabelBrickCell(cell: LabelBrickCell) {
        cell.label.text = "BRICK \(cell.index + 1)"
        cell.configure()
    }
}


extension StackingFooterViewController: StickyLayoutBehaviorDataSource {
    func stickyLayoutBehavior(stickyLayoutBehavior: StickyLayoutBehavior, shouldStickItemAtIndexPath indexPath: NSIndexPath, withIdentifier identifier: String, inCollectionViewLayout collectionViewLayout: UICollectionViewLayout) -> Bool {
        return identifier == BuySection || identifier == TotalLabel
    }
}
