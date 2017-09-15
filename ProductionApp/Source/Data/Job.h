//
//  Job.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 05/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Defect.h"
//#import <Realm/Realm.h>


@interface Job : Product <NSCopying> {
    NSString *jobId;
    int status;
    NSString *startDate;
    NSString *stopDate;
    int jobType;
    int batchId;
    int timeLogged; //time logged in secs
    int processIndex;
    NSMutableArray *jobDefects;
    NSMutableDictionary *jobDetails;
    NSMutableDictionary *jobData;
    BOOL marked;
}
//@property NSInteger jid;


- (void)setJobData:(NSMutableDictionary*)jobData_;
- (void)setJobDetail:(NSMutableDictionary*)jobDetail;
- (void)setStatus:(int)status_;
- (void)setJobType:(int)type;
- (void)setProductId:(NSString*)productId_;
- (void)setTimeLogged:(int)time ;
- (void)setBatchId;
- (int)getBatchId;
- (void)setJobId:(NSString*)jobId_;
- (NSString*)getJobId;
- (int)getJobStatus;
- (NSString*)getStartDate;
- (NSString*)getStopDate;
- (void)setStartDate:(NSString*)startDate_;
- (void)setStopDate:(NSString*)startDate_;
- (void)addJobDefect:(Defect*)defect;
- (void)addDefect:(Defect*)defect forJobId:(NSString*)jobId_;
- (NSMutableArray*)getJobDefects;
- (NSMutableDictionary*)getJobDetails;
- (NSMutableDictionary*)getJobData;
- (int)getJobType;
- (int)getTimeLogged;
- (BOOL)isMarked;
- (void)setProcessIndex:(int)processIndex_;
- (int)getProcessIndex;
@end
