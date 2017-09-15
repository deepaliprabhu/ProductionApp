//
//  AddDefectViewController.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 27/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "AddDefectViewController.h"
#import "Defect.h"
#import "DataManager.h"

@interface AddDefectViewController ()

@end

@implementation AddDefectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add Defect";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    defectTypeArray = [NSArray arrayWithObjects:@"Electronics", @"Mechanical", @"Machine", @"Firmware",nil];
    defectTypeImgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"electronics.png"], [UIImage imageNamed:@"mechanical.png"], [UIImage imageNamed:@"machine.png"], [UIImage imageNamed:@"firmware.png"], nil];
    if (defect) {
        _statsView.hidden = false;
        _titleTextView.text = [defect getText];
        _detailTextView.text = [defect getDetailText];
        selectedJobType = [defect getDefectType];
        [defectTypeButton setTitle:[defectTypeArray objectAtIndex:selectedJobType] forState:UIControlStateNormal];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[defectTypeImgArray objectAtIndex:selectedJobType]];
        imgView.frame = CGRectMake(defectTypeButton.frame.size.width-60, 5, 22, 22);
        [defectTypeButton addSubview:imgView];
        _timesFoundLabel.text = [NSString stringWithFormat:@"%d",[defect getTimesFound]];
        
        //add saved images
        NSString *aDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

        NSString *photoPath = [aDocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"DefectPhotos"]];
        for (int i =0; i < 3; ++i) {
            NSString *jobPhotoIndex = [NSString stringWithFormat:@"%d_%d",[defect getDefectId],i+1];
            NSString *filePath=[NSString stringWithFormat:@"%@/%@.png", photoPath,jobPhotoIndex];
            NSLog(@"filepath = %@",filePath);
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image) {
                switch (i) {
                    case 0:
                        imageView1.image = image;
                        break;
                    case 1:
                        imageView2.image = image;
                        break;
                    case 2:
                        imageView3.image = image;
                        break;
                    default:
                        break;
                }
                photosAdded++;
            }
        }
    }
    backgroundDimmingView = [self buildBackgroundDimmingView];
    [self.view addSubview:backgroundDimmingView];
    [self.view bringSubviewToFront:_photoView];
    backgroundDimmingView.hidden = true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setJobs:(NSMutableArray*)jobs {
    selectedJobs = [[NSMutableArray alloc] init];
    selectedJobs = jobs;
    NSLog(@"setting selected jobs");
}

- (void) setProcess:(Process*)process_ {
    process = process_;
}

- (void)doneButtonPressed:(id)sender {
    /*Run *run = [__DataManager getRunWithId:[__DataManager getCurrentRunId]];
    if (!defect) {
        defect = [[Defect alloc] init];
        NSString *defectId = [NSString stringWithFormat:@"%d-%u", [run getRunId],[[run getRunDefects] count]+1];
        [defect setDefectId:defectId];
        [run addDefect:defect];
    }
    [defect setDefectType: selectedJobType];
    [defect setDefectText:_titleTextView.text];
    [defect setDefectDetailText:_detailTextView.text];
    
    for (int i=0; i < [selectedJobs count]; ++i) {
        Job *job = selectedJobs[i];
        [run addDefect:defect forJobId:[job getJobId]];
    }*/
    [self.navigationController popViewControllerAnimated:true];
    [self writeDefectData];
}

- (void)writeDefectData {
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
    //here add elements to data file and write data to file

    if (!productData) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:defectId,@"Id", [NSString stringWithFormat:@"%d",[run getRunId]], @"RunId", [run getProductName], @"ProductName", [process getProcessName], @"ProcessName",_titleTextView.text, @"Title", _detailTextView.text, @"Description",[__User getUsername], @"Operator", [NSString stringWithFormat:@"%d",selectedJobType], @"Type", @"Open", @"Status", nil];

        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:dictionary, nil];
        productData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:array, @"Defects", nil];
    }
    else {
        NSMutableArray *array = [productData objectForKey:@"Defects"];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:defectId,@"Id",[run getRunId], @"RunId", [run getProductName], @"ProductName", [process getProcessName], @"ProcessName",_titleTextView.text, @"Title", _detailTextView.text, @"Description", [NSString stringWithFormat:@"%d",selectedJobType], @"Type", [__User getUsername], @"Operator", @"Open", @"Status", nil];
        [array addObject:dictionary];
        [productData setObject:array forKey:@"Defects"];
    }
    [data setObject:productData forKey:[run getProductNumber]];
    NSLog(@"data = %@",data);
    [data writeToFile: path atomically:YES];
}

