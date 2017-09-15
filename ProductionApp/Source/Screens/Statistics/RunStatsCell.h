//
//  RunStatsCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RunStatsCell : UITableViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_openProcLabel;
    IBOutlet UILabel *_closedProcLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_reworkLabel;
    IBOutlet UILabel *_rejectLabel;
    IBOutlet UILabel *_defectLabel;
    IBOutlet UILabel *_processLabel;
    IBOutlet UILabel *_shippingLabel;
    IBOutlet UILabel *_sequenceLabel;
    IBOutlet UILabel *_typeLabel;
    IBOutlet UIView *_statusView;
    IBOutlet UIButton *_notesButton;
    
}

- (void)setCellData: (NSMutableDictionary*)cellData notes:(BOOL)show;
@end
