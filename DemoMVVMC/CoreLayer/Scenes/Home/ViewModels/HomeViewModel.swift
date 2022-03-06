//
//  HomeViewModel.swift
//  DemoMVVMC
//
//  Created by mac on 25/2/2022.
//

import UIKit
import Combine

class ItemTableViewDiffableDataSource: UITableViewDiffableDataSource<String?, Sneaker> {}

final class HomeViewModel {
    private var userViewModel: UserViewModel
    private let sneakerStore: SneakerStore
    public weak var coordinatorDelegate : HomeViewModelCoordinatorDelegate?
    // MARK: - PROPRIETIES
    var cancellables: Set<AnyCancellable> = []
    //handle table state
    var currentPage: Int = 0
    var noMoreData: Bool = false // pagination and no more data found on the server
    @Published var finishedResetting: Bool = true //pull to refresh
    @Published var finishedPagination: Bool = true
    @Published var finished: Bool = false
    
    //DiffableDataSource
    var sneakersDiffableDataSource: ItemTableViewDiffableDataSource?
    var sneakersSnapshot = NSDiffableDataSourceSnapshot<String?, Sneaker>()
    
    var sneakersArray: [Sneaker]?
    var sneaker: Sneaker = Sneaker()
    
    init(userViewModel: UserViewModel, sneakerStore: SneakerStore) {
        self.userViewModel = userViewModel
        self.sneakerStore = sneakerStore
    }
    
}

extension HomeViewModel {
    /// update snapshot
    func getData() {
        guard let sneakersArray = sneakersArray else { return }
        sneakersSnapshot.deleteAllItems()
        sneakersSnapshot.appendSections([""])
        sneakersSnapshot.appendItems(sneakersArray)
        guard let sneakersDiffableDataSource = sneakersDiffableDataSource else { return }
        sneakersDiffableDataSource.apply(sneakersSnapshot, animatingDifferences: true)
    }
    
}

extension HomeViewModel {
    public func fetchPaginatedAllItem(reset: Bool = false) {
        guard canStartFetch() else {
            return
        }
        
        if reset {
            finishedResetting = false
            currentPage = 0
            noMoreData = false
        }
        else {
            finishedPagination = false
            
            if noMoreData {
                return
            }
            currentPage += 1
        }
        
        sneakerStore.fetchWithPagination(page : currentPage).receive(on: RunLoop.main)
            .sink { [weak self] (completed) in
                self?.handleCompletion(reset: reset,completion: completed)
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                let sneakers = response.sneakers
                let allCount = response.count
                let newCount = sneakers.count
                let previousCount = self.sneakersArray?.count ?? 0
                /*
                 print("****************************")
                 print("allCount: \(allCount)")
                 print("newCount: \(newCount)")
                 print("previousCount: \(previousCount)")
                 print("currentPage: \(self.currentPage)")
                 print("---------------------------")
                 */
                self.noMoreData = (allCount == (newCount + previousCount)) ? true: false
                
                // if list is empty => isEmpty = true => show empty cell
                if sneakers.isEmpty && self.currentPage == 0 {
                    let  emptyModel = Sneaker()
                    self.sneakersArray = [emptyModel]
                    self.getData()
                    return
                }
                
                //handle no more data
                if self.currentPage == 0 {
                    self.sneakersArray = sneakers
                } else {
                    self.sneakersArray?.append(contentsOf: sneakers)
                }
                
                self.getData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helpers
    private func canStartFetch() -> Bool {
        guard finishedPagination, finishedResetting else {
            return false
        }
        return true
    }
    
    private func handleCompletion(reset: Bool,completion: Subscribers.Completion<Error>) {
        finishedResetting = true
        finishedPagination = true
        finished = true
        switch completion {
        case .finished:
            break
        case .failure(let error):
            let  emptyModel = Sneaker()
            sneakersArray = [emptyModel]
            getData()
            debugPrint(error.localizedDescription)
        }
    }
    
}

// MARK: - Navigation
extension HomeViewModel {
    func logoutTapped() {
        coordinatorDelegate?.logout()
    }
}
