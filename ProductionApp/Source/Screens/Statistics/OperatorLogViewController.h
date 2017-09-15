//
//  OperatorLogViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 07/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatorLogViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    NSMutableArray *operatorsArray;
    NSMutableArray *operationsArray;
    NSMutableArray *operatorDataArray;
    
    NSString *selectedDate;
}
- (void)setParseData:(NSMutableArray*)parseArray;
- (void)setDateString:(NSString*)dateString;
@end
