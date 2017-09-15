//
//  OperationsLogViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 08/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationsLogViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    
    NSString *selectedDate;
    NSMutableArray *operationsArray;
    NSMutableArray *operationDataArray;
}
- (void)setParseData:(NSMutableArray*)parseArray;
- (void)setDateString:(NSString*)dateString;

@end
