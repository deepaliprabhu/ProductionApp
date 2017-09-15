//
//  RunDetailsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "RunDetailsViewController.h"
#import "ProcessListViewController.h"
#import "JobsListViewController.h"
#import "DefectsListViewController.h"
#import "JobsMenuViewController.h"
#import "RunHistoryViewController.h"
#import "UIView+RNActivityView.h"
#import "DataManager.h"
#import "PartsTransferDetailViewCell.h"
#import "RunFeedbackListController.h"
#import "NotesViewController.h"
#import "PartViewCell.h"
#import "ChecklistGenViewController.h"
#import "RunPlanViewController.h"

@interface RunDetailsViewController ()

@end

@implementation RunDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Listen for keyboard appearances and disappearances
    processArray = [NSMutableArray arrayWithObjects:@"Baner_Testing", @"Soldering",@"Moulding", @"Mechanical_Assembly", @"Final_Assembly", @"Packaging",nil];
    [self getRunProcessData];

    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"b" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
    self.navigationController.navigationItem.leftBarButtonItem = btn;
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Comments.png"] style:UIBarButtonItemStylePlain target:self action:@selector(notesPressed:)];
  //  self.navigationItem.rightBarButtonItem = rightbtn;
    self.navigationController.navigationBar.hidden = true;
    
    _lastActivityLabel.text = [run getRunDate];
    partsTransferList = [__DataManager getPartsTransferList];
    feedbackArray = [run getRunFeedbacks];
    if (!feedbackArray) {
        _feedbackButton.hidden = true;
    }
    runData = [run getRunData];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = true;
    [self getRunPlan];
}

- (void)setRun:(Run*)run_ {
    NSLog(@"setting run with ID:%d",[run_ getRunId]);
    run = run_;
}

- (void)setRunData:(NSMutableDictionary*)runData_ {
    runData = runData_;
}


- (void) initView {
    self.title = [NSString stringWithFormat:@"%@",runData[@"Run"]];
    
    _runIdLabel.text = [NSString stringWithFormat:@"%@: %@",runData[@"Run"],runData[@"Product"]];
    _productIdLabel.text = runData[@"Product ID"];
    _productNameLabel.text = runData[@"Product"];
    _quantityLabel.text = runData[@"Qty"];
    _shippedLabel.text = runData[@"Shipped"];
    _readyLabel.text = runData[@"Ready"];
    _inProcessLabel.text = runData[@"Inprocess"];
    _reworkLabel.text = runData[@"Rework"];
    _rejectLabel.text = runData[@"Reject"];
    _statusLabel.text = runData[@"Status"];
    //_runDateLabel.text = runData[@"RunDate"];
    //_requestDateLabel.text = runData[@"RequestDate"];
    _priorityLabel.text = runData[@"Priority"];
    //_processNameLabel.text = runData[@"ProcessName"];
    _shippingLabel.text = runData[@"Shipping"];
    
    _productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[run getProductNumber]]];

    dataArray = [[NSMutableArray alloc] initWithObjects:@"View Checklist", nil];
    [self getPartsShort];
    [self initProcessListView];
    
   /* if (![[runData[@"Notes"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [_notesButton setBadgeEdgeInsets:UIEdgeInsetsMake(15, 0, 3, 14)];
        [_notesButton setBadgeString:@"1"];
    }*/
    NSLog(@"feedback count = %lu",(unsigned long)feedbackArray.count);
    [_feedbackButton setBadgeEdgeInsets:UIEdgeInsetsMake(15, 0, 3, 14)];
    [_feedbackButton setBadgeString:[NSString stringWithFormat:@"%d",[self getOpenFeedbacks]]];
}

- (int)getOpenFeedbacks {
    int count = 0;
    for (int i=0; i < feedbackArray.count; ++i) {
        NSMutableDictionary *feedbackData = feedbackArray[i];
        if (![feedbackData[@"Status"] isEqualToString:@"Closed"]) {
            count++;
        }
    }
    return count;
}

- (int)getProcessIndex {
    for (int i=0; i < processArray.count; ++i) {
        if ([processData[processArray[i]] intValue] > 0) {
            return i;
        }
    }
    return -1;
}

