//
//  FoundPhotosViewController.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol FoundPhotosDisplayLogic: class {
    func displayData(viewModel: FoundPhotos.Model.ViewModel.ViewModelData)
}

class FoundPhotosViewController: UITableViewController, FoundPhotosDisplayLogic {

    // MARK: - Public variables
    
    var interactor: FoundPhotosBusinessLogic?
    var router: (NSObjectProtocol & FoundPhotosRoutingLogic & FoundPhotosDataPassing)?
    
    // MARK: - Private variables
    
    private lazy var footerView = FooterView()
    private var photosViewModel = PhotosViewModel(cells: [])
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
        let interactor            = FoundPhotosInteractor()
        let presenter             = FoundPhotosPresenter()
        let router                = FoundPhotosRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor
    }
  
    private func setupTableView() {
        tableView.addSubview(myRefreshControl)
        tableView.tableFooterView = footerView
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        interactor?.makeRequest(request: .getPhotos)
    }
  
    func displayData(viewModel: FoundPhotos.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayPhotos(let photosViewModel):
            self.photosViewModel = photosViewModel
            footerView.hideLoader()
            tableView.reloadData()
            myRefreshControl.endRefreshing()
        case .displayFooterLoader:
            footerView.showLoader()
        case .displayFailure(let error):
            errorAlert(title: error)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextPortion)
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosViewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FoundPhotosTableViewCell.self), for: indexPath) as! FoundPhotosTableViewCell
        let cellViewModel = photosViewModel.cells[indexPath.row]
       
        cell.set(viewModel: cellViewModel)
        
        return cell
    }
    
    // MARK: - Helpers
    
    private func errorAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "Повторите попытку.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getPhotos)
    }
}
