//
//  DefectsListViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 21/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "DefectsListViewController.h"
#import "DataManager.h"
#import "ServerManager.h"
#import "AddDefectViewController.h"

@interface DefectsListViewController ()

@end

@implementation DefectsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Defects";
    if ([[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefects] count]>0) {
        
    }
    else {
    //    [__ServerManager getDefects];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Defects to show" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        //[alertView show];
        //[self.navigationController popViewControllerAnimated:true];
    }
    selectedJobType = 5;
    defectsArray = [[NSMutableArray alloc] init];
    if (selectedJob&&(listType == 0)) {
        defectsArray = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefectsForJobId:[selectedJob getJobId]];
        _jobTypesView.hidden = true;
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y-40, _tableView.frame.size.width, _tableView.frame.size.height);
    }
    else {
        defectsArray = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefects];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightButtonPressed)];

    [self getDefects];
}

- (void) setProcess:(Process*)process_ {
    process = process_;
}

- (void)viewDidAppear:(BOOL)animated {
    /*if (selectedJob&&(listType == 0)) {
        defectsArray = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefectsForJobId:[selectedJob getJobId]];
        _jobTypesView.hidden = true;
    }
    else {
        defectsArray = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefects];
    }
    
    [_tableView reloadData];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setListType:(int)type {
    listType = type;
}

- (void)setSelectedJob:(Job*)job_ {
    selectedJob = job_;
}

- (void)rightButtonPressed{
    AddDefectViewController *addDefectVC = [[AddDefectViewController alloc] initWithNibName:@"AddDefectViewController" bundle:nil];
    [self.navigationController pushViewController:addDefectVC animated:true];
}

- (void) getDefects {
    Run *run = [__DataManager getRunWithId:[__DataManager getCurrentRunId]];
    NSString *defectId = [NSString stringWithFormat:@"%d-%u", [run getRunId],[[run getRunDefects] count]+1];
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
    NSMutableDictionary *productData = [data objectForKey:[run getProductNumber]];
    if (!productData) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"\n" message:@"No Defects listed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        defectsArray = [productData objectForKey:@"Defects"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"defect count = %d",[[[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefects] count]);
    return [defectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DefectsListCell";
    
    DefectsListCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    
    Defect *defect = [[Defect alloc] init];
    [defect setDefectData:defectsArray[indexPath.row]];
    [cell setDefect:defect];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (listType == 1) {
        AddDefectViewController *addDefectVC = [[AddDefectViewController alloc] initWithNibName:@"AddDefectViewController" bundle:nil];
        
        Defect *defect = [[Defect alloc] init];
        [defect setDefectData:defectsArray[indexPath.row]];
        NSMutableDictionary *defectStat = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[__User getUsername],@"operator",@"09/03/2015 04:41PM",@"time", nil];
        [defect addDefectStat:defectStat];
        [addDefectVC setDefect:defect];
        //NSMutableArray *jobs = [[NSMutableArray alloc] initWithObjects:selectedJob, nil];
        //[addDefectVC setJobs:jobs];
        listType = 0;
        [self.navigationController pushViewController:addDefectVC animated:true];
    }
    else {
        AddDefectViewController *addDefectVC = [[AddDefectViewController alloc] initWithNibName:@"AddDefectViewController" bundle:nil];
        Defect *defect = [[Defect alloc] init];
        [defect setDefectData:defectsArray[indexPath.row]];
        [addDefectVC setDefect:defect];
        NSMutableArray *jobs = [[NSMutableArray alloc] initWithObjects:selectedJob, nil];
        [addDefectVC setJobs:jobs];
        [self.navigationController pushViewController:addDefectVC animated:true];
    }
}


- (IBAction)defectTypeButtonPressed:(UIButton*)sender {
    selectedJobType = sender.tag;
    if (sender.tag == 5) {
         defectsArray = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefects];
    }
    else
        defectsArray = [[__DataManager getRunWithId:[__DataManager getCurrentRunId]] getRunDefectsForType:selectedJobType];
    [_tableView reloadData];
    
    switch (sender.tag) {
        case 0:{
            
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
}

@end
