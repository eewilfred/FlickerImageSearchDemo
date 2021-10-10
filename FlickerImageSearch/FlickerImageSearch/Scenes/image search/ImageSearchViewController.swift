//
//  ViewController.swift
//  FlickerImageSearch
//
//  Created by Edwin Wilson on 09/10/2021.
//

import UIKit

class ImageSearchViewController: UIViewController {

    let viewModel = ImageSearchViewModel()
    var presentation = ImageSearchPresentation()

    @IBOutlet weak var collectionView: UICollectionView!

    typealias DataSource = UICollectionViewDiffableDataSource<ImageSearchPresentation.Sections, ImageSearchCellPresentation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ImageSearchPresentation.Sections, ImageSearchCellPresentation>

    private var dataSource: DataSource?

    override func viewDidLoad() {

        super.viewDidLoad()
        viewModel.delegate = self
        configureCollectionView()
    }

    private func configureCollectionView() {

        collectionView.register(
            ImageSearchCollectionViewCell.nib,
            forCellWithReuseIdentifier: ImageSearchCollectionViewCell.identifier
        )
        dataSource = makeDataSource()

        guard let data = dataSource else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        data.apply(snapshot, animatingDifferences: false)
    }

    private func updateUI() {

        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems(presentation.imageCellPresentations, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - support

    private func makeDataSource() -> DataSource {

        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellPresentation) in

            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageSearchCollectionViewCell.identifier,
                for: indexPath
            ) as? ImageSearchCollectionViewCell {
                cell.presentation = cellPresentation
                return cell
            } else {
                return UICollectionViewCell()
            }
        })
    }
}

// MARK: - ImageSearchViewModelDelegate

extension ImageSearchViewController: ImageSearchViewModelDelegate {

    func searchResultUpdated(photosReceived: [Photo]?, shouldReset: Bool) {

        presentation.update(photos: photosReceived, shouldReset: shouldReset)
        updateUI()
    }
}
