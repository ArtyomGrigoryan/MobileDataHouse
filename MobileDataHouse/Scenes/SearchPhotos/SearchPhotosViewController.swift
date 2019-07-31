//
//  SearchPhotosViewController.swift
//  MobileDataHouse
//
//  Created by Артем Григорян on 26/07/2019.
//  Copyright (c) 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

protocol SearchPhotosDisplayLogic: class {
    func displayData(viewModel: SearchPhotos.Model.ViewModel.ViewModelData)
}

class SearchPhotosViewController: UIViewController, SearchPhotosDisplayLogic {

    // MARK: - Public variables
    
    var interactor: SearchPhotosBusinessLogic?
    var router: (NSObjectProtocol & SearchPhotosRoutingLogic & SearchPhotosDataPassing)?
    
    // MARK: - Private variables
    
    private weak var activeField: UITextField?
    
    // MARK: - @IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var photoCategoryNameTextField: UITextField!
    
    // MARK: - Object lifecycle
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: - Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = SearchPhotosInteractor()
        let presenter             = SearchPhotosPresenter()
        let router                = SearchPhotosRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        router.dataStore          = interactor
    }
  
    // MARK: - Routing
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
  
    // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar().toolbarPicker(mySelect: #selector(dismissPicker))
        
        photoCategoryNameTextField.delegate = self
        photoCategoryNameTextField.inputAccessoryView = toolbar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
    func displayData(viewModel: SearchPhotos.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .success:
            self.performSegue(withIdentifier: "FoundPhotos", sender: nil)
        case .presentFailure(let errorTitle):
            self.errorAlert(title: errorTitle)
        }
    }
    
    // MARK: - @IBActions
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let query = photoCategoryNameTextField.text!
        interactor?.makeRequest(request: SearchPhotos.Model.Request.RequestType.passUserQuery(userQuery: query))
    }
    
    // MARK: - Helpers
    
    private func errorAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "Повторите попытку.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard
            let activeField = activeField,
            let userInfo = notification.userInfo,
            let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbFrameSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.scrollRectToVisible(activeField.frame, animated: true)
    }
    
    @objc func kbDidHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}

extension SearchPhotosViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
