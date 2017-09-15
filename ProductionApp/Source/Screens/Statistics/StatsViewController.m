//
//  StatsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 24/12/15.
//  Copyright © 2015 Aginova. All rights reserved.
//

#import "StatsViewController.h"
#import "OpenRunsStatsViewController.h"
#import "DailyStatsViewController.h"
#import "HistoryStatsViewController.h"
#import "ShipmentStatsViewController.h"
#import "ServerManager.h"
#import "UIView+RNActivityView.h"
#import "DataManager.h"
#import "Utilities.h"
#import "Constants.h"
#import "DemandListViewController.h"
#import "StockViewController.h"
#import "ShipmentDashboardViewController.h"
#import "RMADashboardViewController.h"
#import "FeedbackDashboardViewController.h"
#import "Defines.h"
#import "DailyLogDashboardViewController.h"


@interface StatsViewController ()

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, 640)];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRuns) name:kNotificationRunsReceived object:nil];
    [center addObserver:self selector:@selector(initRMAs) name:kNotificationRmasReceived object:nil];
    [center addObserver:self selector:@selector(initDemands) name:kNotificationDemandsReceived object:nil];
    [center addObserver:self selector:@selector(initFeedbacks) name:kNotificationFeedbacksReceived object:nil];

    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    self.title = @"Statistics";
    parseRuns = [[NSMutableArray alloc] init];
    if ([__DataManager getRuns].count > 0) {
        [self initRuns];
    }
    else {
       [__ServerManager getRunsList];
    }
    
    if ([__DataManager getDemandList].count > 0) {
        [self initRMAs];
        [self initDemands];
        [self initFeedbacks];
    }
    else {
        [__ServerManager getRMAs];
        [__ServerManager getDemands];
        [__ServerManager getPartsTransfer];
        __after(5, ^{
            [__ServerManager getFeedbacks];
        });
    }
}

- (void) initRuns {
    parseRuns = [__DataManager getRuns];
    _openRunsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[__DataManager getRuns].count];
    //[self.navigationController.view hideActivityView];
}

- (void) initRMAs {
    NSLog(@"RMAs received");
    _rmasLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[__DataManager getRMAList].count];
    //[self.navigationController.view hideActivityView];
}

- (void) initDemands {
    _demandsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[__DataManager getDemandList].count];
    //[self.navigationController.view hideActivityView];
}

- (void) initFeedbacks {
    _feedbacksLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[__DataManager getFeedbackList].count];
    [self.navigationController.view hideActivityView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchParseRuns {
    
        PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
        /*if (![Utilities isNetworkReachable]) {
            [query fromLocalDatastore];
        }
        else{
            [PFObject unpinAllObjects];
        }*/
        //[query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
        [query whereKey:@"Status" notEqualTo:@"Closed"];
        [query orderByDescending:@"RunId"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error) {
                [self.navigationController.view hideActivityView];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            int i, quantity = 0, reworks = 0, rejects=0;
            NSLog(@"objects runs count = %lu",(unsigned long)[objects count]);
            /*for (int i=0; i < [[__DataManager getRuns] count]; ++i) {
                Run *run = [[__DataManager getRuns] objectAtIndex:i];

                for (int j=0; j < [objects count]; ++j) {
                    PFObject *parseRun = [objects objectAtIndex:j];

                    if ([run getRunId] == [parseRun[@"RunId"] intValue]) {
                        [parseRuns addObject:parseRun];
                    }
                }
            }*/
            parseRuns = [objects mutableCopy];
            _openRunsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)parseRuns.count];
            [__DataManager saveParseRuns:parseRuns];
            [self.navigationController.view hideActivityView];
        }];
}


- (IBAction)openRunsPressed:(id)sender {
    OpenRunsStatsViewController *statsVC = [OpenRunsStatsViewController new];
    [statsVC setParseData:parseRuns];
    [self.navigationController pushViewController:statsVC animated:true];
}

- (IBAction)dailyStatsPressed:(id)sender {
    DailyLogDashboardViewController *dailyStatsVC = [DailyLogDashboardViewController new];
   // [dailyStatsVC setTag:2];
    [self.navigationController pushViewController:dailyStatsVC animated:true];
}

- (IBAction)shipmentPressed:(id)sender {
    ShipmentDashboardViewController *shipmentVC = [ShipmentDashboardViewController new];
    [self.navigationController pushViewController:shipmentVC animated:true];
}

- (IBAction)historyPressed:(id)sender {
    HistoryStatsViewController *historyVC = [HistoryStatsViewController new];
    [self.navigationController pushViewController:historyVC animated:true];
}

- (IBAction)rmaPressed:(id)sender {
    RMADashboardViewController *rmaListVC = [RMADashboardViewController new];
    [self.navigationController pushViewController:rmaListVC animated:true];
}

- (IBAction)demandPressed:(id)sender {
    DemandListViewController *demandVC = [DemandListViewController new];
    [self.navigationController pushViewController:demandVC animated:true];
}

- (IBAction)stockPressed:(id)sender {
    StockViewController *stockVC = [StockViewController new];
    [self.navigationController pushViewController:stockVC animated:true];
}

- (IBAction)feedbackPressed:(id)sender {
    FeedbackDashboardViewController *feedbackListVC = [FeedbackDashboardViewController new];
    [self.navigationController pushViewController:feedbackListVC animated:true];
}

@end
