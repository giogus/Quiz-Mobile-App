//
//  QuizViewController.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Variables -
    var viewModel: QuizViewModel?
    
    // MARK: - IBOutlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var correctWordsLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var controlBackgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var controlBottomConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions -
    @IBAction func actionDidTap(_ sender: Any) {
        viewModel?.actionButtonPressed()
    }
    
}

// MARK: - Lifecycle -
extension QuizViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
}

// MARK: - Setup and UI Methods -
extension QuizViewController {
    // This method should be called when viewDidLoad is called. It's used to tweak some components styling that aren't possible to do on Interface Builder.
    func setupUI(){
        setupTableView()
        setupTextField()
        addKeyboardObservers()
    }
    
    // This method should be called when setupUI is called. It's used to change wordTextField placeholder text with some color.
    func setupTextField(){
        let placeholderColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1.0)
        wordTextField.attributedPlaceholder = NSAttributedString(string: "Insert Word", attributes: [.foregroundColor: placeholderColor])
        wordTextField.delegate = self
        wordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // This method sets the Table View Data Source and Delegate
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - TextField Delegate -

extension QuizViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.wordTextField.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(){
        guard let text = wordTextField.text else { return }
        viewModel?.didTypeWord(word: text)
    }
    
    func clearTextField(){
        self.wordTextField.text = ""
    }
    
    func focusTextField(){
        self.wordTextField.becomeFirstResponder()
    }
}

// MARK: - TableView DataSource and Delegate Methods -
extension QuizViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.correctWords.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil { cell = UITableViewCell(style: .default, reuseIdentifier: "cell") }
        cell?.textLabel?.text = viewModel?.correctWords[indexPath.row] ?? ""
        return cell ?? UITableViewCell()
    }
}

// MARK: - Alert Presentation -
extension QuizViewController {
    func showAlert(){
        let alertController = UIAlertController(
            title: viewModel?.alertModel?.title,
            message: viewModel?.alertModel?.description,
            buttonText: viewModel?.alertModel?.buttonText ?? "OK") { (action) in
                self.viewModel?.alertButtonPressed()
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Keyboard Presentation -
extension QuizViewController {
    
    // These observers will trigger the bottom view animation.
    func addKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = value.cgRectValue.height
        
        self.controlBackgroundBottomConstraint.constant = keyboardHeight
        self.controlBottomConstraint.constant = keyboardHeight
        // Necessary to make the constraint constant change smooth
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.controlBackgroundBottomConstraint.constant = 0
        self.controlBottomConstraint.constant = 0
        // Necessary to make the constraint constant change smooth
        self.view.layoutIfNeeded()
    }
}

// MARK: - ViewModel -
extension QuizViewController {
    func setupViewModel(){
        viewModel = QuizViewModel() { [unowned self] state in
            self.titleLabel.text = "\(state.titleText)   "
            self.actionButton.setTitle(state.buttonText, for: .normal)
            self.correctWordsLabel.text = state.correctWordsText
            self.timeLeftLabel.text = state.timeLeft
            if state.showAlert {
                self.showAlert()
            }
            if state.reloadTableView {
                self.tableView.reloadData()
            }
            if state.focusTextField {
                self.focusTextField()
            }
            if state.clearTextField {
                self.clearTextField()
            }
            if state.isLoading {
                self.showLoadingView()
            } else {
                self.hideLoadingView()
            }
        }
    }
}
