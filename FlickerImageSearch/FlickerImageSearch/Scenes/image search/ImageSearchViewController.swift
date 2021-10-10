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

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    typealias DataSource = UICollectionViewDiffableDataSource<ImageSearchPresentation.Sections, ImageSearchCellPresentation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ImageSearchPresentation.Sections, ImageSearchCellPresentation>

    private var dataSource: DataSource?

    override func viewDidLoad() {

        super.viewDidLoad()
        viewModel.delegate = self
        searchBar.delegate = self
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
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.updateUI()
            }
            return
        }
        snapshot.appendItems(presentation.imageCellPresentations, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
        updateActivityIndicator(isHidden: true)
    }

    private func updateActivityIndicator(isHidden: Bool) {

        activityIndicator.isHidden = isHidden
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

    func resetSearchResult() {
        
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteItems(presentation.imageCellPresentations)
        presentation.resetPresentation()
        dataSource?.apply(snapshot, animatingDifferences: true)
    }


    func searchResultUpdated() {

        presentation.update(state: viewModel.state)
        updateUI()
    }
}

extension ImageSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        updateActivityIndicator(isHidden: false)
        viewModel.searchImages(for: searchBar.text ?? "")
    }
}
