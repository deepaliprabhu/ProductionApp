//
//  User.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "User.h"

static User *_sharedInstance = nil;

@implementation User

+ (id) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [self new];
        
    });
    
    return _sharedInstance;
}

- (void)setUserData:(NSMutableDictionary*)userData {
    userId = [[userData objectForKey:@"userId"] intValue];
    username = [userData objectForKey:@"name"];
    password = [userData objectForKey:@"password"];
}

- (void)setUsername:(NSString*)username_ {
    username = username_;
}

- (void)setLoginTime:(NSTimeInterval)loginTime_ {
    loginTime = loginTime_;
}

- (void)setRole:(NSString*)role_ {
    role = role_;
}

- (NSString*)getUsername {
    return username;
}

- (NSString*)getPassword {
    return password;
}

- (NSTimeInterval)getLoginTime {
    return loginTime;
}

- (NSString*)getRole {
    return role;
}

- (void)setDateString:(NSString*)dateString_ {
    NSLog(@"datestring set:%@",dateString_);
    dateString = dateString_;
}

- (NSString*)getDateString {
    return dateString;
}
@end
