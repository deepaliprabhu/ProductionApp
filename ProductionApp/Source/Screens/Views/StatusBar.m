//
//  StatusBar.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "StatusBar.h"
#import "User.h"
#import <Instabug/Instabug.h>
#import "DataManager.h"

@implementation StatusBar

__CREATEVIEW(StatusBar, @"StatusBar", 0);

- (void)initView {
    _usernameLabel.text = [__User getUsername];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[__User getLoginTime]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSLog(@"Date: %@", dateString);
    _loggedInLabel.text = [__User getRole];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setNetworkStatus:(int)status {
    networkStatus = status;
    switch (status) {
        case 0:
            [_networkStatusButton setImage:[UIImage imageNamed:@"offline.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [_networkStatusButton setImage:[UIImage imageNamed:@"online.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)statusButtonPressed: (id)sender{
    NSString *statusMessage;
    if (networkStatus) {
        statusMessage = @"You are Online";
    }
    else {
        statusMessage = @"You are Offline";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Status" message:statusMessage delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)syncButtonPressed: (id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sync Status" message:@"Button to display sync status and sync with the server" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertView show];
    [__DataManager syncDatabase];
}

- (IBAction)feedbackButtonPressed: (id)sender{
    [Instabug invoke];
}

-(BOOL)getNetworkStatus {
    return networkStatus;
}

@end
