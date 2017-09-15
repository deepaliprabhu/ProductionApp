//
//  ReportsViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 29/09/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "ReportsViewController.h"
#import "PDFRenderer.h"
#import "User.h"
#import <Parse/Parse.h>
#import "UIView+RNActivityView.h"
#import "ConnectionManager.h"
#import "ServerManager.h"
#import "Constants.h"
#import "DataManager.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Reports";
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRuns) name:kNotificationRunsReceived object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initRuns {
    parseRuns = [__DataManager getRuns];
    [self generateWSR];
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
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    parseRuns = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat1 dateFromString:[__User getDateString]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:selectedDate];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DailyRun"];
    [query whereKey:@"Date" equalTo:dateString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController.view hideActivityView];
            return;
        }
        [parseRuns addObjectsFromArray:objects];
        NSLog(@"parse runs = %@",parseRuns);
        [self.navigationController.view hideActivityView];
        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Data to Show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            [self generateReport];
        }
    }];
}

- (void)fetchParseDataForRun {
    parseRuns = [[NSMutableArray alloc] init];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];

    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    [query whereKey:@"RunId" equalTo:_runIdTF.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController.view hideActivityView];
            return;
        }
        [parseRuns addObjectsFromArray:objects];
        NSLog(@"parse runs = %@",parseRuns);
        [self.navigationController.view hideActivityView];

        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Data to Show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            [self generateRunReport:parseRuns[0]];
        }
    }];
}

- (void)fetchChecklistForRun {
    checklistArray = [[NSMutableArray alloc] init];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    PFQuery *query;
    if (runType == 0) {
        query = [PFQuery queryWithClassName:@"PCBChecklist"];
    }
    else {
        query = [PFQuery queryWithClassName:@"UnitChecklist"];
    }
    [query whereKey:@"RunId" equalTo:_runIdTF.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController.view hideActivityView];
            return;
        }
        checklistArray = objects;
        [self.navigationController.view hideActivityView];
        
        if (checklistArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Data to Show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            if (runType == 0) {
                [self generatePCBChecklistReport];
            }
            else {
                [self generateUnitChecklistReport];
            }
        }
    }];
}

- (void)fetchParseDataForRunsStatus {
    parseRuns = [[NSMutableArray alloc] init];
    [self.navigationController.view showActivityViewWithLabel:@"fetching data"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Runs"];
    [query whereKey:@"Status" notEqualTo:@"Closed"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects count = %lu",(unsigned long)[objects count]);
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Error fetching data. Please check your Internet connection." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            [self.navigationController.view hideActivityView];
            return;
        }
        [parseRuns addObjectsFromArray:objects];
       // NSLog(@"parse runs = %@",parseRuns);
        [self.navigationController.view hideActivityView];
        
        if (parseRuns.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Data to Show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }
        else {
            [self generateWSR];
        }
    }];
}



- (IBAction)getDefectReportPressed:(id)sender {
    runId = [_runIdTF.text intValue];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Defects.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Defects" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    NSLog(@"path = %@",path);
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //here add elements to data file and write data to file
    NSMutableArray *defectsArray = [[NSMutableArray alloc] init];

    for(id key in data) {
        NSMutableDictionary *dictionary = [data objectForKey:key];
        //fetch dictionary elements
        NSLog(@"Dictionary = %@",dictionary);
        NSArray *array = [dictionary objectForKey:@"Defects"];
        for (int i=0; i < [array count]; ++i) {
            NSMutableDictionary *defectData = array[i];
            if ([[defectData objectForKey:@"RunId"] intValue] == runId) {
                NSArray *defectArray = @[[defectData objectForKey:@"Id"], [defectData objectForKey:@"Type"], [defectData objectForKey:@"ProcessName"], [defectData objectForKey:@"Title"], [defectData objectForKey:@"Description"], [defectData objectForKey:@"Operator"], @"-"];
                [defectsArray addObject:defectArray];
            }
        }
    }
    
    if ([defectsArray count] == 0) {
        NSLog(@"No processes");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No reports to show for today" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    NSLog(@"defects array = %@",defectsArray);
    //[self createSheet:processesArray];
    NSString* path1 = [self saveDefectsPDF:defectsArray];
    [self presentPDFWithPath:path1];
}

- (IBAction)getRunReportPressed:(id)sender {
    runId = [_runIdTF.text intValue];
    if (runId == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter RunId to view Report" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
    }
    else
        [self generateRunReport:runData];
}

- (IBAction)getRunChecklistPressed:(id)sender {
    runId = [_runIdTF.text intValue];
    if (runId == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please enter RunId to view Report" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
    }
    else
        [self fetchChecklistForRun];
}

- (IBAction)deleteReportPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Are you sure you want to delete this Report?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];

}

