//
//  Run.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 03/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defect.h"
//#import <Realm/Realm.h>
#import "Job.h"
#import "Product.h"
#import "Process.h"

/*RLM_ARRAY_TYPE(Job)
RLM_ARRAY_TYPE(Process)*/

@interface Run : NSObject {
    NSMutableArray *runJobs;
    NSMutableArray *runProcesses;
    NSMutableArray *runDefects;
    NSMutableArray *runFeedbacks;
    NSMutableArray *runPartsShort;
    NSMutableDictionary *runData;
}
@property NSInteger runId;
@property NSInteger quantity;
@property NSInteger ready;
@property NSInteger inProcess;
@property NSInteger shipped;
@property NSInteger reject;
@property NSInteger rework;
@property NSInteger productId;
@property NSInteger priority;
@property NSInteger sequence;
@property NSInteger category;
@property NSString *runType;
@property NSString *productName;
@property NSString *productNumber;
@property NSString *vendorName;
@property NSString *requestDate;
@property NSString *runDate;
@property NSString *status;
@property NSString *shipping;
@property NSString *detail;
@property BOOL activated;

//@property RLMArray<Job> *jobs;
//@property RLMArr;ay<Process> *processes;

- (void)updateRunStatus:(NSString*)statusString;
- (void)updateRunStatus:(NSString*)statusString withQty:(int)quantity andTag:(int)tag;
- (void)setRunData:(NSDictionary*)runData;
- (void)updateRunData:(NSDictionary*)runData;
- (NSMutableDictionary*)getRunData;
- (void)setRunJobs:(NSMutableArray*)jobsArray;
- (void)setRunProcesses:(NSMutableArray*)prcessesArray;
- (void)setRunDefects:(NSMutableArray*)defectsArray;
- (void)setJobDetail:(NSMutableDictionary*)jobDetail ForJobId:(NSString*)jobId;
- (void)setSequenceNum:(int)sequence_;
- (NSMutableArray*)getRunJobs;
- (NSMutableArray*)getRunJobsForType:(int)type;
- (NSMutableArray*)getRunProcesses;
- (NSMutableArray*)getRunDefects;
- (NSMutableArray*)getRunDefectsForType:(int)type;
- (NSMutableArray*)getRunDefectsForJobId:(NSString*)jobId;
- (int)getRunId;
- (int)getProductId;
- (NSString*)getProductNumber;
- (int)getQuantity;
- (int)getReject;
- (int)getRework;
- (int)getPriority;
- (int)getBatchCount;
- (NSString*)getRunType;
- (BOOL)isActivated;
- (NSString*)getProductName;
- (NSString*)getVendorName;
- (NSString*)getRequestDate;
- (NSString*)getRunDate;
- (NSString*)getStatus;
- (NSString*)getDescription;
- (void)generateJobs;
- (void)addDefect:(Defect*)defect;
- (void)addDefect:(Defect*)defect forJobId:(NSString*)jobId_;
- (void)updateDefect:(Defect*)defect forJobId:(NSString*)jobId_;
- (void)setCategory:(int)category_;
- (int)getCategory;
- (NSMutableArray*)getRunFeedbacks;
- (void)addRunFeedback:(NSMutableDictionary*)feedbackData;
- (NSMutableArray*)getRunPartsShort;
- (void)setRunPartsShort:(NSMutableArray*)partsShortArray;
@end
