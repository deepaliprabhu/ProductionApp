//
//  OperatorDashboardViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 30/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatorDashboardViewController : UIViewController {
    IBOutlet UICollectionView *_collectionView;
    
    NSMutableArray *operatorArray;
    NSMutableArray *operationsArray;
    NSMutableArray *operatorDataArray;
    
    NSString *startDateString;
    NSString *endDateString;
}

@end
