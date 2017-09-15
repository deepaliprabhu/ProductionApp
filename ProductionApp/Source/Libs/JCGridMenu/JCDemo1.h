//
//  JCDemo1.h
//
//  Created by Joseph Carney on 20/07/2012.
//  Copyright (c) 2012 North of the Web. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGridMenuController.h"
#import "Defines.h"

@protocol SearchProtocol;
@interface JCDemo1 : UIViewController <JCGridMenuControllerDelegate, UITextViewDelegate>
{
    
}

@property (nonatomic, strong) JCGridMenuController *gmDemo;
__pd(SearchProtocol);

- (id)init;
- (void)open;
- (void)close;

@end
@protocol SearchProtocol <NSObject>
- (void)searchWithText:(NSString*)text;
- (void)closeSearch;
@end