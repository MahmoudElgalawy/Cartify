//
//  ProductsViewModel.swift
//  TRUSTORE
//
//  Created by mahmoud.osman on 23/01/2026.
//

import Foundation
import Combine

class ProductsViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    private let productService: ProductsServiceProtocol
    
    init(productService: ProductsServiceProtocol) {
        self.productService = productService
    }
    
    func loadProducts(limit: Int) {
           productService.fetchProducts(limit: limit)
               .sink { [weak self] completion in
                   switch completion {
                   case .finished:
                       break
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                   }
               } receiveValue: { [weak self] products in
                   self?.products = products
               }
               .store(in: &cancellables)
       }
}
