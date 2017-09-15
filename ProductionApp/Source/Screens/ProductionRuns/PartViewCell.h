//
//  PartViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 20/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartViewCell : UITableViewCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIButton *_needButton;
    IBOutlet UIButton *_stockButton;
    IBOutlet UIButton *_lockButton;
    IBOutlet UIView *_needView;
    IBOutlet UIView *_stockView;
    BOOL locked;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
