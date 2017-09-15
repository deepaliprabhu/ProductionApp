//
//  RunsListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/07/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunsListCell : UITableViewCell {
    IBOutlet UILabel *_runIdLabel;
    IBOutlet UILabel *_vendorNameLabel;
    IBOutlet UILabel *_quantityLabel;
    IBOutlet UILabel *_requestDateLabel;
    IBOutlet UILabel *_seqNumLabel;
    IBOutlet UIView *_statusView;
}
- (void)setRunData:(NSMutableDictionary*)runData;


@end
