//
//  PictureListView.swift
//  Picsum
//
//  Created by Megi Sila on 3.12.22.
//

import UIKit

class PictureListView: UIViewController {
    var collectionView: UICollectionView!

    lazy var viewModel = {
        PictureListViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: flowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: "pictureCell")
    }
    
    private func flowLayout() -> UICollectionViewFlowLayout {
        let width = view.frame.size.width
        let padding: CGFloat = 10
        let itemWidth = (width / 2) - 1.5 * padding
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return flowLayout
    }

    func setupViewModel() {
        viewModel.getPictures()
        
        // Reload collectionView
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PictureListView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDataSource
extension PictureListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pictureCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath as IndexPath) as! PictureCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        navigationController?.pushViewController(PictureView(model: cellVM), animated: true)
    }
}