- (IBAction)showProcessList:(id)sender {
    _processListView.hidden = false;
}

- (IBAction)closeProcessList:(id)sender {
    _processListView.hidden = true;
}


- (void)initProcessListView {
    _processListView.layer.borderColor = [UIColor orangeColor].CGColor;
    _processListView.layer.borderWidth = 2.0f;
    _processListView.layer.cornerRadius = 6.0f;
    for (int i =0; i < [processArray count]; ++i) {
        UILabel *step = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+(i*25), 250, 30)];
        step.text = [NSString stringWithFormat:@"%d: %@",i+1, processArray[i]] ;
        step.textColor = [UIColor orangeColor];
        step.font = [UIFont systemFontOfSize:12.0f];
        [_processListView addSubview:step];
    }
    _processListView.hidden = true;
}

- (void)updateProcessPointer {
    _processStepsView.layer.borderColor = [UIColor orangeColor].CGColor;
    _processStepsView.layer.borderWidth = 2.0f;
    int currentProcessIndex = [self getProcessIndex];
    NSLog(@"currentProcessIndex=%d",currentProcessIndex);
    for (int i =0; i < [processArray count]; ++i) {
        UIButton *stepButton = [[UIButton alloc] initWithFrame:CGRectMake(5+(i*35), 2, 30, 30)];
        [stepButton setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [stepButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [stepButton addTarget:self action:@selector(showProcessList:) forControlEvents:UIControlEventTouchUpInside];
        if (i == currentProcessIndex) {
            [stepButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:147/255.0f blue:98/255.0f alpha:0.3f]];
        }
        [_processStepsView addSubview:stepButton];
    }
    [_pointerImageView setFrame:CGRectMake(5+(currentProcessIndex*35), _pointerImageView.frame.origin.y, _pointerImageView.frame.size.width, _pointerImageView.frame.size.height)];
}

- (void) getLastActivity {
    PFObject *runObj = (PFObject*)runData;
    NSDate *date = [runObj updatedAt];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = date;
    NSDate *endDate = [NSDate date];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    if (components.day == 1) {
        _lastActivityLabel.text = [NSString stringWithFormat:@"%ld day ago", (long)[components day]];
    }
    else if (components.day == 0) {
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitHour
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
       
        
        if (components.hour == 1) {
            _lastActivityLabel.text = [NSString stringWithFormat:@"%ld hour ago", (long)components.hour];
            
        }
        else if (components.hour == 0) {
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMinute
                                                                fromDate:startDate
                                                                  toDate:endDate
                                                                 options:NSCalendarWrapComponents];
            if (components.minute == 0) {
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitSecond
                                                                    fromDate:startDate
                                                                      toDate:endDate
                                                                     options:NSCalendarWrapComponents];
                _lastActivityLabel.text = [NSString stringWithFormat:@"%ld sec ago", (long)components.second];

            }
            else
                _lastActivityLabel.text = [NSString stringWithFormat:@"%ld mins ago", (long)components.minute];

        }
        else
            _lastActivityLabel.text = [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
    }
    else
        _lastActivityLabel.text = [NSString stringWithFormat:@"%ld days ago", (long)[components day]];
}


- (void)backPressed: (id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)startRunPressed: (id)sender
{
    JobsListViewController *jobsListVC = [[JobsListViewController alloc] initWithNibName:@"JobsListViewController" bundle:nil];
    [jobsListVC setRun:run];
    [self.navigationController pushViewController:jobsListVC animated:true];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_partDetailsTableView]) {
        return partDetailsArray.count;
    }
    else if ([tableView isEqual:_partShortTableView]) {
        return 2;
    }
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_partDetailsTableView]) {
        static NSString *simpleTableIdentifier = @"PartsTransferDetailViewCell";
        PartsTransferDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        // cell.delegate = self;
        [cell setCellData:[partDetailsArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else if ([tableView isEqual:_partShortTableView]) {
        static NSString *simpleTableIdentifier = @"PartViewCell";
        PartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
        }
        // cell.delegate = self;
        [cell setCellData:[self getPartDataForIndex:indexPath.row]];
        return cell;
    }
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.tintColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tintColor = [UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1];

   // cell.backgroundColor = [UIColor colorWithRed:253.0f/255 green:227.0f/255 blue:167.0f/255 alpha:0.7];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_partDetailsTableView]) {
    }
    else {
        ChecklistGenViewController *checklistVC = [ChecklistGenViewController new];
        [checklistVC setRun:run];
        [self.navigationController pushViewController:checklistVC animated:true];
    }

}

