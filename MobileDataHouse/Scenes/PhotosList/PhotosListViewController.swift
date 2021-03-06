//
//  PhotosListViewController.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 14/08/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol PhotosListDisplayLogic: class {
    func displayData(viewModel: PhotosList.Model.ViewModel.ViewModelData)
}

class PhotosListViewController: UICollectionViewController, PhotosListDisplayLogic, UICollectionViewDelegateFlowLayout {
  
    // MARK: - Public variables
    
    var interactor: PhotosListBusinessLogic?
    var router: (NSObjectProtocol & PhotosListRoutingLogic & PhotosListDataPassing)?
    
    // MARK: - Private variables
    
    private var photosViewModel = PhotosViewModel(cells: [])
    private var footerView = FooterCollectionReusableView()
    private var headerView = HeaderCollectionReusableView()
    private var myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Object lifecycle
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: - Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = PhotosListInteractor()
        let presenter             = PhotosListPresenter()
        let router                = PhotosListRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor
    }
    
    private func setupCollectionView() {
        collectionView.addSubview(myRefreshControl)
        collectionView.register(FooterCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: String(describing: FooterCollectionReusableView.self))
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: HeaderCollectionReusableView.self))
    }

    // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        interactor?.makeRequest(request: .getPhotos)
    }

    func displayData(viewModel: PhotosList.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhotos(let photosViewModel):
            self.photosViewModel = photosViewModel
            footerView.hideLoader()
            collectionView.reloadData()
            myRefreshControl.endRefreshing()
        case .displayFooterLoader:
            footerView.showLoader()
        case .displayAlertController(let title, let message):
            showAlert(with: title, and: message)
        }
    }
    
    // MARK: - Scroll View
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.9 {
            interactor?.makeRequest(request: .getNextPortion)
        }
    }
    
    // MARK: - Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel.cells.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosListCollectionViewCell.self),
                                                      for: indexPath) as! PhotosListCollectionViewCell
        let cellViewModel = photosViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                               withReuseIdentifier: String(describing: FooterCollectionReusableView.self),
                                                                               for: indexPath) as! FooterCollectionReusableView
            reusableView.addSubview(footerView)
            
            return reusableView
        case UICollectionView.elementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: String(describing: HeaderCollectionReusableView.self),
                                                                               for: indexPath) as! HeaderCollectionReusableView
            reusableView.addSubview(headerView)
            
            return reusableView
        default:
            preconditionFailure("Неверный тип дополнительной вью")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let xInsets: CGFloat = 10
        let cellSpacing: CGFloat = 5
        let numberOfColumns: CGFloat = 3
        let width = collectionView.frame.size.width
        
        return CGSize(width: (width / numberOfColumns) - (xInsets + cellSpacing), height: (width / numberOfColumns) - (xInsets + cellSpacing))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if photosViewModel.cells.count > 0 {
            self.collectionView.isScrollEnabled = true
            return CGSize(width: 0, height: 0)
        } else {
            self.collectionView.isScrollEnabled = false
            return CGSize(width: 1, height: self.view.frame.size.height)
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction private func clearCacheBarButtonItemPressed(_ sender: UIBarButtonItem) {
        interactor?.makeRequest(request: .clearCache)
    }
    
    @IBAction private func cancelBarButtonItemPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    private func showAlert(with title: String, and message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getPhotos)
    }
}
