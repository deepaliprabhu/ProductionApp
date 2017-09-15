//
//  Checklist.h
//  ProductionApp
//
//  Created by Deepali Prabhu on 14/08/15.
//  Copyright (c) 2015 Aginova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject {
    int checklistId;
    NSString *checklistText;
}
- (void)setChecklistData:(NSMutableDictionary*)checklistData;
- (int)getChecklistId;
- (NSString*)getChecklistText;
@end