- (void) deleteReport {
    for (int i=0; i < parseRuns.count; ++i) {
        PFObject *parseObject = [parseRuns objectAtIndex:i];
        [parseObject deleteInBackground];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Report Deleted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertView show];
}

- (IBAction)getDailyReportPressed:(id)sender {
    if (!selectedDate) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"Please pick a date to continue" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
    }
    else
        [self fetchParseRuns];
}

- (IBAction)statusReportPressed:(id)sender {
    //[self fetchParseDataForRunsStatus];
    [__ServerManager getRunsList];
}

- (void)generateReport {
    NSMutableArray *processesArray = [[NSMutableArray alloc] init];

    for (int i=0; i < parseRuns.count; ++i) {
        PFObject *parseObject = [parseRuns objectAtIndex:i];
        NSLog(@"parseobject = %@",parseObject);
        NSArray *array = @[[parseObject objectForKey:@"Station"],[parseObject objectForKey:@"ProcessName"], [parseObject objectForKey:@"ProductName"], [parseObject objectForKey:@"Quantity"], [parseObject objectForKey:@"Rework"], [parseObject objectForKey:@"Reject"], [parseObject objectForKey:@"Operator"]];
        [processesArray addObject:array];
        
    }
    NSLog(@"processesArray = %@",processesArray);
    //[self createSheet:processesArray];
    NSString* path1 = [self saveListPDF:processesArray];
    [self presentPDFWithPath:path1];
}

- (void)generateRunReport:(NSMutableDictionary*)runData {
    NSMutableArray *processesArray = [[NSMutableArray alloc] init];
    
        NSArray *array = @[[runData objectForKey:@"PRODUCTION_ID"],[runData objectForKey:@"PRODUCT_NUMBER"], [runData objectForKey:@"INTERNAL_NAME"], [runData objectForKey:@"QUANTITY"], [runData objectForKey:@"REWORK"], [runData objectForKey:@"REJECTIONS"]];
        [processesArray addObject:array];
        
    NSLog(@"processesArray = %@",processesArray);
    //[self createSheet:processesArray];
    NSString* path1 = [self saveRunPDF:processesArray];
    [self presentPDFWithPath:path1];
}

- (void)generateUnitChecklistReport {
    NSMutableArray *processesArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < checklistArray.count; ++i) {
        PFObject *parseObject = [checklistArray objectAtIndex:i];
        NSLog(@"parseobject = %@",parseObject);
        NSArray *array = @[[parseObject objectForKey:@"SensorId"],[parseObject objectForKey:@"EnclosureFitment"], [parseObject objectForKey:@"StickerPrint"], [parseObject objectForKey:@"UnitActivation"], [parseObject objectForKey:@"ReadInApp"], [parseObject objectForKey:@"TempReading"], [parseObject objectForKey:@"TempChanges"],[parseObject objectForKey:@"Logo"],[parseObject objectForKey:@"EnclosureFinishing"],[parseObject objectForKey:@"BatteryStatus"],[parseObject objectForKey:@"UnitCleaning"],[parseObject objectForKey:@"UnitPacking"],[parseObject objectForKey:@"CheckedBy"],[parseObject objectForKey:@"Status"]];
        [processesArray addObject:array];
        
    }
    NSLog(@"processesArray = %@",processesArray);
    //[self createSheet:processesArray];
    NSString* path1 = [self saveChecklistPDF:processesArray];
    [self presentPDFWithPath:path1];
}

- (void)generatePCBChecklistReport {
    NSMutableArray *processesArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < checklistArray.count; ++i) {
        PFObject *parseObject = [checklistArray objectAtIndex:i];
        NSLog(@"parseobject = %@",parseObject);
        NSArray *array = @[[parseObject objectForKey:@"MacAddress"],[parseObject objectForKey:@"VisualInspection"], [parseObject objectForKey:@"SolderSideCheck"], [parseObject objectForKey:@"Flashing"], [parseObject objectForKey:@"CurrentCheck"], [parseObject objectForKey:@"Blinking"],[parseObject objectForKey:@"CheckedBy"],[parseObject objectForKey:@"Status"]];
        [processesArray addObject:array];
        
    }
    NSLog(@"processesArray = %@",processesArray);
    //[self createSheet:processesArray];
    NSString* path1 = [self saveChecklistPDF:processesArray];
    [self presentPDFWithPath:path1];
}

