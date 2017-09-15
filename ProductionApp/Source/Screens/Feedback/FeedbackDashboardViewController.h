//
//  FeedbackDashboardViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 25/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackDashboardViewController : UIViewController {
    IBOutlet UILabel *_createdLabel;
    IBOutlet UILabel *_inEvalLabel;
    IBOutlet UILabel *_puneLabel;
    IBOutlet UILabel *_lausanneLabel;
    IBOutlet UILabel *_sentinelLabel;
    IBOutlet UILabel *_iCelsiusLabel;
    IBOutlet UILabel *_cosmeticLabel;
    IBOutlet UILabel *_hardwareLabel;
    IBOutlet UILabel *_acknowledgedLabel;
    IBOutlet UILabel *_masonLabel;
    IBOutlet UILabel *_logicalLabel;
    IBOutlet UILabel *_receptorLabel;
    IBOutlet UIButton *_allButton;
    
    NSMutableArray *feedbackArray;
}

@end
