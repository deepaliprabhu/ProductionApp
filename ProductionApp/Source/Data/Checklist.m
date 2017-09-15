//
//  Checklist.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "Checklist.h"

@implementation Checklist
- (void)setChecklistData:(NSMutableDictionary*)checklistData {
    //checklistId = [[checklistData objectForKey:@"id"] intValue];
    checklistText = [checklistData objectForKey:@"description"];
}

- (int)getChecklistId {
    return checklistId;
}

- (NSString*)getChecklistText {
    return checklistText;
}
@end
