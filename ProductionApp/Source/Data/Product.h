//
//  Product.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Realm/Realm.h>


@interface Product : NSObject {
    int productRevId;
    NSString *productId;
    NSString *productName;
}

- (void)setProductData:(NSMutableDictionary*)productData;
- (void)setProductId:(NSString*)productId_;
- (void)setProductRevId:(int)productRevId_;
- (void)setProductName:(NSString*)name;
- (int)getProductRevId;
- (NSString*)getProductId;
- (NSString*)getProductName;
@end
