//
//  Utilities.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "Utilities.h"
#import "Datatify.h"

@implementation Utilities
+(BOOL)isNetworkReachable {
    // Initialize Reachability
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reachability.reachableBlock = ^(Reachability *reachability) {
        NSLog(@"Network is reachable.");
        //return true;
    };
    
    reachability.unreachableBlock = ^(Reachability *reachability) {
        NSLog(@"Network is unreachable.");
    };
    
    return [reachability isReachable];
}

@end

