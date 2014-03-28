//
//  IAPHelper.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 26-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

// http://www.raywenderlich.com/21081/introduction-to-in-app-purchases-in-ios-6-tutorial

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

// Notification used to notify listeners when a product has been purchased
//UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

// Method to start buying the product
- (void)buyProduct:(SKProduct *)product;
// Method to determine if a product has been purchased
- (BOOL)productPurchased:(NSString *)productIdentifier;

- (void)restoreCompletedTransactions;

@end