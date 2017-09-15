//
//  User.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __User [User sharedInstance]

@interface User : NSObject {
    int userId;
    NSString *username;
    NSString *password;
    NSString *emailId;
    NSString *role;
    NSString *dateString;
    NSTimeInterval loginTime;
}
+ (id) sharedInstance;

- (void)setUserData:(NSMutableDictionary*)userData_;
- (void)setUsername:(NSString*)username;
- (void)setPassword:(NSString*)password;
- (void)setRole:(NSString*)role_;
- (void)setLoginTime:(NSTimeInterval)loginTime_;
- (NSString*)getUsername;
- (NSString*)getPassword;
- (NSTimeInterval)getLoginTime;
- (NSString*)getRole;
- (void)setDateString:(NSString*)dateString_;
- (NSString*)getDateString;
@end
