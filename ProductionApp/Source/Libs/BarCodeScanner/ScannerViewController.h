//
//  ViewController.h
//  iOS7_BarcodeScanner
//
//  Created by Jake Widmer on 11/16/13.
//  Copyright (c) 2013 Jake Widmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "Defines.h"

@protocol ScannerViewDelegate;
@interface ScannerViewController : UIViewController<UIAlertViewDelegate, SettingsDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
__pd(ScannerViewDelegate);

@end

@protocol ScannerViewDelegate <NSObject>
- (void) barcodeFound:(NSString*)code;
@end