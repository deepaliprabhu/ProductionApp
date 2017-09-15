//
//  ProcessListCell.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"
#import "Process.h"

@interface ProcessListCell : SKSTableViewCell {
    IBOutlet UIView *_statusView;
}
- (void)setProcessData:(Process*)process;

@end
