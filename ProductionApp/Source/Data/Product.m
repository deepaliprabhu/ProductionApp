//
//  Product.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Product.h"

@implementation Product

- (void)setProductData:(NSMutableDictionary*)productData {
    //productRevId = [productData objectForKey:@""];
    productId = [productData objectForKey:@"productId"];
    productName = [productData objectForKey:@"productName"];
}

- (void)setProductId:(NSString*)productId_ {
    productId = productId_;
}

- (void)setProductName:(NSString*)name {
    productName = name;
}

- (void)setProductRevId:(int)productRevId_ {
    productRevId = productRevId_;
}

- (int)getProductRevId {
    return productRevId;
}

- (NSString*)getProductId {
    return productId;
}

- (NSString*)getProductName {
    return productName;
}
@end
