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

    private var failedAlert: UIAlertController?

    typealias DataSource = UICollectionViewDiffableDataSource<ImageSearchPresentation.Sections, ImageSearchCellPresentation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ImageSearchPresentation.Sections, ImageSearchCellPresentation>

    private var dataSource: DataSource?

    override func viewDidLoad() {

        super.viewDidLoad()
        viewModel.delegate = self
        searchBar.delegate = self
        configureCollectionView()
        configureLayout()
    }

    private func configureCollectionView() {

        collectionView.register(
            ImageSearchCollectionViewCell.nib,
            forCellWithReuseIdentifier: ImageSearchCollectionViewCell.identifier
        )
        collectionView.delegate = self
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

    private func triggerSearch() {

        updateActivityIndicator(isHidden: false)
        viewModel.searchImages(for: searchBar.text ?? "")
    }
}

// MARK: - ImageSearchViewModelDelegate

extension ImageSearchViewController: ImageSearchViewModelDelegate {

    func searchFailed() {

        let alert = UIAlertController(
            title: "Search Failed",
            message: "Please Try again",
            preferredStyle: .alert
        )
        let retry = UIAlertAction(title: "retry", style: .default) { _ in
            self.triggerSearch()
        }
        alert.addAction(retry)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
        failedAlert = alert
    }


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

// MARK: - UISearchBarDelegate

extension ImageSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        triggerSearch()
    }
}

// MARK: - Layout

extension ImageSearchViewController {

    private func configureLayout() {

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                let size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.absolute(
                        self.collectionView.frame.width / 2.0
                    )
                )
                let itemsPerRow = 2
                let item = NSCollectionLayoutItem(layoutSize: size)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 5,
                    leading: 5,
                    bottom: 5,
                    trailing: 5
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: size,
                    subitem: item,
                    count: itemsPerRow
                )
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        )
    }
}

// MARK: - UICollectionViewDelegate

extension ImageSearchViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {

        viewModel.updateLastViewedIndex(index: indexPath.row)
    }
}