- (NSMutableDictionary*)getPartDataForIndex:(int)index {
    NSMutableDictionary *partData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *partShortData = partsArray[index];
    [partData setObject:partShortData[@"part"] forKey:@"PartName"];
    int stock = [self getTotalInStockForIndex:index];
    [partData setObject:[NSString stringWithFormat:@"%d",stock] forKey:@"Stock"];
    [partData setObject:[NSString stringWithFormat:@"%d",[run getQuantity]] forKey:@"Need"];
    return partData;
}

- (void)getPartsShort {
    [self.navigationController.view showActivityViewWithLabel:@"fetching activity"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/get_short_parts.php?id=%d",[run getRunId]];
    [connectionManager makeRequest:reqString withTag:3];
}

- (void)getRunProcessData {
    /*PFQuery *query = [PFQuery queryWithClassName:@"RunProcesses"];
     //[query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
     parseRunProcesses = [[query findObjects] mutableCopy];
     NSLog(@"Run Processes: %@", parseRunProcesses);*/
    [self.navigationController.view showActivityViewWithLabel:@"fetching run processes"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?call=get_run_process&id=%d",[run getRunId]];
    [connectionManager makeRequest:reqString withTag:4];
}

- (void)getDetailsForTransferId:(int)transferId {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Parts Transfer list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://www.aginova.info/aginova/json/transfer_parts_details.php\?tid=%d",transferId];
    [connectionManager makeRequest:reqString withTag:7];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    //[self.view bringSubviewToFront:_scrollView];
    [self.navigationController.view hideActivityView];
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];

    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
    }
    
    if ([json isKindOfClass:[NSArray class]]){
       // NSLog(@"json Array = %@",json);
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, json.count*21)];
        if (json.count > 0) {
            partsArray = json;
            for (int i=0; i < json.count; ++i) {
                if (tag == 3) {
                    NSDictionary *partData = json[i];
                    //NSLog(@"partdata = %@",partData);
                    partShortString = [NSString stringWithFormat:@"%@(%@)",partData[@"part"], partData[@"count"]];
                    UILabel *label = [[UILabel alloc] init];
                    label.font = [UIFont systemFontOfSize:8];
                    label.frame = CGRectMake(2, (i*19)+10, 100, 30);
                    label.text = partData[@"part"];
                    label.numberOfLines = 3;
                    if ([partData[@"color"] isEqualToString:@"yellow"]) {
                        label.textColor = [UIColor orangeColor];
                    }
                    else
                        label.textColor = [UIColor redColor];
                    [_scrollView addSubview:label];
                    
                    NSString *poString = partData[@"po"];
                    poString = [poString stringByReplacingOccurrencesOfString:@"<span >" withString:@""];
                    poString = [poString stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                    
                    UILabel *poLabel = [[UILabel alloc] init];
                    poLabel.font = [UIFont systemFontOfSize:8];
                    poLabel.frame = CGRectMake(label.frame.origin.x+label.frame.size.width+5, (i*19)+10, 30, 30);
                    poLabel.textColor = [UIColor darkGrayColor];
                    poLabel.text = partData[@"count"];
                    [_scrollView addSubview:poLabel];
                    
                    
                    /*UIButton *transferIdButton = [[UIButton alloc] initWithFrame:CGRectMake(poLabel.frame.origin.x+poLabel.frame.size.width, (i*18)+10, 60, 30)];
                    transferIdButton.font = [UIFont systemFontOfSize:10];
                    [transferIdButton setTitle:[NSString stringWithFormat:@"%d",[self getTotalInStockForIndex:i]] forState:UIControlStateNormal];
                    [transferIdButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [transferIdButton addTarget:self action:@selector(showPartsTransferDetails:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView addSubview:transferIdButton];*/
                    
                    UIButton *inStockButton = [[UIButton alloc] initWithFrame:CGRectMake(poLabel.frame.origin.x+poLabel.frame.size.width, (i*19)+10, 40, 30)];
                    inStockButton.font = [UIFont systemFontOfSize:10];
                    inStockButton.tag = i;
                    [inStockButton setTitle:[NSString stringWithFormat:@"%d",[self getTotalInStockForIndex:i]] forState:UIControlStateNormal];
                    [inStockButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [inStockButton addTarget:self action:@selector(showStockDetailView:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView addSubview:inStockButton];
                    
                    UILabel *reconciledPuneLabel = [[UILabel alloc] init];
                    reconciledPuneLabel.font = [UIFont systemFontOfSize:8];
                    reconciledPuneLabel.frame = CGRectMake(inStockButton.frame.origin.x+inStockButton.frame.size.width+10, (i*19)+10, 40, 30);
                    reconciledPuneLabel.textColor = [UIColor darkGrayColor];
                    reconciledPuneLabel.text = partData[@"RECO_PUNE"];
                    [_scrollView addSubview:reconciledPuneLabel];
                    
                    UILabel *reconciledMasonLabel = [[UILabel alloc] init];
                    reconciledMasonLabel.font = [UIFont systemFontOfSize:8];
                    reconciledMasonLabel.frame = CGRectMake(reconciledPuneLabel.frame.origin.x+reconciledPuneLabel.frame.size.width+10, (i*19)+10, 40, 30);
                    reconciledMasonLabel.textColor = [UIColor darkGrayColor];
                    reconciledMasonLabel.text = partData[@"RECO_MASON"];
                    [_scrollView addSubview:reconciledMasonLabel];
                    
                    UILabel *statusLabel = [[UILabel alloc] init];
                    statusLabel.font = [UIFont systemFontOfSize:8];
                    statusLabel.frame = CGRectMake(  reconciledMasonLabel.frame.origin.x+reconciledMasonLabel.frame.size.width, (i*19)+10, 60, 30);
                    statusLabel.textColor = [UIColor darkGrayColor];
                    NSMutableDictionary *partsTransferData = [self getPartsTranferDataForId:[partData[@"transfer id"] intValue]];
                    statusLabel.text = partsTransferData[@"Status"];
                    if (![statusLabel.text isEqualToString:@"Transferred"]) {
                        if (![poString isEqualToString:@""]) {
                            statusLabel.text = @"Purchased";
                        }
                    }
                    [_scrollView addSubview:statusLabel];

                }
                else if(tag == 4) {
                   processData = json[0];
                    [self updateProcessPointer];
                }
                else if(tag == 7) {
                    partDetailsArray = json;
                    NSMutableDictionary *partDetailData = partDetailsArray[selectedListIndex];
                    _rmaIdLabel.text = [NSString stringWithFormat:@"#%@",partDetailData[@"Transfer_id"]];
                    _runpartDetailsView.hidden = false;
                    //_tintView.hidden = false;
                    [_partDetailsTableView reloadData];
                }
            }
        }
        //NSLog(@"part short string = %@", partShortString);
    }
   // [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, 200)];
}

- (int)getTotalInStockForIndex:(int)index {
    int stock=0;
    NSMutableDictionary *partDetailData = partsArray[index];
    stock = stock+[partDetailData[@"Pune"] intValue]+[partDetailData[@"Mason"] intValue]+[partDetailData[@"Lausanne"] intValue]+[partDetailData[@"S2"] intValue];
    return stock;
}


- (void)showStockDetailView:(UIButton*)sender {
    NSMutableDictionary *partDetailData = partsArray[sender.tag];
    _inStockDetailView.frame = CGRectMake(0, 200, _inStockDetailView.frame.size.width, _inStockDetailView.frame.size.height);
    [self.view addSubview:_inStockDetailView];
    _whiteTintView.hidden = false;
    _partNameLabel.text = partDetailData[@"part"];
    _shortCountLabel.text = partDetailData[@"count"];
    _puneLabel.text = partDetailData[@"Pune"];
    _masonLabel.text = partDetailData[@"Mason"];
    _lausanneLabel.text = partDetailData[@"Lausanne"];
    _s2Label.text = partDetailData[@"S2"];
    _totalStockLabel.text = [NSString stringWithFormat:@"%d",[self getTotalInStockForIndex:sender.tag]];
    NSString *poString = partDetailData[@"po"];
    poString = [poString stringByReplacingOccurrencesOfString:@"<span >" withString:@""];
    poString = [poString stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    poString = [poString stringByReplacingOccurrencesOfString:@"(PO#" withString:@""];
    poString = [poString stringByReplacingOccurrencesOfString:@")" withString:@""];

    _poIdLabel.text = poString;
    
    [_transferIdButton setTitle:partDetailData[@"transfer id"] forState:UIControlStateNormal];
    
    
    NSMutableArray *shortRunsArray = [__DataManager getRunsWithProductId:[run getProductNumber]];
    int totalNeed = 0;
    [[_needDetailView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i< shortRunsArray.count; ++i) {
        Run *shortRun = shortRunsArray[i];
        
        UILabel *runIdLabel = [[UILabel alloc] init];
        runIdLabel.font = [UIFont systemFontOfSize:10];
        runIdLabel.frame = CGRectMake(5, (i*20), 140, 25);
        runIdLabel.textColor = [UIColor blackColor];
        runIdLabel.text = [NSString stringWithFormat:@"%d:%@",[shortRun getRunId], [shortRun getProductName]];
        [_needDetailView addSubview:runIdLabel];
        
        UILabel *qtyLabel = [[UILabel alloc] init];
        qtyLabel.font = [UIFont systemFontOfSize:10];
        qtyLabel.frame = CGRectMake(150, (i*20), 40, 25);
        qtyLabel.textColor = [UIColor darkGrayColor];
        qtyLabel.text = [NSString stringWithFormat:@"%d",[shortRun getQuantity]];
        [_needDetailView addSubview:qtyLabel];
        totalNeed = totalNeed+ [shortRun getQuantity];
    }
    _needTotalLabel.text = [NSString stringWithFormat:@"%d",totalNeed];
    _balLabel.text = [NSString stringWithFormat:@"%d",[_totalStockLabel.text intValue]-totalNeed];
}


- (IBAction)showPartsTransferDetails:(UIButton*)sender {
    NSLog(@"showPartsTransferDetails pressed");
    [self.view bringSubviewToFront:_runpartDetailsView];
    _runpartDetailsView.hidden = false;
    _tintView.hidden = false;
   // selectedListIndex = sender.tag;
    NSMutableDictionary *partsTranferData = [self getPartsTranferDataForId:[sender.titleLabel.text intValue]];
    _rmaIdLabel.text = [NSString stringWithFormat:@"#%@",partsTranferData[@"Transfer_id"]];
    [self getDetailsForTransferId:[sender.titleLabel.text intValue]];
}

- (NSMutableDictionary*)getPartsTranferDataForId:(int)transferId {
    //NSLog(@"PartstransferList=%@",partsTransferList);
    for (int i=0; i < partsTransferList.count; ++i) {
        NSMutableDictionary *partsTransferData = partsTransferList[i];
        if ([partsTransferData[@"Transfer_id"] intValue] == transferId) {
            return partsTransferData;
        }
    }
    return nil;
}

- (IBAction)notesPressed:(id)sender {
    NotesViewController *feedbackListVC = [NotesViewController new];
   // [feedbackListVC addNote:runData[@"Notes"] withTag:0 forType:NoteTypeRecord];
    [feedbackListVC setRun:run];
    [self.navigationController pushViewController:feedbackListVC animated:NO];
}

- (IBAction)feedbackPressed:(id)sender {
    RunFeedbackListController *feedbackListVC = [RunFeedbackListController new];
    if (feedbackArray.count > 0) {
        [feedbackListVC setFeedbackArray:[run getRunFeedbacks]];
    }
    [self.navigationController pushViewController:feedbackListVC animated:NO];
}

- (void)addNote:(NSString*)string{
    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    [query whereKey:@"RunId" equalTo:runData[@"RunId"]];
    //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    NSArray *objects = [query findObjects];
    
    int j=0;
    NSLog(@"objects count = %lu",(unsigned long)[objects count]);
    for (j=0; j < [objects count]; ++j) {
        PFObject *parseObject = [objects objectAtIndex:j];
        parseObject[@"Notes"] = string;
        [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Note saved successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error saving Data! Please Try Again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
}

- (IBAction)processEntryPressed {
    processEntryView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 270, 300)];
    processEntryView.backgroundColor = [UIColor whiteColor];
    processEntryView.layer.cornerRadius = 8.0f;
    processEntryView.layer.borderColor = [UIColor orangeColor].CGColor;
    processEntryView.layer.borderWidth = 2.0f;
    NSMutableDictionary *parseObject = [self getParseRunProcessForRunId:[runData[@"RunId"] intValue]];
    for (int i=0; i < processArray.count; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 35+(i*30), 200, 30)];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = processArray[i];
        [processEntryView addSubview:label];
        label.tag = i+1;
        
        UILabel *valLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 35+(i*30), 200, 30)];
        valLabel.font = [UIFont systemFontOfSize:13.0f];
        valLabel.text = [processData valueForKey:processArray[i]];
        [processEntryView addSubview:valLabel];
        valLabel.tag = i+1;
    }
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 0, 35, 35)];
    [cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [processEntryView addSubview:cancelButton];
    [self.view addSubview:processEntryView];
}


