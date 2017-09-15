//
//  ProcessFlowViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 10/08/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ProcessFlowViewController.h"
#import "UIView+RNActivityView.h"
#import "ConnectionManager.h"
#import "DataManager.h"

@interface ProcessFlowViewController ()

@end

@implementation ProcessFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _addProcessView.layer.borderColor = [UIColor orangeColor].CGColor;
    _addProcessView.layer.borderWidth = 1.0f;
    _addProcessView.layer.cornerRadius = 6.0f;
    
    processesArray = [[NSMutableArray alloc] init];
    selectedProcessesArray = [[NSMutableArray alloc] init];
    commonProcessesArray = [__DataManager getCommonProcesses];
    stationsArray = [NSMutableArray arrayWithObjects:@"0-Non Line",@"1-Inward Testing", @"2-Soldering",@"3-Mechanical Assembly",@"4-Final Inspection", @"5-Cleaning & Packaging", @"6-Moulding", @"7-Other",nil];
    if (!commonProcessesArray) {
        [self getProcessList];
    }
    [self getProcessFlow];
    self.title = product[@"Name"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightButtonPressed)];
    saveOptionsArray = [NSMutableArray arrayWithObjects:@"Save in Current Version", @"Save as New Version",nil];
    statusOptionsArray = [NSMutableArray arrayWithObjects:@"OPEN", @"APPROVED",nil];
    
    originatorArray = [NSMutableArray arrayWithObjects:@"Arvind", @"Sumit",nil];
    approverArray = [NSMutableArray arrayWithObjects:@"Arvind", @"Matt", @"Vally",nil];
    _statusButton.layer.cornerRadius = 4.0f;
    [_pickOriginatorButton setTitle:@"Arvind" forState:UIControlStateNormal];
    [_pickApproverButton setTitle:@"Vally" forState:UIControlStateNormal];
}

