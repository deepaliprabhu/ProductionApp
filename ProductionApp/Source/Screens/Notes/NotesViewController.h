//
//  NotesViewController.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/04/16.
//  Copyright © 2016 Aginova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "NIDropDown.h"
#import "Run.h"


typedef enum
{
    NoteTypeSnapshot=1,
    NoteTypeRecord,
    NoteTypePin,
    NoteTypePhoto
}NoteType;

@protocol NotesViewControllerDelegate;
@interface NotesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextViewDelegate, UITextFieldDelegate, NIDropDownDelegate>
{
    @private
        IBOutlet UINavigationBar *_navBar;
        IBOutlet UITextView *_textView;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UITextField *_nameTextField;
    IBOutlet UITextView *_notesTextView;
    IBOutlet UITableView *_tableView;
    BOOL snapshotNote;
    int tag;
    int index;
    NSString *note;
    NSString *selectedName;

    NSArray *namesArray;
    NSMutableArray *notesArray;

    NoteType noteType;
    NIDropDown *dropDown;
    Run *run;

}
__pd(NotesViewControllerDelegate);


// if this property is set, than the screen will set the notes for a specific packet
- (void)addNote:(NSString *)noteValue withTag:(int)tagValue forType:(NoteType)type;
- (void)addNote:(NSString *)noteValue withTag:(int)tagValue index:(int)indexValue forType:(NoteType)type;
- (void)setRun:(Run*)run_;
@end

@protocol NotesViewControllerDelegate <NSObject>
- (void) addNote:(NSString*)text;
@end
