//
//  Process.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 04/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Realm/Realm.h>


@interface Process : NSObject {
    NSMutableArray *subProcesses;
    NSMutableArray *workInstructions;
    NSMutableArray *checklist;
    NSMutableArray *processJobs;
    NSMutableArray *jobsDone;
}
@property NSString *processId;
@property NSString *processName;
@property NSString *startDate;
@property NSString *stopDate;
@property NSInteger status;
@property NSInteger timeLogged;




- (void)setProcessData:(NSDictionary*)processData;
- (NSString*)getProcessId;
- (NSString*)getStartDate;
- (NSString*)getStopDate;
- (void)setWorkInstructions:(NSMutableArray*)instructions;
- (void)setChecklist:(NSMutableArray*)checklist_;
- (void)setProcessStatus:(int)status_;
- (void)setStartDate:(NSString*)startDate_;
- (void)setStopDate:(NSString*)stopDate_;
- (NSString*)getProcessName;
- (NSMutableArray*)getSubProcesses;
- (NSMutableArray*)getWorkInstructions;
- (NSMutableArray*)getChecklist;
- (int)getProcessStatus;
- (NSString*)getProcessStatusDescription;
- (int)getTimeLogged;
- (void)setTimeLogged:(int)time;
- (void)setProcessJobs:(NSMutableArray*)jobs;
- (NSMutableArray*)getProcessJobs;
- (void)finishedJob:(NSString*)jobId;
- (NSMutableArray*)getJobsDone;
@end
