//
//  GraphData.m
//  SentinelNext
//
//  Created by Deepali Prabhu on 21/04/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "GraphData.h"

@implementation GraphData

- (void) setTitle:(NSString*)title_ {
    title = title_;
}

- (NSString*) getTitle {
    return title;
}

- (void) setTimeString:(NSString*)timeString_ {
    timeString = timeString_;
}

- (NSString*) getTimeString {
    return timeString;
}

- (void) setAggregateValue:(int)aggregateValue_ {
    aggregateValue = aggregateValue_;
}

- (int) getAggregateValue {
    return aggregateValue;
}

- (void) setPlotArray:(NSMutableArray*)plotArray_ {
    plotArray = plotArray_;
}

- (NSMutableArray*) getPlotArray {
    return plotArray;
}

- (void) setTimestampArray:(NSMutableArray*)timestampArray_ {
    timestampArray = timestampArray_;
}

- (NSMutableArray*) getTimestampArray {
    return timestampArray;
}

- (void) setDateArray:(NSMutableArray*)dateArray_ {
    dateArray = dateArray_;
}

- (NSMutableArray*) getDateArray {
    return dateArray;
}

@end
