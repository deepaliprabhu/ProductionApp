//
//  ChecklistGenViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 13/07/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "ChecklistGenViewController.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "ConnectionManager.h"


@interface ChecklistGenViewController ()

@end

@implementation ChecklistGenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // NSLog(@"random mac = %@",[self generateMac]);
    self.navigationController.navigationBar.hidden = false;
    checklistArray = [[NSMutableArray alloc] init];
    self.title = @"Run Checklist";
    if (run) {
        _runIdTF.text = [NSString stringWithFormat:@"%d",runId];
        _quantityTF.text = [NSString stringWithFormat:@"%d",[run getQuantity]];
        _productLabel.text = [run getProductName];
        [self setHeaderList];
        [self getRunChecklist];
        _addEntryButton.hidden = false;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatePressed:(id)sender {
    [self generateChecklist];
}

- (void)setRun:(Run*)run_ {
    run = run_;
    runId = [run getRunId];
    if ([[run getProductName] containsString:@"PCB"]) {
        runType = 0;
        _addEntryButton.hidden = false;
    }
    else {
        runType = 1;
        _addEntryButton.hidden = false;
    }
}

- (void)generateChecklist {
    int runId = [_runIdTF.text intValue];
    int startId = [_startIdTF.text intValue];
    int quantity = 10;
    checklistArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < [_quantityTF.text intValue]; ++i) {
        NSMutableDictionary *checklistData = [[NSMutableDictionary alloc] init];
        [checklistData setObject:[NSString stringWithFormat:@"%d",runId] forKey:@"RunId"];
        if(runType == 0) {
            [checklistData setObject:[self generateMac] forKey:@"MacAddress"];
        }
        else {
            [checklistData setObject:[NSString stringWithFormat:@"%d",startId+i] forKey:@"SensorId"];
        }
        [checklistData setObject:@"OKAY" forKey:@"Status"];
        [checklistData setObject:@"ARVIND" forKey:@"CheckedBy"];
        for (int j=0; j < checklistHeaderArray.count; ++j) {
            [checklistData setObject:@"OKAY" forKey:checklistHeaderArray[j]];
        }
        [checklistArray addObject:checklistData];
    }
    [_tableView reloadData];
    [self saveChecklist];
}

- (void)saveChecklist {
    for (int i=0; i < checklistArray.count; ++i) {
        [self saveChecklistInParse:checklistArray[i]];
    }
}

- (void)saveChecklistEntry:(NSMutableDictionary*)checklistData {
    [self saveChecklistInParse:checklistData];
}