- (void)rightButtonPressed {
    [self showPopUpWithTitle:@"Select Option" withOption:saveOptionsArray xy:CGPointMake(16, 60) size:CGSizeMake(287, 280) isMultiple:NO];
    dropDownList.tag = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addProcessPressed:(id)sender {
    _addProcessView.frame = CGRectMake(self.view.frame.size.width/2-_addProcessView.frame.size.width/2, self.view.frame.size.height/2-_addProcessView.frame.size.height/2, _addProcessView.frame.size.width, _addProcessView.frame.size.height);
    [self.view addSubview:_addProcessView];
}

- (IBAction)pickStationPressed:(id)sender {
    if(dropDown == nil) {
        _tintView.hidden = false;
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :stationsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 1;
        // selectedTag = 3;
        dropDown.delegate = self;
    }
    else {
        _tintView.hidden = true;
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickOriginatorPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :originatorArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 2;
        // selectedTag = 3;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickApproverPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :approverArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 3;
        // selectedTag = 3;
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}


- (void) selectedListIndex:(int)index {
    switch (dropDown.tag) {
        case 1:
            selectedStation = index;
            break;
        case 2:{
        }
            
            break;
        case 3: {
        }
            break;
        default:
            break;
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

-(IBAction)pickProcessPressed:(id)sender {
    [self showPopUpWithTitle:@"Select Option" withOption:processNamesArray xy:CGPointMake(16, 60) size:CGSizeMake(287, 380) isMultiple:YES];
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (void)getProcessList {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Process list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:@"http://aginova.info/aginova/json/processes.php?call=getProcessList" withTag:1];
}

- (void)addProcessToList:(NSMutableDictionary*)processData {
    [self.navigationController.view showActivityViewWithLabel:@"Adding new process"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=addProcess&processno=%@&processname=%@&desc=%@&wi=%@&stationid=%@",processData[@"ProcessNo"], [self urlEncodeUsingEncoding:processData[@"ProcessName"]],@"",@"", processData[@"StationId"]] withTag:2];
}

- (void)getProcessFlow {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Process Flow"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=getProcessFlow&process_ctrl_id=%@-%@",product[@"Product Number"], @"PC1"] withTag:3];
}

- (void)deleteProcessFromListAtIndex:(int)index {
    NSMutableDictionary *processData = processesArray[index];
    [self.navigationController.view showActivityViewWithLabel:@"deleting process"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=delFlowProcess&processno=%@&process_ctrl_id=%@",processData[@"processno"],processCntrlId] withTag:4];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    dropDownList = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    dropDownList.delegate = self;
    [dropDownList showInView:self.view animated:YES];
    [dropDownList SetBackGroundDropDown_R:244 G:75.0 B:39.0 alpha:0.80];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    if (dropDownList.tag == 2) {
        if (anIndex == 0) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-dd-MM"];
            NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",product[@"Product Number"],@"PC1"],@"process_ctrl_id",[NSString stringWithFormat:@"%@_%@",product[@"Name"], @"PC1"], @"process_ctrl_name",product[@"Product Id"],@"ProductId",_versionLabel.text, @"VersionId", _statusButton.titleLabel.text, @"Status", _pickOriginatorButton.titleLabel.text, @"Originator", _pickApproverButton.titleLabel.text, @"Approver", _commentsTextView.text,@"Comments", @"", @"Description",[dateFormat stringFromDate:[NSDate date]], @"Timestamp" , nil];
            [__DataManager syncProcesses:selectedProcessesArray withProcessData:processData];
        }
        else {
            _versionEntryView.layer.borderColor = [UIColor orangeColor].CGColor;
            _versionEntryView.layer.borderWidth = 1.0f;
            _versionEntryView.frame = CGRectMake(self.view.frame.size.width/2-_versionEntryView.frame.size.width/2, self.view.frame.size.height/2-_versionEntryView.frame.size.height/2, _versionEntryView.frame.size.width, _versionEntryView.frame.size.height);
            [self.view addSubview:_versionEntryView];
        }
    }
    else {
        if (anIndex == 0) {
            [_statusButton setBackgroundColor:[UIColor grayColor]];
        }
        else {
            [_statusButton setBackgroundColor:[UIColor greenColor]];
        }
        [_statusButton setTitle:statusOptionsArray[anIndex] forState:UIControlStateNormal];
    }

}

- (IBAction)saveVersionPressed:(id)sender {
    [_versionEntryView removeFromSuperview];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-dd-MM"];
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@-%@",product[@"Product Number"],@"PC1"],@"process_ctrl_id",[NSString stringWithFormat:@"%@_%@",product[@"Name"], @"PC1"], @"process_ctrl_name",product[@"Product Id"],@"ProductId",_versionLabel.text, @"VersionId", _statusButton.titleLabel.text, @"Status", _pickOriginatorButton.titleLabel.text, @"Originator", _pickApproverButton.titleLabel.text, @"Approver", _commentsTextView.text,@"Comments", @"", @"Description",[dateFormat stringFromDate:[NSDate date]], @"Timestamp" , nil];
    [__DataManager syncProcesses:selectedProcessesArray withProcessData:processData];
}

- (IBAction)cancelVersionPressed:(id)sender {
    [_versionEntryView removeFromSuperview];
}

- (IBAction)saveProcessPressed:(id)sender {
    NSMutableDictionary *lastProcess = commonProcessesArray[commonProcessesArray.count-1];
    [_addProcessView removeFromSuperview];
    NSMutableDictionary *processDict = [[NSMutableDictionary alloc] init];
    [processDict setObject:[NSString stringWithFormat:@"%d",selectedStation] forKey:@"StationId"];
    [processDict setObject:_processNameTF.text forKey:@"ProcessName"];
    [processDict setObject:[NSString stringWithFormat:@"%d",[lastProcess[@"processno"] intValue]+1] forKey:@"ProcessNo"];
    [self addProcessToList:processDict];
}

- (IBAction)cancelProcessPressed:(id)sender {
    [_addProcessView removeFromSuperview];
}

- (IBAction)statusButtonPressed:(id)sender {
    [self showPopUpWithTitle:@"Select Option" withOption:statusOptionsArray xy:CGPointMake(16, 60) size:CGSizeMake(287, 280) isMultiple:NO];
    dropDownList.tag = 1;
}

- (IBAction)editButtonPressed:(id)sender {
    _editView.frame = CGRectMake(self.view.frame.size.width/2-_editView.frame.size.width/2, self.view.frame.size.height/2-_editView.frame.size.height/2, _editView.frame.size.width, _editView.frame.size.height);
    [self.view addSubview:_editView];
    [self.view addSubview:_editView];
    _tintView.hidden = false;
}

- (IBAction)cancelEditPressed:(id)sender {
    [_editView removeFromSuperview];
}

- (IBAction)saveEditPressed:(id)sender {
    [_editView removeFromSuperview];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    NSLog(@"selected Array = %@",ArryData);
    for (int i=0; i < ArryData.count; ++i) {
       // [processesArray addObject:ArryData[i]];
        [self getProcessWithName:ArryData[i]];
    }
    [processesArray addObjectsFromArray:selectedProcessesArray];
    [_tableView reloadData];
    NSLog(@"selected Processes Array = %@",selectedProcessesArray);

   // [self addOperationsWithIds:ArryData];
}

- (void)getProcessWithName:(NSString*)processName {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-dd-MM"];
    for (int i=0; i < commonProcessesArray.count; ++i) {
        NSMutableDictionary *processData = commonProcessesArray[i];
        if ([processData[@"processname"] isEqualToString:processName]) {
            NSMutableDictionary *selectedProcessData = [[NSMutableDictionary alloc] init];
            [selectedProcessData setObject:processData[@"processno"] forKey:@"processno"];
            [selectedProcessData setObject:[NSString stringWithFormat:@"%lu",selectedProcessesArray.count+1] forKey:@"stepid"];
            [selectedProcessData setObject:@"A" forKey:@"operator"];
             [selectedProcessData setObject:@"1" forKey:@"time"];
             [selectedProcessData setObject:@"1" forKey:@"points"];
            [selectedProcessData setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"timestamp"];
            [selectedProcessData setObject:@"Test" forKey:@"comments"];
            [selectedProcessesArray addObject:processData];
        }
    }
}

- (void)getProcessWithNo:(int)processNo {
   // NSLog(@"common processes:%@",commonProcessesArray);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-dd-MM"];
    for (int i=0; i < commonProcessesArray.count; ++i) {
        NSMutableDictionary *processData = commonProcessesArray[i];
        if ([processData[@"processno"] intValue] == processNo) {
            NSMutableDictionary *selectedProcessData = [[NSMutableDictionary alloc] init];
            [selectedProcessData setObject:processData[@"processno"] forKey:@"processno"];
            [selectedProcessData setObject:[NSString stringWithFormat:@"%lu",selectedProcessesArray.count+1] forKey:@"stepid"];
            [selectedProcessData setObject:@"A" forKey:@"operator"];
            [selectedProcessData setObject:@"1" forKey:@"time"];
            [selectedProcessData setObject:@"1" forKey:@"points"];
            [selectedProcessData setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"timestamp"];
            [selectedProcessData setObject:@"Test" forKey:@"comments"];
            //[selectedProcessesArray addObject:selectedProcessData];
            [processesArray addObject:processData];
        }
    }
}

- (void)DropDownListViewDidCancel{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [processesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ProcessFlowViewCell";
    ProcessFlowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:processesArray[indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)setSelectedProduct:(NSMutableDictionary*)product_ {
    product = product_;
}


- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    if (tag == 1) {
        commonProcessesArray = [[NSMutableArray alloc] init];
    }
    if(tag == 4){
        [self getProcessFlow];
        return;
    }
    
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    
    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        if (json.count > 0) {
            if (tag == 1) {
                commonProcessesArray = json;
                [self setupDropDownList];
                [self getProcessFlow];
            }
            if (tag == 3) {
                processesArray = [[NSMutableArray alloc] init];
                NSDictionary *jsonDict = json[0];
                [_pickApproverButton setTitle:jsonDict[@"approver"] forState:UIControlStateNormal];
                [_pickOriginatorButton setTitle:jsonDict[@"originator"] forState:UIControlStateNormal];
                _commentsTextView.text = jsonDict[@"comments"];
                processCntrlId = jsonDict[@"process_ctrl_id"];
                [_statusButton setTitle:jsonDict[@"status"] forState:UIControlStateNormal];
                _versionLabel.text = jsonDict[@"version"];
                NSMutableArray* jsonProcessesArray = jsonDict[@"processes"];
                NSLog(@"json processes array=%@",jsonProcessesArray);
                for (int i=0; i < jsonProcessesArray.count; ++i) {
                    NSDictionary *processDict = jsonProcessesArray[i];
                    [self getProcessWithNo:[processDict[@"processno"] intValue]];
                }
                NSLog(@"processes Array=%@",processesArray);
                [_tableView reloadData];
            }
        }
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
   // [_tableView reloadData];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)setupDropDownList {
    processNamesArray = [[NSMutableArray alloc] init];
    for (int i=0; i < commonProcessesArray.count; ++i) {
        NSMutableDictionary *processDict = commonProcessesArray[i];
        [processNamesArray addObject:processDict[@"processname"]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return true;
}

- (void) deleteProcessAtIndex:(int)index {
    [self deleteProcessFromListAtIndex:index];
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
