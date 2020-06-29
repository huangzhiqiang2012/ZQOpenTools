//
//  ZQPurchaseManager.swift
//  ZQOpenTools
//
//  Created by Darren on 2020/6/28.
//  Copyright © 2020 Darren. All rights reserved.
//

import UIKit

struct ZQProduct {
    
    let name:String
    
    let productId:String
    
    var price:String
    
    var purchased:Bool
    
    init(name:String, productId:String, price:String, purchased:Bool) {
        self.name = name
        self.productId = productId
        self.price = price
        self.purchased = purchased
    }
}

class ZQPurchaseManager: NSObject {
    
    static let shared = ZQPurchaseManager()
    
    var products:[ZQProduct] = []
    
    /// 初始化数据
    static func completeTransactionAtAppLaunch() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("--__--|| purchased: \(purchase)")
                }
            }
        }
    }
    
    /// 检查商品信息
    static func retrieveProductInfo(_ productIds: Set<String>) {
        SwiftyStoreKit.retrieveProductsInfo(productIds) { (result) in
            if let product = result.retrievedProducts.first {
                let priceStr = product.localizedPrice
                print("--__--|| product: \(product.localizedDescription), price: \(priceStr)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("--__--|| invalid product identifier: \(invalidProductId)")
            }
            else {
                print("--__--|| error: \(result.error)")
            }
        }
    }
    
    /// 通过商品id购买
    /// - Parameter id: 商品id
    static func purchaseProduct(_ id:String) {
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { (result) in
            switch result {
            case .success(let purchase):
                print("--__--|| purchase success: \(purchase.productId)")
                
                // 本地验证, 不安全, 越狱设备可能存在刷单漏洞
//                verifyReceipt(service: .production)
                
                // 服务器验证
                buyAppleProductSuccessWithPaymnetTransaction(purchase.transaction)
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("--__--|| Unknown error. Please contact support")
                case .clientInvalid:
                    print("--__--|| Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid:
                    print("--__--|| The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("--__--|| The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("--__--|| The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    print("--__--|| Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("--__--|| Could not connect to the network")
                case .cloudServiceRevoked:
                    print("--__--|| User has revoked permission to use this cloud service")
                case .privacyAcknowledgementRequired:
                    print("--__--|| Unknown error. Please contact support")
                case .unauthorizedRequestData:
                    print("--__--|| Unknown error. Please contact support")
                case .invalidOfferIdentifier:
                    print("--__--|| Unknown error. Please contact support")
                case .invalidSignature:
                    print("--__--|| Unknown error. Please contact support")
                case .missingOfferParams:
                    print("--__--|| Unknown error. Please contact support")
                case .invalidOfferPrice:
                    print("--__--|| Unknown error. Please contact support")
                default:
                    print("--__--|| Unknown error. Please contact support")
                }
            }
        }
    }
    
    /// 获取支付成功的凭证
    static func buyAppleProductSuccessWithPaymnetTransaction(_ paymentTransaction: PaymentTransaction) {
        if let receiptUrl = Bundle.main.appStoreReceiptURL {
            do {
                let receiptData = try Data(contentsOf: receiptUrl)
                let base64Str = receiptData.base64EncodedString(options: .endLineWithLineFeed)
                if let product = self.shared.products.first {
                    postProductPurchase(product, certificate: base64Str)
                }
            }
            catch {
               print("--__--|| data error")
            }
        }
    }
    
    /// 调用后端接口执行服务器验证
    static func postProductPurchase(_ product: ZQProduct, certificate: String) {
        
    }
    
    /// 本地验证（SwiftyStoreKit 已经写好的类） AppleReceiptValidator
    //  .production 苹果验证  .sandbox 本地验证
    static func verifyReceipt(service: AppleReceiptValidator.VerifyReceiptURLType) {
        let receiptValidator = AppleReceiptValidator(service: service, sharedSecret: "0aa73636a9a9445a9cc8347938957adf")
        SwiftyStoreKit.verifyReceipt(using: receiptValidator) { (result) in
            switch result {
            case .success(let receipt):
                if let status: Int = receipt["status"] as? Int {
                    print("--__--|| status = \(status)")
                    if status == 21007 {
                        verifyReceipt(service: .sandbox)
                    }
                }
            case .error(let error):
                print("--__--|| error: \(error)")
            }
        }
    }

    /// 恢复购买商品
    static func restoreProducts() {
        SwiftyStoreKit.restorePurchases(atomically: true) { (results) in
            if results.restoreFailedPurchases.count > 0 {
                print("--__--|| restore failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("--__--|| restore success: \(results.restoredPurchases)")
            }
            else {
                print("--__--|| nothing to restore")
            }
        }
    }
}