- (NSMutableDictionary*)getParseRunProcessForRunId:(int)runId {
    for (int i=0; i < parseRunProcesses.count; ++i) {
        NSMutableDictionary *parseObj = parseRunProcesses[i];
        if ([parseObj[@"RunId"] isEqualToString:[NSString stringWithFormat:@"%d",runId]]) {
            return parseObj;
        }
    }
    return nil;
}

- (IBAction)cancelPressed {
    NSLog(@"cancel pressed");
    [processEntryView removeFromSuperview];
}

- (IBAction)submitPressed {
    processEntryView.hidden = true;
    //[processEntryView removeFromSuperview];
}

- (IBAction)backPressed {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)allocatePartsPressed:(id)sender {
    _tintView.hidden = false;
    _partsAllocationView.frame = CGRectMake(self.view.frame.size.width/2-_partsAllocationView.frame.size.width/2, self.view.frame.size.height/2-_partsAllocationView.frame.size.height/2, _partsAllocationView.frame.size.width, _partsAllocationView.frame.size.height);
    [self.view addSubview:_partsAllocationView];
    [_partShortTableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        _runpartDetailsView.hidden = true;
        [_inStockDetailView removeFromSuperview];
        _tintView.hidden = true;
        _whiteTintView.hidden = true;
        [_partsAllocationView removeFromSuperview];
    }
}

