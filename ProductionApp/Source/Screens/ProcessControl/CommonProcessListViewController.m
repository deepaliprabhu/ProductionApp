//
//  CommonProcessListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/09/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "CommonProcessListViewController.h"
#import "CommonProcessListViewCell.h"
#import "DataManager.h"
#import "Constants.h"
#import "ServerManager.h"
#import "UIView+RNActivityView.h"


@interface CommonProcessListViewController ()

@end

@implementation CommonProcessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _editView.layer.borderColor = [UIColor orangeColor].CGColor;
    _editView.layer.borderWidth = 1.0f;
    _editView.layer.cornerRadius = 6.0f;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initProcesses) name:kNotificationCommonProcessesReceived object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightButtonPressed)];
    
    stationsArray = [NSMutableArray arrayWithObjects:@"0-Non Line",@"1-Inward Testing", @"2-Soldering",@"3-Mechanical Assembly",@"4-Final Inspection", @"5-Cleaning & Packaging", @"6-Moulding", @"7-Other",nil];
    self.title = @"Process List";
    [__ServerManager getProcessList];
}

- (void)rightButtonPressed {
    [__DataManager syncCommonProcesses];
}

- (IBAction)cancelEditPressed:(id)sender {
    _tintView.hidden = true;
    [_editView removeFromSuperview];
}

- (IBAction)saveEditPressed:(id)sender{
    NSMutableDictionary *processData = [[NSMutableDictionary alloc] init];
    NSLog(@"orig processData=%@",processData);
    
    [processData setObject:[NSString stringWithFormat:@"%d",selectedStation] forKey:@"stationid"];
    [processData setObject:_processNameTF.text forKey:@"processname"];
    if (_editView.tag == 1) {
        NSMutableDictionary *lastProcess = processesArray[processesArray.count-1];
        [processData setObject:[NSString stringWithFormat:@"%d",[lastProcess[@"processno"] intValue]+1] forKey:@"processno"];
        [self addProcessToList:processData];
    }
    else {
        processData = [processesArray[selectedIndex] mutableCopy];
        [processData setObject:[NSString stringWithFormat:@"%d",selectedStation] forKey:@"stationid"];
        [processData setObject:_processNameTF.text forKey:@"processname"];
        [processesArray replaceObjectAtIndex:selectedIndex withObject:processData];
        [__DataManager updateProcessAtIndex:selectedIndex process:processData];
    }

    NSLog(@"edited processData=%@",processData);

    [_editView removeFromSuperview];
    _tintView.hidden = true;

    [__DataManager syncCommonProcesses];
}


- (IBAction)addProcessPressed:(id)sender {
    _editView.frame = CGRectMake(self.view.frame.size.width/2-_editView.frame.size.width/2, self.view.frame.size.height/2-_editView.frame.size.height/2, _editView.frame.size.width, _editView.frame.size.height);
    [self.view addSubview:_editView];
    _tintView.hidden = false;
    _editView.tag = 1;
}

-(NSString *)urlEncodeUsingEncoding:(NSString*)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"() ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

- (void)addProcessToList:(NSMutableDictionary*)processData {
    [self.navigationController.view showActivityViewWithLabel:@"Adding new process"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=addProcess&processno=%@&processname=%@&desc=%@&wi=%@&stationid=%@",processData[@"processno"], [self urlEncodeUsingEncoding:processData[@"processname"]],@"",@"", processData[@"stationid"]] withTag:2];
}

- (void)deleteProcessFromListAtIndex:(int)index {
    NSMutableDictionary *processData = processesArray[index];
    [self.navigationController.view showActivityViewWithLabel:@"deleting process"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    ConnectionManager *connectionManager = [ConnectionManager new];
    connectionManager.delegate = self;
    [connectionManager makeRequest:[NSString stringWithFormat:@"http://aginova.info/aginova/json/processes.php?call=delProcess&processno=%@",processData[@"processno"]] withTag:3];
}

- (IBAction)pickStationPressed:(id)sender {
    if(dropDown == nil) {
        _tintView.hidden = false;
        CGFloat f = 220;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :stationsArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.tag = 3;
       // selectedTag = 3;
        dropDown.delegate = self;
    }
    else {
        _tintView.hidden = true;
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) initProcesses {
    processesArray = [__DataManager getCommonProcesses];
    [_tableView reloadData];
    //[self.navigationController.view hideActivityView];
}

- (void) selectedListIndex:(int)index {
    selectedStation = index;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [processesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CommonProcessListViewCell";
    CommonProcessListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:processesArray[indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    _editView.frame = CGRectMake(self.view.frame.size.width/2-_editView.frame.size.width/2, self.view.frame.size.height/2-_editView.frame.size.height/2, _editView.frame.size.width, _editView.frame.size.height);
    [self.view addSubview:_editView];
    _editView.tag = 2;
    NSMutableDictionary *processData = processesArray[indexPath.row];
    NSLog(@"selected processData=%@",processData);

    [_stationButton setTitle:processData[@"stationid"] forState:UIControlStateNormal];
    _processNameTF.text = processData[@"processname"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return true;
}

- (void) deleteProcessAtIndex:(int)index {
    [self deleteProcessFromListAtIndex:index];
}

- (void) parseJsonResponse:(NSData*)jsonData withTag:(int)tag {
    [self.navigationController.view hideActivityView];
    [__ServerManager getProcessList];
}

- (void) parseJsonResponse:(NSData*)jsonData {
    
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
