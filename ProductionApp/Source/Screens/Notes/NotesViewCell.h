//
//  NotesViewCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewCell : UITableViewCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UITextView *_noteTextView;
}
- (void)setCellData:(NSMutableDictionary*)cellData;
@end