- (void)generateWSR {
    NSMutableArray *processesArray = [[NSMutableArray alloc] init];
    NSLog(@"Generating WSR: %lu",(unsigned long)parseRuns.count);
    for (int i=0; i < parseRuns.count; ++i) {
        NSMutableDictionary *runData = [(Run*)parseRuns[i] getRunData];
        NSLog(@"runData = %@",runData);
        NSArray *array = @[[runData objectForKey:@"Run"],[runData objectForKey:@"Priority"], [runData objectForKey:@"Product"], [runData objectForKey:@"Qty"], [runData objectForKey:@"Shipped"], [runData objectForKey:@"Inprocess"], [runData objectForKey:@"Rework"], [runData objectForKey:@"Reject"], [runData objectForKey:@"Status"]];
        [processesArray addObject:array];
        
    }
    NSLog(@"processesArray = %@",processesArray);
    //[self createSheet:processesArray];
    NSString* path1 = [self saveWSRPDF:processesArray];
    [self presentPDFWithPath:path1];
}

- (void)previewDocument:(NSString*)filePath {
   // NSURL *URL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"pdf"];

    NSURL *URL = [NSURL fileURLWithPath:[filePath stringByAppendingString:@"/Daily Production.xls"]];
    
    if (URL) {
        // Initialize Document Interaction Controller
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [documentInteractionController setDelegate:self];
        
        // Preview PDF
        [documentInteractionController presentPreviewAnimated:YES];
        //[documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 50, 200, 200) inView:self.view animated:YES];

    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (NSString*) saveListPDF:(NSMutableArray*)tableData
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd-MM-yyyy"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Daily Production Report:%@.pdf",[dateFormat1 stringFromDate:selectedDate]]];
    
    [PDFRenderer drawPDF:dataPath forType:ReportSensorList withData:tableData andDate:[dateFormat stringFromDate:selectedDate]];
    return dataPath;
}

- (NSString*) saveRunPDF:(NSMutableArray*)tableData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Production Run Report.pdf"];
    
    [PDFRenderer drawPDF:dataPath forRunId:runId forType:ReportRunList withData:tableData];
    return dataPath;
}

- (NSString*) saveChecklistPDF:(NSMutableArray*)tableData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Production Run Report.pdf"];
    if (runType == 0) {
        [PDFRenderer drawPDF:dataPath forRunId:runId forType:ReportPCBChecklist withData:tableData];
    }
    else {
        [PDFRenderer drawPDF:dataPath forRunId:runId forType:ReportUnitChecklist withData:tableData];
    }
    return dataPath;
}

- (NSString*) saveWSRPDF:(NSMutableArray*)tableData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Weekly Status Report.pdf"];
    
    [PDFRenderer drawPDF:dataPath forType:ReportStatusList withData:tableData];
    return dataPath;
}

- (NSString*) saveDefectsPDF:(NSMutableArray*)tableData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Run Defects Report.pdf"];
    
    [PDFRenderer drawPDF:dataPath forRunId:runId forType:ReportDefectList withData:tableData];
    return dataPath;
}

- (void) presentPDFWithPath:(NSString*)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    documentInteractionController.delegate = self;
    
    [documentInteractionController presentPreviewAnimated:YES];
}

- (IBAction)dateButtonPressed:(id)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd MM yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20 01 2012"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 260, 300, 320);
    [self.view addSubview:calendar];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_runIdTF resignFirstResponder];
        [self getRunData];
        return NO;
    }
    return YES;
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
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd MMM yyyy"];
    NSString *dateString = [dateFormat1 stringFromDate:date];
    [calendar removeFromSuperview];
    selectedDate = date;
    [_dateButton setTitle:dateString forState:UIControlStateNormal];
    [self fetchParseRuns];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            [self deleteReport];
        }
            break;
        default:
            break;
    }
}


- (void)getRunData {
    [self.navigationController.view showActivityViewWithLabel:@"fetching Run Detail"];
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
        if(json.count > 0) {
            runData = json[0];
            if ([runData[@"INTERNAL_NAME"] containsString:@"PCB"]) {
                runType = 0;
            }
            else {
                runType = 1;
            }
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Report found" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alertView show];
        }

    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json dict = %@",json);
    }
}


- (void) parseJsonResponse:(NSData*)jsonData {
    
}


@end