- (IBAction)planPressed:(id)sender {
    RunPlanViewController *runPlanVC = [RunPlanViewController new];
    [runPlanVC setRun:run];
    [self.navigationController pushViewController:runPlanVC animated:true];
}

- (IBAction)checklistPressed:(id)sender {
    ChecklistGenViewController *checklistVC = [ChecklistGenViewController new];
    [checklistVC setRun:run];
    [self.navigationController pushViewController:checklistVC animated:true];
}

- (void)getRunPlan {
    PFQuery *query = [PFQuery queryWithClassName:@"ProductionPlan"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (objects.count > 0) {
            [self getRunCompletion:objects];
        }
    }];
}

- (void)getRunCompletion:(NSMutableArray*)operationsArray {
    int totalCount = operationsArray.count;
    int doneCount = 0;
    for (int i=0; i < operationsArray.count; ++i) {
        NSDictionary *operationData = operationsArray[i];
        if ([operationData[@"Status"] isEqualToString:@"CLOSED"]) {
            doneCount++;
        }
    }
    int percentage = (((float)doneCount/totalCount))*10;
    [self updateProgressWithValue:percentage];
    
}

- (void)updateProgressWithValue:(int)value {
    NSLog(@"value = %d",value);
    _progressLabel.text = [NSString stringWithFormat:@"%d%@",(value*10),@"%"];
    for (int i=0; i < value; ++i) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*20, 0, 20, 10)];
        view.backgroundColor = [UIColor greenColor];
        [_progressView addSubview:view];
    }
}

@end
