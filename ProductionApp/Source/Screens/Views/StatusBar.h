//
//  StatusBar.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface StatusBar : UIView {
    IBOutlet UILabel *_usernameLabel;
    IBOutlet UILabel *_loggedInLabel;
    IBOutlet UIButton *_networkStatusButton;
    BOOL networkStatus;
}
__CREATEVIEWH(StatusBar);
- (void)initView;
- (void)setNetworkStatus:(int)status;
-(BOOL)getNetworkStatus;
@end
