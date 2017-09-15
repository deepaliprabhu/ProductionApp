//
//  FeedbackDashboardViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 25/04/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "FeedbackDashboardViewController.h"
#import "FeedbackListViewController.h"
#import "DataManager.h"
#import "Constants.h"
#import "ServerManager.h"
#import "UIView+RNActivityView.h"


@interface FeedbackDashboardViewController ()

@end

@implementation FeedbackDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initFeedbacks) name:kNotificationFeedbacksReceived object:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.title = @"Feedback history";
    feedbackArray = [__DataManager getFeedbackList];
    [self initialiseCounts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshButtonPressed {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Feedbacks"];
    [__ServerManager getFeedbacks];
}

- (void) initFeedbacks {
    feedbackArray = [__DataManager getFeedbackList];
    [self.navigationController.view hideActivityView];
}

- (IBAction)statusPressed:(UIButton*)sender {
    FeedbackListViewController *feedbackVC = [FeedbackListViewController new];
    [feedbackVC setListType:LISTTYPESTATUS];
    [feedbackVC setSelectedIndex:sender.tag];
    [self.navigationController pushViewController:feedbackVC animated:NO];
}

- (IBAction)ownerPressed:(UIButton*)sender {
    FeedbackListViewController *feedbackVC = [FeedbackListViewController new];
    [feedbackVC setListType:LISTTYPEOWNER];
    [feedbackVC setSelectedIndex:sender.tag];
    [self.navigationController pushViewController:feedbackVC animated:NO];
}

- (IBAction)categoryPressed:(UIButton*)sender {
    FeedbackListViewController *feedbackVC = [FeedbackListViewController new];
    [feedbackVC setListType:LISTTYPECATEGORY];
    [feedbackVC setSelectedIndex:sender.tag];
    [self.navigationController pushViewController:feedbackVC animated:NO];
}

- (IBAction)productPressed:(UIButton*)sender {
    FeedbackListViewController *feedbackVC = [FeedbackListViewController new];
    [feedbackVC setListType:LISTTYPEPRODUCT];
    [feedbackVC setSelectedIndex:sender.tag];
    [self.navigationController pushViewController:feedbackVC animated:NO];
}

- (IBAction)allPressed:(id)sender {
    FeedbackListViewController *feedbackVC = [FeedbackListViewController new];
    [feedbackVC setListType:LISTTYPESTATUS];
    [feedbackVC setSelectedIndex:7];
    [self.navigationController pushViewController:feedbackVC animated:NO];
}

- (void)initialiseCounts {
    int createdCount=0,inEvalCount=0, acknowledgedCount=0,puneCount=0,lausanneCount=0,masonCount=0,sentinelCount=0,iCelsiusCount=0,receptorCount=0, cosmeticCount=0,hardwareCount=0,logicalCount=0;
    for (int i=0; i < feedbackArray.count; ++i) {
        NSMutableDictionary *feedbackData = feedbackArray[i];
        if ([feedbackData[@"Status"] isEqualToString:@"Created"]) {
            createdCount++;
        }
        else if ([feedbackData[@"Status"] isEqualToString:@"In Evaluation"]) {
            inEvalCount++;
        }
        else if ([feedbackData[@"Status"] isEqualToString:@"Acknowledged"]) {
            acknowledgedCount++;
        }
        
        if ([feedbackData[@"Owner"] isEqualToString:@"Pune"]||[feedbackData[@"Location"] isEqualToString:@"PUNE"]) {
            puneCount++;
        }
        else if ([feedbackData[@"Owner"] isEqualToString:@"Lausanne"]) {
            lausanneCount++;
        }
        else if ([feedbackData[@"Owner"] isEqualToString:@"Mason"]) {
            masonCount++;
        }
        
        if ([feedbackData[@"Product Name"] containsString:@"Sentinel"]) {
            sentinelCount++;
        }
        if ([feedbackData[@"Product Name"] containsString:@"iCelsius Wireless"]) {
            iCelsiusCount++;
        }
        if ([feedbackData[@"Product Name"] containsString:@"Receptor"]) {
            receptorCount++;
        }
        
        if ([feedbackData[@"Category"] isEqualToString:@"Cosmetic"]) {
            cosmeticCount++;
        }
        if ([feedbackData[@"Category"] isEqualToString:@"Hardware Failure"]) {
            hardwareCount++;
        }
        if ([feedbackData[@"Category"] isEqualToString:@"Logical Failure"]) {
            logicalCount++;
        }
    }
    _createdLabel.text = [NSString stringWithFormat:@"%d",createdCount];
    _inEvalLabel.text = [NSString stringWithFormat:@"%d",inEvalCount];
    _acknowledgedLabel.text = [NSString stringWithFormat:@"%d",acknowledgedCount];
    _lausanneLabel.text = [NSString stringWithFormat:@"%d",lausanneCount];
    _puneLabel.text = [NSString stringWithFormat:@"%d",puneCount];
    _masonLabel.text = [NSString stringWithFormat:@"%d",masonCount];
    _sentinelLabel.text = [NSString stringWithFormat:@"%d",sentinelCount];
    _iCelsiusLabel.text = [NSString stringWithFormat:@"%d",iCelsiusCount];
    _receptorLabel.text = [NSString stringWithFormat:@"%d",receptorCount];
    _cosmeticLabel.text = [NSString stringWithFormat:@"%d",cosmeticCount];
    _hardwareLabel.text = [NSString stringWithFormat:@"%d",hardwareCount];
    _logicalLabel.text = [NSString stringWithFormat:@"%d",logicalCount];
    [_allButton setTitle:[NSString stringWithFormat:@"All(%d)",feedbackArray.count] forState:UIControlStateNormal];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
