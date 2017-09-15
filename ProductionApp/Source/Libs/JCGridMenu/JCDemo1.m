//
//  JCDemo1.m
//
//  Created by Joseph Carney on 20/07/2012.
//  Copyright (c) 2012 North of the Web. All rights reserved.
//

#import "JCDemo1.h"

#define GM_TAG        1001

@interface JCDemo1 ()

@end


@implementation JCDemo1

@synthesize gmDemo = _gmDemo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setView:[[JCUIViewTransparent alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Initialise

- (id)init
{
    self = [super init];
    if (self) {
        // Search
        CGRect screenRect = [[UIScreen mainScreen] bounds];

        JCGridMenuColumn *searchInput = [[JCGridMenuColumn alloc]
                                         initWithView:CGRectMake(0, 0, screenRect.size.width, 44)];
        [searchInput.view setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1]];
        [searchInput.button setBackgroundColor:[UIColor whiteColor]];
        
        
        JCGridMenuColumn *searchClose = [[JCGridMenuColumn alloc]
                                         initWithButtonAndImages:CGRectMake(0, 0, 44, 44)
                                         normal:@"Close"
                                         selected:@"CloseSelected"
                                         highlighted:@"CloseSelected"
                                         disabled:@"Close"];
        [searchClose.button setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1]];
        
        JCGridMenuRow *search = [[JCGridMenuRow alloc]
                                 initWithImages:@"Search"
                                 selected:@"CloseSelected"
                                 highlighted:@"SearchSelected"
                                 disabled:@"Search"];
        [search.button setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1]];
        [search setHideOnExpand:YES];
        [search setIsModal:YES];
        [search setHideAlpha:0.2f];
        [search setIsSeperated:YES];
        [search setColumns:[[NSMutableArray alloc] initWithObjects:searchInput, searchClose, nil]];
        
        // Share...
        JCGridMenuColumn *openView = [[JCGridMenuColumn alloc]
                                           initWithButtonImageTextLeft:CGRectMake(0, 0, 80, 44)
                                           image:nil
                                           selected:nil
                                           text:@"Open"];

        [openView.button setBackgroundColor:[UIColor colorWithRed:249.0f/255 green:99.0f/255 blue:50.0f/255 alpha:1]];
        [openView setCloseOnSelect:YES];
        
        JCGridMenuColumn *reworkView = [[JCGridMenuColumn alloc]
                                      initWithButtonImageTextLeft:CGRectMake(0, 0, 80, 44)
                                      image:nil
                                      selected:nil
                                      text:@"Rework"];
        
        [reworkView.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.8f]];
        [reworkView setCloseOnSelect:YES];

        JCGridMenuColumn *rejectView = [[JCGridMenuColumn alloc]
                                        initWithButtonImageTextLeft:CGRectMake(0, 0, 80, 44)
                                        image:nil
                                        selected:nil
                                        text:@"Reject"];
        
        [rejectView.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.8f]];
        [rejectView setCloseOnSelect:YES];
        
        JCGridMenuRow *share = [[JCGridMenuRow alloc] initWithImages:@"back" selected:@"CloseSelected" highlighted:@"back" disabled:@"Share"];
        [share setColumns:[[NSMutableArray alloc] initWithObjects:openView, reworkView, rejectView, nil]];
        [share setIsModal:YES];
        [share setHideAlpha:0.2f];
        [share setIsSeperated:YES];
        [share.button setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
        
        // Rows...
        _gmDemo.delegate = self;

        NSArray *rows = [[NSArray alloc] initWithObjects:search, nil];
        _gmDemo = [[JCGridMenuController alloc] initWithFrame:CGRectMake(0,0,screenRect.size.width,(44*[rows count])+[rows count]) rows:rows tag:GM_TAG];
        [_gmDemo setDelegate:self];
        [self.view addSubview:_gmDemo.view];

        [self close];
        [self open];
    }
    return self;
}


#pragma mark - Open and Close

- (void)open
{
     [_gmDemo open];   
}

- (void)close
{
    [_gmDemo close];   
}




#pragma mark - JCGridMenuController Delegate

- (void)jcGridMenuRowSelected:(NSInteger)indexTag indexRow:(NSInteger)indexRow isExpand:(BOOL)isExpand
{
    if (isExpand) {
        NSLog(@"jcGridMenuRowSelected %i %i isExpand", indexTag, indexRow);
    } else {
        NSLog(@"jcGridMenuRowSelected %i %i !isExpand", indexTag, indexRow);
    }
    
    if (indexTag==GM_TAG) {
        JCGridMenuRow *rowSelected = (JCGridMenuRow *)[_gmDemo.rows objectAtIndex:indexRow];
        
        if (indexRow==0) {
            // Search
            [[rowSelected button] setSelected:YES];
            [self searchInput:YES];
        }
        
    }
    
}

- (void)jcGridMenuColumnSelected:(NSInteger)indexTag indexRow:(NSInteger)indexRow indexColumn:(NSInteger)indexColumn
{
    NSLog(@"jcGridMenuColumnSelected %i %i %i", indexTag, indexRow, indexColumn);
    
    if (indexTag==GM_TAG) {
        
        if (indexRow==0) {
            // Search
            [self searchInput:NO];
            [[[_gmDemo.gridCells objectAtIndex:indexRow] button] setSelected:NO];
        }
        
        [_gmDemo setIsRowModal:NO];
    }
    
}


#pragma mark - Demo specific controls

- (void)searchInput:(BOOL)isDisplay
{
    UITextView *text;
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    if (isDisplay) {
        text = [[UITextView alloc] initWithFrame:CGRectMake(10, 7, screenRect.size.width-70, 30)];
        [text setBackgroundColor:[UIColor whiteColor]];
        text.text = @"Enter Job Id";
        text.textColor = [UIColor darkGrayColor];
        text.layer.borderColor = [UIColor whiteColor].CGColor;
        text.layer.cornerRadius = 15.0f;
        [text setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [text setTag:12345];
        [text setDelegate:self];
        [self.view addSubview:text];
       // [text performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
    } else {
        text = (UITextView *)[self.view viewWithTag:12345];
        [text resignFirstResponder];
        [text removeFromSuperview];
        [_delegate closeSearch];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"called textViewDidBeginEditing");
    textView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"Enter Pressed");
        [_delegate searchWithText:textView.text];
        return false;
    }
    if ([text isEqualToString:@"Enter Job Id"]) {
        textView.text = @"";
        return false;
    }
    return true;
}
@end
