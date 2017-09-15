//
//  TaskListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 23/06/17.
//  Copyright © 2017 Aginova. All rights reserved.
//

#import "TaskListViewController.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "DataManager.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Task List";
    namesArray = [NSMutableArray arrayWithObjects:@"Matt", @"Ashok", @"Arvind", @"Ram", @"Elizabeth", @"Arthur", @"Vally",nil];
    _addTaskView.layer.borderColor = [UIColor orangeColor].CGColor;
    _addTaskView.layer.borderWidth = 1;
    //tasksArray = [[NSMutableArray alloc] init];
   // [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    //[self.navigationController.view hideActivityViewWithAfterDelay:60];
    //[self getTasks];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTasks:(NSMutableArray*)tasksArray_ {
    tasksArray = tasksArray_;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        // check if we are going to delete a row or a section
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tasksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"TaskListViewCell";
    
    TaskListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.delegate = self;
    [cell setCellData:tasksArray[indexPath.row] index:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (IBAction)pickAssignedByPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :namesArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)pickAssignedToPressed:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :namesArray :nil :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
        dropDown.tag = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) selectedListIndex:(int)index {
    //selectedOperator = operatorArray[index];
   // selectedName = namesArray[index];
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (IBAction)pickDueDatePressed:(id)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
}

- (IBAction)addTaskPressed:(id)sender {
    _assignedToButton.titleLabel.text = @"--";
    _assignedByButton.titleLabel.text = @"--";
    _textView.text = @"Add task here..";
    _addTaskView.frame = CGRectMake(self.view.frame.size.width/2-_addTaskView.frame.size.width/2, self.view.frame.size.height/2-_addTaskView.frame.size.height/2-100, _addTaskView.frame.size.width, _addTaskView.frame.size.height);
    [self.view addSubview:_addTaskView];
}

-(IBAction)submitPressed:(id)sender {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_assignedByButton.titleLabel.text,@"AssignedBy", _assignedToButton.titleLabel.text, @"AssignedTo", _dueDateButton.titleLabel.text, @"DueDate", _textView.text, @"Task", nil];
    
    [self saveTaskDataInParse:dictionary];
    [_addTaskView removeFromSuperview];
    [_textView resignFirstResponder];
}

-(IBAction)cancelPressed:(id)sender {
    [_addTaskView removeFromSuperview];
    [_textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([_textView.text isEqualToString:@"Add task here.."])
    {
        _textView.text = @"";
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (!_textView.text.length)
    {
        _textView.text = @"Add task here..";
        _textView.textColor = [UIColor grayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return false;
    }
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Add task here.." withString:@""];
    return true;
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    // dateItem.backgroundColor = [UIColor redColor];
    // dateItem.textColor = [UIColor whiteColor];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return true;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [calendar removeFromSuperview];
    [_dueDateButton setTitle:dateString forState:UIControlStateNormal];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        //self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

- (void)saveTaskDataInParse:(NSMutableDictionary*)taskData {
    PFObject *parseObject = [PFObject objectWithClassName:@"TaskList"];
    parseObject[@"AssignedBy"] = [taskData objectForKey:@"AssignedBy"];
    parseObject[@"AssignedTo"] = [taskData objectForKey:@"AssignedTo"];
    parseObject[@"DueDate"] = [taskData objectForKey:@"DueDate"];
    parseObject[@"Task"] = [taskData objectForKey:@"Task"];
    parseObject[@"Status"] = @"Open";
    NSLog(@"saving parse object = %@",parseObject);
    BOOL succeeded = [parseObject save];
    if (succeeded) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Data Saved Successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
        [self getTasks];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error in saving data" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)getTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"TaskList"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int i=0;
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        tasksArray = objects;
        [__DataManager setTaskList:tasksArray];
        [_tableView reloadData];
    }];
}

- (void) updateStatus:(BOOL)value forIndex:(int)index {
    PFObject *parseObj = tasksArray[index];
    if (value) {
        parseObj[@"Status"] = @"Closed";
    }
    else {
        parseObj[@"Status"] = @"Open";
    }
    [parseObj save];
}

- (void) deleteTaskAtIndex:(int)index {
    PFObject *parseObj = tasksArray[index];
    [parseObj delete];
    [tasksArray removeObjectAtIndex:index];
    [_tableView reloadData];
}

@end
