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

    private var imageDownLoadTask: URLSessionDataTask?

    // MARK: Life cycle
    override func awakeFromNib() {

        super.awakeFromNib()
        layer.cornerRadius = 5.0
        addObserver()
    }

    deinit {

        NotificationCenter.default.removeObserver(self)
    }

    override func prepareForReuse() {

        super.prepareForReuse()
        imageView.image = nil
        if let urlString = presentation?.imageURLString,
           let url = URL(string: urlString) {
            ImageDownloadManager.shared.stopImageDownloadTask(url: url)
        }
    }

    // MARK: UI updates

    private func addObserver() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleImageUpdates(notification:)),
            name: .imageDownloadCompleted,
            object: nil
        )
    }

    @objc private func handleImageUpdates(notification: Notification) {

        if let imageUrl = presentation?.imageURLString,
           let image = notification.userInfo?[imageUrl] as? UIImage {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }

    private func updateUI() {

        guard let presentation = presentation else {
            return
        }

        if let url = URL(string: presentation.imageURLString) {
            if let image = ImageDownloadManager.shared.getImageForURL(url: url) {
                imageView.image = image
            }
        }
    }
}