#pragma mark - Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[checklistArray count]];
    return [checklistArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ChecklistGenCell";
    
    ChecklistGenCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:checklistArray[indexPath.row] index:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)saveChecklistInParse:(NSMutableDictionary*)checklistData {
    PFObject *parseObject;
    if (runType == 0) {
        parseObject = [PFObject objectWithClassName:@"PCBChecklist"];
        parseObject[@"MacAddress"] = [checklistData objectForKey:@"MacAddress"];
    }
    else {
        PFObject *parseObject = [PFObject objectWithClassName:@"UnitChecklist"];
        parseObject[@"SensorId"] = [checklistData objectForKey:@"SensorId"];
    }
    parseObject[@"RunId"] = [checklistData objectForKey:@"RunId"];
    parseObject[@"Status"] = [checklistData objectForKey:@"Status"];
    parseObject[@"CheckedBy"] = [checklistData objectForKey:@"CheckedBy"];
    for (int i=0; i < checklistHeaderArray.count; ++i) {
        NSString *headerName = [checklistHeaderArray[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
        parseObject[headerName] = [checklistData objectForKey:checklistHeaderArray[i]];
    }
    NSLog(@"saving parse object = %@",parseObject);
    [parseObject save];
}

- (void)editChecklistInParse:(NSMutableDictionary*)checklistData {
    PFQuery *query = [PFQuery queryWithClassName:@"PCBChecklist"];
    [query whereKey:@"RunId" equalTo:_runIdTF.text];
    NSString *status = @"OKAY";
    if (runType == 0) {
        [query whereKey:@"MacAddress" equalTo:checklistData[@"MacAddress"]];
    }
    else {
        [query whereKey:@"SensorId" equalTo:checklistData[@"SensorId"]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        PFObject *parseObject = objects[0];
        parseObject[@"Status"] = @"OKAY";
        for (int i=0; i < checklistHeaderArray.count; ++i) {
            NSString *headerName = [checklistHeaderArray[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            parseObject[headerName] = [checklistData objectForKey:checklistHeaderArray[i]];
            if ([[checklistData objectForKey:checklistHeaderArray[i]] isEqualToString:@"REJECT"]) {
                parseObject[@"Status"] = @"REJECT";
            }
        }
        [parseObject save];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_runIdTF]) {
            [self getRunData];
    }
    [textField resignFirstResponder];

    return true;
}

- (void)getRunData {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Orders list"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    NSString *reqString = [NSString stringWithFormat:@"http://aginova.info/aginova/json/action.php?call=get_run&id=%d",[_runIdTF.text intValue]];
    [connectionManager makeRequest:reqString withTag:8];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag{
    [self.navigationController.view hideActivityView];
    // partsTransferArray = [[NSMutableArray alloc] init];
    
    NSLog(@"jsonData = %@", jsonData);
    
    NSString *partShortString = @"";
    NSError* error;
    NSString *dataString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] mutableCopy];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<pre>" withString:@""];

    NSLog(@"datastring = %@", dataString);
    jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"error parsing json");
    }
    
    if ([json isKindOfClass:[NSArray class]]){
        NSLog(@"json Array = %@",json);
        NSMutableDictionary *runData = json[0];
        _quantityTF.text = runData[@"QUANTITY"];
        _productLabel.text = runData[@"INTERNAL_NAME"];
        if ([runData[@"INTERNAL_NAME"] containsString:@"PCB"]) {
            runType = 0;
            _generateButton.hidden = true;
            _addEntryButton.hidden = false;
        }
        else {
            runType = 1;
            _generateButton.hidden = false;
            _addEntryButton.hidden = true;
        }
        [self setHeaderList];
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
}

- (void)setHeaderList {
    switch (runType) {
        case 0:
            checklistHeaderArray = [NSMutableArray arrayWithObjects:@"Visual Inspection", @"SolderSide Check",@"Flashing", @"Current Check", @"Blinking",nil];
            break;
        case 1:
            checklistHeaderArray = [NSMutableArray arrayWithObjects:@"Enclosure Fitment", @"Sticker Print",@"Unit Activation", @"Read In App", @"Temp Reading", @"Temp Changes", @"Logo", @"Enclosure Finishing", @"BatteryStatus", @"Unit Cleaning", @"Unit Packing",nil];
            break;
        default:
            break;
    }
}

- (NSString*)generateMac {
    NSString *macString = @"74:6a:89:00";
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 4];
    
    for (int i=0; i<4; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    randomString = [randomString lowercaseString];
    [randomString insertString:@":" atIndex:2];
    [randomString insertString:@":" atIndex:0];

    macString = [macString stringByAppendingString:randomString];
    return macString;
}

- (IBAction)addEntryPressed:(id)sender {
    [self resetEntryView];
    editMode = false;
    if (runType == 0) {
        _addEntryView.layer.borderWidth = 1.0;
        _addEntryView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _addEntryView.frame = CGRectMake(self.view.frame.size.width/2-_addEntryView.frame.size.width/2, self.view.frame.size.height/2-_addEntryView.frame.size.height/2, _addEntryView.frame.size.width, _addEntryView.frame.size.height);
        [self.view addSubview:_addEntryView];
    }
    else {
        _addUnitEntryView.layer.borderWidth = 1.0;
        _addUnitEntryView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _addUnitEntryView.frame = CGRectMake(self.view.frame.size.width/2-_addUnitEntryView.frame.size.width/2, self.view.frame.size.height/2-_addUnitEntryView.frame.size.height/2, _addUnitEntryView.frame.size.width, _addUnitEntryView.frame.size.height);
        [self.view addSubview:_addUnitEntryView];
    }
}

- (void)resetEntryView {
    _macAddrTF.text = @"";
    _sensorIdTF.text = @"";
    _macAddrTF.userInteractionEnabled = true;
    _sensorIdTF.userInteractionEnabled = true;
    for (int i=0; i < checklistHeaderArray.count; ++i) {
        UISwitch *_switch = (UISwitch*)[_addEntryView viewWithTag:i+1];
        [_switch setOn:true];
    }
}

- (IBAction)cancelEntryPressed:(id)sender{
    [_addEntryView removeFromSuperview];
}

- (IBAction)submitEntryPressed:(id)sender{
    NSString *status = @"OKAY";
    [_addEntryView removeFromSuperview];
    NSMutableDictionary *checklistData = [[NSMutableDictionary alloc] init];
    [checklistData setObject:_runIdTF.text forKey:@"RunId"];
    [checklistData setObject:_macAddrTF.text forKey:@"MacAddress"];
    [checklistData setObject:_macAddrTF.text forKey:@"SensorId"];


    [checklistData setObject:@"ARVIND" forKey:@"CheckedBy"];
    for (int i=0; i < checklistHeaderArray.count; ++i) {
        UISwitch *_switch = (UISwitch*)[_addEntryView viewWithTag:i+1];
        if (_switch.isOn) {
            [checklistData setObject:@"OKAY" forKey:checklistHeaderArray[i]];
        }
        else {
            [checklistData setObject:@"REJECT" forKey:checklistHeaderArray[i]];
            status = @"REJECT";
        }
    }
    [checklistData setObject:status forKey:@"Status"];
    if (editMode) {
        [checklistArray replaceObjectAtIndex:editingIndex withObject:checklistData];
        [self editChecklistInParse:checklistData];
    }
    else {
        [checklistArray addObject:checklistData];
        [self saveChecklistEntry:checklistData];
    }
    [_tableView reloadData];
}

- (IBAction)cancelUnitEntryPressed:(id)sender{
    [_addUnitEntryView removeFromSuperview];
}

- (IBAction)submitUnitEntryPressed:(id)sender{
    NSString *status = @"OKAY";
    [_addEntryView removeFromSuperview];
    NSMutableDictionary *checklistData = [[NSMutableDictionary alloc] init];
    [checklistData setObject:_runIdTF.text forKey:@"RunId"];
    [checklistData setObject:_sensorIdTF.text forKey:@"SensorId"];
    [checklistData setObject:@"ARVIND" forKey:@"CheckedBy"];
    for (int i=0; i < checklistHeaderArray.count; ++i) {
        UISwitch *_switch = (UISwitch*)[_addEntryView viewWithTag:i+1];
        if (_switch.isOn) {
            [checklistData setObject:@"OKAY" forKey:checklistHeaderArray[i]];
        }
        else {
            [checklistData setObject:@"REJECT" forKey:checklistHeaderArray[i]];
            status = @"REJECT";
        }
    }
    [checklistData setObject:status forKey:@"Status"];
    if (editMode) {
        [checklistArray replaceObjectAtIndex:editingIndex withObject:checklistData];
        [self editChecklistInParse:checklistData];
    }
    else {
        [checklistArray addObject:checklistData];
        [self saveChecklistEntry:checklistData];
    }
    [_tableView reloadData];
}

- (void) editCellWithIndex:(int)index {
    editingIndex = index;
    NSMutableDictionary *checklistData = checklistArray[index];
    editMode = true;
    if (runType == 0) {
        _macAddrTF.text = checklistData[@"MacAddress"];
        _macAddrTF.userInteractionEnabled = false;
        _addEntryView.layer.borderWidth = 1.0;
        _addEntryView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _addEntryView.frame = CGRectMake(self.view.frame.size.width/2-_addEntryView.frame.size.width/2, self.view.frame.size.height/2-_addEntryView.frame.size.height/2, _addEntryView.frame.size.width, _addEntryView.frame.size.height);
        [self.view addSubview:_addEntryView];
    }
    else {
        _sensorIdTF.text = checklistData[@"SensorId"];
        _sensorIdTF.userInteractionEnabled = false;
        _addUnitEntryView.layer.borderWidth = 1.0;
        _addUnitEntryView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _addUnitEntryView.frame = CGRectMake(self.view.frame.size.width/2-_addUnitEntryView.frame.size.width/2, self.view.frame.size.height/2-_addUnitEntryView.frame.size.height/2, _addUnitEntryView.frame.size.width, _addUnitEntryView.frame.size.height);
        [self.view addSubview:_addUnitEntryView];
    }
    NSString *status = @"OKAY";
    for (int i=0; i < checklistHeaderArray.count; ++i) {
        UISwitch *_switch;
        if (runType == 0) {
            _switch = (UISwitch*)[_addEntryView viewWithTag:i+1];
        }
        else {
            _switch = (UISwitch*)[_addUnitEntryView viewWithTag:i+1];
        }
        if ([checklistData[checklistHeaderArray[i]] isEqualToString:@"OKAY"]) {
            [_switch setOn:true];
        }
        else {
            [_switch setOn:false];
        }
    }
    //[self editChecklistInParse:checklistData];
}

- (void)getRunChecklist {
    PFQuery *query = [PFQuery queryWithClassName:@"PCBChecklist"];
    [query whereKey:@"RunId" equalTo:_runIdTF.text];
    NSString *status = @"OKAY";
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        [self setUpChecklist:objects];
    }];
}

- (void)setUpChecklist:(NSMutableArray*)array {
    checklistArray = [[NSMutableArray alloc] init];
    for (int i=0; i < array.count; ++i) {
        NSMutableDictionary *checklistData = [[NSMutableDictionary alloc] init];
        [checklistData setObject:_runIdTF.text forKey:@"RunId"];
        [checklistData setObject:array[i][@"Status"] forKey:@"Status"];
        [checklistData setObject:array[i][@"CheckedBy"] forKey:@"CheckedBy"];
        if (runType == 0) {
            [checklistData setObject:array[i][@"MacAddress"] forKey:@"MacAddress"];
        }
        else {
            [checklistData setObject:array[i][@"SensorId"] forKey:@"SensorId"];
        }
        for (int j=0; j < checklistHeaderArray.count; ++j) {
            NSString *headerName = [checklistHeaderArray[j] stringByReplacingOccurrencesOfString:@" " withString:@""];
            [checklistData setObject:array[i][headerName] forKey:checklistHeaderArray[j]];
        }
        [checklistArray addObject:checklistData];
        NSLog(@"checklist array = %@",checklistArray);
    }
    [_tableView reloadData];
}


@end
