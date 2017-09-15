//
//  ParseDataManager.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Defines.h"

@protocol ParseDataManagerProtocol;
#define __ParseDataManager [ParseDataManager sharedInstance]

@interface ParseDataManager : NSObject {
    NSMutableArray *openRuns;
}
+ (id) sharedInstance;
__pd(ParseDataManagerProtocol);
- (void)fetchParseData:(PFQuery*)query;
- (void)saveParseData:(PFObject*)parseObject;
@end

@protocol ParseDataManagerProtocol <NSObject>
@optional
- (void) displayErrorWithMessage:(NSString*)errorMessage;
- (void) receivedParseData:(NSMutableArray*)parseData;
- (void) receivedParseData;

@end