//
//  AddDefectViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysSlideMenu.h"
#import "NIDropDown.h"
#import "JSImagePickerViewController.h"
#import "Defect.h"
#import "DefectsStatCell.h"
#import "BaseViewController.h"
#import "Process.h"

@interface AddDefectViewController : BaseViewController <UITextViewDelegate, NIDropDownDelegate,JSImagePickerViewControllerDelegate,UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITextView *_titleTextView;
    IBOutlet UITextView *_detailTextView;
    IBOutlet UIButton *defectTypeButton;
    IBOutlet UIImageView *imageView1;
    IBOutlet UIImageView *imageView2;
    IBOutlet UIImageView *imageView3;
    IBOutlet UIImageView *_arrowImageView;
    IBOutlet UIImageView *_photoImageView;
    IBOutlet UILabel *_timesFoundLabel;
    IBOutlet UIView *_statsView;
    IBOutlet UIView *_photoView;
    IBOutlet UIView *_photoHolderView;
    IBOutlet UITableView *_tableView;
    
    UIView *backgroundDimmingView;

    BOOL historyVisible;
    int photosAdded;
    int selectedJobType;
    NSArray *defectTypeArray;
    NSArray *defectTypeImgArray;
    NSMutableArray *selectedJobs;
    
    NIDropDown *dropDown;
    Defect *defect;
    Process *process;
}
@property (nonatomic,strong) UzysSlideMenu *uzysSMenu;
- (IBAction)actionMenu:(id)sender;
- (void)setDefect:(Defect*)defect_;
- (void)setProcess:(Process*)process_;
- (void)setJobs:(NSMutableArray*)jobs;
@end
