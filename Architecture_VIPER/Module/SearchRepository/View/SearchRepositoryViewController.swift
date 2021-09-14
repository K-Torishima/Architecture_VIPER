//
//  SearchRepositoryViewController.swift
//  Architecture_VIPER
//
//  Created by 鳥嶋 晃次 on 2021/08/16.
//

import UIKit

// ViewControllerはUIのことしかしない
// 基本的には、Presenterからの指示を受ける

class SearchRepositoryViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mainIndicator: UIActivityIndicatorView!
    
    var presenter: SearchRepositoryPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        let headerView = UIView(frame: CGRect(x: .zero, y: .zero, width: view.frame.width, height: 16))
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(cellClass: SearchRepositoryCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SearchRepositoryViewController : SearchRepositoryPresenterOutput {
    func showProgressDidLoad() {
        print("fetch start")
        mainIndicator.startAnimating()
        tableView.isHidden = true
    }
    
    func hideProgressDidLoad() {
        print("fetch end")
        mainIndicator.stopAnimating()
    }
    
    func showData() {
        tableView.isHidden = presenter.numberOfRows > 0 ? false : true
        tableView.reloadData()
    }
}

extension SearchRepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: SearchRepositoryCell.self, forIndexPath: indexPath)
        cell.configre(entity: presenter.getRepository(forRow: indexPath.row))
        return cell
    }
}
