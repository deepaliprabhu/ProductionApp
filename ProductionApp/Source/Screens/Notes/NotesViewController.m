//
//  NotesViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import "NotesViewController.h"
#import <Parse/Parse.h>
#import "NotesViewCell.h"
#import "UIView+RNActivityView.h"


NSString* const PLACEHOLDER = @"Add new note";

@implementation NotesViewController

#pragma mark - Layout

- (void) initLayout
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    doneButton.layer.cornerRadius = 6.0f;
    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonTapped)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonTapped)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Notes"];
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    self.navigationItem.title = @"Notes";
    self.navigationController.navigationBar.hidden = false;

    //self.navigationItem.rightBarButtonItem = rightButton;
    [_navBar setItems:@[navItem]];
    if (![note isEqualToString:@""]) {
        _textView.text = note;
        _textView.textColor = [UIColor blackColor];
    }
    namesArray = [NSMutableArray arrayWithObjects:@"Matt", @"Sneha",@"Ashok", @"Arvind", @"Ram", @"Elizabeth", @"Vally",nil];
    notesArray = [[NSMutableArray alloc] init];
    [self getNotes];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLayout];
}

- (void)addNote:(NSString *)noteValue withTag:(int)tagValue forType:(NoteType)type{
    noteType = type;
    NSLog(@"tagn = %d note = %@",tagValue, note);
    if (![noteValue isEqualToString:@""]) {
        _textView.text = note;
        _textView.textColor = [UIColor blackColor];
        [_textView becomeFirstResponder];
        tag = tagValue;
        note = noteValue;
    }
}

- (void)setRun:(Run *)run_ {
    run = run_;
}

#pragma mark - Orientation

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - Action

- (void) cancelButtonTapped
{
    [self dismissModalViewControllerAnimated:YES];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNotesDismissed object:nil]; // could be replaced by delegate but it lower coupling this way
}

- (IBAction)doneButtonTapped
{
    NSMutableDictionary *noteData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_notesTextView.text,@"Comment",[NSString stringWithFormat:@"%d",[run getRunId]],@"RunId",selectedName,@"Name", nil];
    [notesArray addObject:noteData];
    [_tableView reloadData];
    _notesTextView.text = @"Add new Note";
    [self saveNote];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"NotesViewCell";
    
    NotesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    [cell setCellData:notesArray[indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}




#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([_notesTextView.text isEqualToString:PLACEHOLDER])
    {
        _notesTextView.text = @"";
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (!_textView.text.length)
    {
        _textView.text = PLACEHOLDER;
        _textView.textColor = [UIColor grayColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_notesTextView resignFirstResponder];
        [_textView resignFirstResponder];
        return false;
    }
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@"Add new Note" withString:@""];
    return true;
}

- (void)getNotes {
    [self.navigationController.view showActivityViewWithLabel:@"fetching demands"];
    [self.navigationController.view hideActivityViewWithAfterDelay:60];
    
    PFQuery *query = [PFQuery queryWithClassName:@"RunNotes"];
    [query whereKey:@"RunId" equalTo:[NSString stringWithFormat:@"%d",[run getRunId]]];
    NSArray *objects = [query findObjects];
    //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    int j=0;
    NSLog(@"objects count = %lu",(unsigned long)[objects count]);
    if (objects.count>0) {
        notesArray = [objects mutableCopy];
        [_tableView reloadData];
    }
    [self.navigationController.view hideActivityView];
}

- (void)saveNote {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat1 stringFromDate:[NSDate date]];
    PFObject *parseObject = [PFObject objectWithClassName:@"RunNotes"];
    parseObject[@"Comment"] = _notesTextView.text;
    parseObject[@"Name"] = selectedName;
    parseObject[@"RunId"] = [NSString stringWithFormat:@"%d",[run getRunId]];
    parseObject[@"Date"] = dateString;
    [parseObject save];
}

#pragma mark - MemoryManagement

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    _navBar = nil;
    _textView = nil;
    [super viewDidUnload];
}


- (IBAction)pickNamePressed:(id)sender {
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
    selectedName = namesArray[index];
    dropDown = nil;
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}


- (void)keyboardDidShow: (NSNotification *) notif{
    self.view.transform = CGAffineTransformMakeTranslation(0, -250);
}

- (void)keyboardDidHide: (NSNotification *) notif{
    if (self.view.frame.origin.y < 0) {
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
}
@end
