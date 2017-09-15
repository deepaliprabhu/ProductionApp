//
//  BaseViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 09/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusBar.h"

@interface BaseViewController : UIViewController {
    StatusBar *statusBar;
}

-(void)showLoadingView;
-(void)hideLoadingView;
- (BOOL)isNetworkReachable;
@end
