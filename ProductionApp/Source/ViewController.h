//
//  ViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 17/06/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    NSMutableArray *tableData;
}


@end

