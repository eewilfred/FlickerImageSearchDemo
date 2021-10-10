//
//  ImageSearchCollectionViewCell.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 10/10/2021.
//

import UIKit

class ImageSearchCollectionViewCell: UICollectionViewCell {

    var presentation: ImageSearchCellPresentation? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateUI() {

        guard let presentation = presentation else {
            return
        }

        if let url = URL(string: presentation.imageURLString) {
            do {
                imageView.image = UIImage(data: try Data(contentsOf: url), scale: 1)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

}

