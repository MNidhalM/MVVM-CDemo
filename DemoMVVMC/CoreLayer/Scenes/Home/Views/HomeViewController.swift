//
//  HomeViewController.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit
import Combine

final class HomeViewController: Loader {
    
    // MARK: - Properties
    public var viewModel: HomeViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    var loader: UIAlertController?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    @objc func refreshData() {
        viewModel.noMoreData = false
        viewModel.fetchPaginatedAllItem(reset: true)
    }
    
    // MARK: - Outlets
    @IBOutlet private (set) weak var logoutButton: UIButton!
    @IBOutlet private (set) weak var tableView: UITableView!
    @IBOutlet private (set) weak var titleLabel: UILabel!
    @IBOutlet private (set) weak var userNameView: IDView!
    @IBOutlet private (set) weak var noMoreDataLabel: UILabel!
    @IBOutlet private (set) weak var footerView: UIView!
    @IBOutlet private (set) weak var loadMoreDataView: UIView!
    @IBOutlet private (set) weak var noMoreDataView: UIView!
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        viewModel.logoutTapped()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupUI()
        setupObservers()
        loader = loader()
        viewModel.fetchPaginatedAllItem(reset: true)
    }
}

// MARK: - Init Helpers
private extension HomeViewController {
    func setupUI() {
        logoutButton.addTarget(self, action: #selector(logoutTapped(_:)), for: .touchUpInside)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.refreshControl = refreshControl
    }
    
    func setupObservers() {
        viewModel.$finished.dropFirst().receive(on: DispatchQueue.main)
            .sink { [weak self] completedWithError in
                guard let self = self else { return }
                self.stopLoader(loader: self.loader)
            }
            .store(in: &cancellables)
        
        viewModel.sneakersDiffableDataSource = ItemTableViewDiffableDataSource(tableView: tableView, cellProvider: {[weak self] (tableView, indexPath, object) -> UITableViewCell? in
            guard let self = self else { return UITableViewCell()}
            if object.isEmpty {
                self.footerView.isHidden = true
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reuseIdentifier, for: indexPath) as? EmptyTableViewCell else { return UITableViewCell() }
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SneakerTableViewCell.reuseIdentifier, for: indexPath) as? SneakerTableViewCell else { return UITableViewCell() }
            self.footerView.isHidden = false
            cell.viewModel = SneakerTableViewCellViewModel(sneaker: object)
            return cell
        })
        
        viewModel.$finishedResetting.receive(on: RunLoop.main).sink(receiveValue: {[weak self] (finishedResetting) in
            guard let self = self else { return }
            if finishedResetting {
                self.refreshControl.endRefreshing()
            }
        }).store(in: &self.cancellables)
        
        viewModel.$finishedPagination.receive(on: RunLoop.main).sink(receiveValue: {[weak self] (finishedPagination) in
            guard let self = self else { return }
            if self.viewModel.noMoreData {
                self.showNoMoreDataView()
            } else {
                self.showLoadMoreDataView()
            }
        }).store(in: &self.cancellables)
        
    }
    
    func registerCells() {
        let cell = UINib(nibName: SneakerTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: SneakerTableViewCell.reuseIdentifier)
        
        let emptyCell = UINib(nibName: EmptyTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(emptyCell, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
    }
    
}

// MARK: -  Helpers
private extension HomeViewController {
    func showLoadMoreDataView(_ show: Bool) {
        loadMoreDataView.isHidden = show ? false : true
        noMoreDataView.isHidden = show ? true : false
    }
    
    func showLoadMoreDataView() {
        showLoadMoreDataView(true)
    }
    
    func showNoMoreDataView() {
        showLoadMoreDataView(false)
    }
    
}

// MARK: -  UITableViewDelegate
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.item < viewModel.sneakersSnapshot.numberOfItems
        else { return UITableView.automaticDimension }
        if viewModel.sneakersSnapshot.itemIdentifiers[indexPath.item].isEmpty {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if pos > tableView.contentSize.height-50 - scrollView.frame.size.height {
            self.viewModel.fetchPaginatedAllItem(reset: false)
        }
    }
}


