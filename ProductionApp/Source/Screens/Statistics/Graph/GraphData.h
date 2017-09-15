//
//  GraphData.h
//  SentinelNext
//
//  Created by Deepali Prabhu on 21/04/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphData : NSObject {
    NSString *title;
    NSString *timeString;
    int aggregateValue;
    NSMutableArray *plotArray;
    NSMutableArray *timestampArray;
    NSMutableArray *dateArray;
}

- (void) setTitle:(NSString*)title_;
- (NSString*) getTitle;
- (void) setTimeString:(NSString*)timeString_;
- (NSString*) getTimeString;
- (void) setAggregateValue:(int)aggregateValue_;
- (int) getAggregateValue;
- (void) setPlotArray:(NSMutableArray*)plotArray_;
- (NSMutableArray*) getPlotArray;
- (void) setTimestampArray:(NSMutableArray*)timestampArray_;
- (NSMutableArray*) getTimestampArray;
- (void) setDateArray:(NSMutableArray*)dateArray_;
- (NSMutableArray*) getDateArray;

@end
