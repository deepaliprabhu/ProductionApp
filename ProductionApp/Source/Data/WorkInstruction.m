//
//  WorkInstruction.m
//  ProductionApp
//
//  Created by Deepali Prabhu on 11/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import "WorkInstruction.h"

@implementation WorkInstruction

- (void)setInstructionData:(NSDictionary*)instructionData {
   // NSLog(@"setting work instruction text:%@",[instructionData objectForKey:@"description"]);
    instructionId = [[instructionData objectForKey:@"id"] intValue];
    instructionText = [instructionData objectForKey:@"description"];
}

- (int)getInstructionId {
    return instructionId;
}

- (NSString*)getInstructionText {
    return instructionText;
}

@end
