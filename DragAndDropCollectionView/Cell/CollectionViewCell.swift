//
//  CollectionViewCell.swift
//  DragAndDropCollectionView
//
//  Created by 坂本龍哉 on 2021/10/20.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(number: Number) {
        numberLabel.text = String(number.number)
        nameLabel.text = number.name
    }
    
    func changeBackgroundColor() {
        numberLabel.backgroundColor = .systemYellow
    }

}
