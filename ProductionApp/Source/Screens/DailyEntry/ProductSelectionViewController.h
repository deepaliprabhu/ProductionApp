//
//  ProductSelectionViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/03/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"


@interface ProductSelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    
    DZNSegmentedControl *control;

    NSMutableArray *productsArray;
    NSMutableArray *productGroupArray;
    NSMutableArray *filteredArray;
    
    int tag;
}
- (void)setTag:(int)tag_;
@end