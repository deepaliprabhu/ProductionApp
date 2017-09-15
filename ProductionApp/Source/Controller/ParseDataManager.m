//
//  ParseDataManager.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 18/01/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "ParseDataManager.h"
#import "Utilities.h"


static ParseDataManager *_sharedInstance = nil;

@implementation ParseDataManager

+ (id) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [self new];
        [_sharedInstance initData];
        
    });
    
    return _sharedInstance;
}

- (void)initData {
    
}

- (void)fetchParseData:(PFQuery*)query {
    
}

- (void)saveParseData:(PFObject*)parseObject {
    //[parseObject save:^(BOOL succeeded, NSError *error) {
    BOOL succeeded = [parseObject save];
        [_delegate receivedParseData];
        if (succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving Data! Please Try Again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
   // }];
}

@end
