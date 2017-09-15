//
//  StatsViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController  {
    IBOutlet UILabel *_openRunsLabel;
    IBOutlet UILabel *_defectsLabel;
    IBOutlet UILabel *_rmasLabel;
    IBOutlet UILabel *_demandsLabel;
    IBOutlet UILabel *_feedbacksLabel;
    IBOutlet UIScrollView *_scrollView;
    NSMutableArray *parseRuns;
}

@end
