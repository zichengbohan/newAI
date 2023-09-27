//
//  SubcrilbeVIewModel.swift
//  AISleepStory
//
//  Created by xbm on 2023/9/25.
//

import Foundation
import StoreKit
import Combine

class SubscribeViewModel: NSObject, ObservableObject {
    @Published var appProducts:[Product] = [];
    let productIdentifiers = ["aisleepstory_month", "aisleepstory_year"]
    @Published var selectedItem: Product?;
    @Published var selectedPrice = "";
    @Published var selectedOriginPrice = "";
    @Published var displayName = "请选择订阅项";
    var selectedPublisher = PassthroughSubject<Product, Never>();
    private var cancellables: Set<AnyCancellable> = [];
    
    override init() {
        super.init();
        selectedPublisher.sink { [weak self] product in
            self?.updateSelectedProduct(with: product);
        }
        .store(in: &cancellables)
        getProductForSubscrible();
    }
    
    func getProductForSubscrible() {
        do {
            Task {
                appProducts = try await Product.products(for: productIdentifiers)
                print("appProducts", appProducts)
                if !appProducts.isEmpty {
                    updateSelectedProduct(with: appProducts.first!)
                }
            }
        } catch {}
        
    }
    
    func updateSelectedProduct(with product: Product) {
        self.selectedItem = product;
        self.selectedPrice = product.displayPrice;
        self.displayName = product.displayName;
        if product.price > 0 {
            let originValue = NSDecimalNumber(decimal: product.price).doubleValue * 2
            self.selectedOriginPrice = String(format: "%.2f", originValue)
        }
    }
}