- (IBAction)addImagePressed:(id)sender {
    if (photosAdded == 3) {
        return;
    }
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}

- (IBAction)imageButtonPressed:(UIButton*)sender {
    if (sender.tag > photosAdded) {
        return;
    }
    _photoView.hidden = false;
    backgroundDimmingView.hidden = false;
    [_photoImageView setImage:sender.imageView.image];
}

- (IBAction)okayButtonPressed:(UIButton*)sender {
    _photoView.hidden = true;
    backgroundDimmingView.hidden = true;
}

- (void)setDefect:(Defect*)defect_ {
    defect = defect_;
}

#pragma mark - JSImagePikcerViewControllerDelegate

- (void)imagePicker:(JSImagePickerViewController *)imagePicker didSelectImage:(UIImage *)image {
    photosAdded++;
    UIButton *button = (UIButton*)[_photoHolderView viewWithTag:photosAdded];
    [button setImage:image forState:UIControlStateNormal];
    NSData *photoData = UIImageJPEGRepresentation(image, 1); // or you can use JPG or PDF
    
    // For test purposes I write the file to the Documents directory, but you can do whatever you want with your new .png file
    NSString *jobPhotoIndex = [NSString stringWithFormat:@"%@_%d",[defect getDefectId],photosAdded];
    NSString *aDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *photoPath = [aDocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"DefectPhotos"]];
    [[NSFileManager defaultManager] createDirectoryAtPath:photoPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *filePath=[NSString stringWithFormat:@"%@/%@.png", photoPath,jobPhotoIndex];
    [photoData writeToFile:filePath atomically:YES];
    NSLog(@"filepath = %@",filePath);
}

- (IBAction)actionMenu:(id)sender {
    NSLog(@"Btn touch");
    if(dropDown == nil) {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :defectTypeArray :defectTypeImgArray :@"down"];
        dropDown.backgroundColor = [UIColor orangeColor];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    dropDown = nil;
}

- (void) selectedListIndex:(int)index {
    dropDown = nil;
    selectedJobType = index;
}

- (IBAction)viewHistoryPressed:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    if (historyVisible) {
        historyVisible = false;
        [_arrowImageView setImage:[UIImage imageNamed:@"up.png"]];
        _statsView.frame = CGRectMake(0, screenRect.size.height - (80), _statsView.frame.size.width, _statsView.frame.size.height);
    }
    else {
        historyVisible = true;
        [_arrowImageView setImage:[UIImage imageNamed:@"down.png"]];
        _statsView.frame = CGRectMake(0, screenRect.size.height-(_statsView.frame.size.height-80), _statsView.frame.size.width, _statsView.frame.size.height);
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_titleTextView resignFirstResponder];
    }
    return true;
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (defect)
        return [[defect getDefectStats] count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"DefectsStatCell";
    
    DefectsStatCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:nil options:nil][0];
    }
    cell.textLabel.text = [[[defect getDefectStats] objectAtIndex:indexPath.row] objectForKey:@"operator"];
    cell.detailTextLabel.text = [[[defect getDefectStats] objectAtIndex:indexPath.row] objectForKey:@"time"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)buildBackgroundDimmingView{
    
    UIView *bgView;
    //blur effect for iOS8
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat frameHeight = screenRect.size.height;
    CGFloat frameWidth = screenRect.size.width;
    CGFloat sideLength = frameHeight > frameWidth ? frameHeight : frameWidth;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = CGRectMake(0, 0, sideLength, sideLength);
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.view.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.9;
    /*if(self.tapBackgroundToDismiss){
     [bgView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
     action:@selector(cancelButtonPressed:)]];
     }*/
    return bgView;
}


@end
