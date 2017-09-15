//
//  PDFRenderer.m
//  iCelsius
//
//  Created by Andrei Ghidoarca on 12/06/14.
//  Copyright (c) 2014 Aginova Inc. All rights reserved.
//

#import "PDFRenderer.h"
#import "CoreText/CoreText.h"
#import <UIKit/UIKit.h>
#import "Defines.h"
#import "User.h"
//#import "CoreDataManager.h"

@implementation PDFRenderer

#pragma mark - Public

+ (void) drawPDF:(NSString*)fileName forType:(ReportType)type withData:(NSMutableArray*)data_ andDate:(NSString*)dateString
{
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 750, 1000), nil);
    
    cstr nib = [self nibForType:type];
    //[self drawLogoForNib:nib];
    [self drawViewsForNib:nib withDate:dateString];
    
    /*if (type == ReportRecord)
        [self drawRecord:extra];
    else if (type == ReportLibrary)
        [self drawLibraryTableFromDate:extra];
    else*/
    [self drawSensorsListTable:data_];
    
    
    UIGraphicsEndPDFContext();
}

+ (void) drawPDF:(NSString*)fileName forType:(ReportType)type withData:(NSMutableArray*)data_
{
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 750, 1000), nil);
    
    cstr nib = [self nibForType:type];
    //[self drawLogoForNib:nib];
    [self drawViewsForNib:nib withDate:nil];
    [self drawWSRListTable:data_];
    UIGraphicsEndPDFContext();
}

+ (void) drawPDF:(NSString*)fileName forRunId:(int)runId_ forType:(ReportType)type withData:(NSMutableArray*)data_
{
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    int pageCount = [data_ count]/30;
    if (pageCount*30 < [data_ count]) {
        pageCount++;
    }
    if (pageCount == 0) {
        pageCount = 1;
    }
    NSLog(@"pageCount=%d",pageCount);
    if (type == ReportUnitChecklist) {
        for (int i=1; i <= pageCount; ++i) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 750, 1000), nil);
            
            cstr nib = [self nibForType:type];
            [self drawLogoForNib:nib];
            [self drawViewsForNib:nib forRunId:runId_];
            [self drawUnitChecklistTable:data_ pageIndex:i-1];
        }
    }
    else if (type == ReportPCBChecklist) {
        for (int i=1; i <= pageCount; ++i) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 750, 1000), nil);
            
            cstr nib = [self nibForType:type];
            [self drawLogoForNib:nib];
            [self drawViewsForNib:nib forRunId:runId_];
            [self drawPCBChecklistTable:data_ pageIndex:i-1];
        }
    }
    else {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 750, 1000), nil);
        cstr nib = [self nibForType:type];
        [self drawLogoForNib:nib];
        [self drawViewsForNib:nib forRunId:runId_];
        
        if (type == ReportDefectList)
            [self drawDefectsListTable:data_];
        else if (type == ReportRunList)
            [self drawRunListTable:data_];
        else
            [self drawSensorsListTable:data_];
    }
    
    
    
    
    UIGraphicsEndPDFContext();
}

#pragma mark - Private drawings


+ (void) drawSensorsListTable:(NSMutableArray*)data_
{
    //carr products = [CoreDataManager getProducts];
    
    cp origin = ccp(90, 250);
    int rowHeight = 20;
    carr cWidth = @[@(70), @(110), @(145), @(52), @(52), @(52), @(90)];
    carr lPadd  = @[@(5), @(5), @(5), @(5), @(5), @(5), @(5)];
    carr tPadd  = @[@(15), @(15), @(15), @(15), @(15), @(15), @(15)];
    NSUInteger numberOfRows = [data_ count] + 1;
    int numberOfColumns = 7;
    
    NSArray *headers = @[@"STATION", @"PROCESS", @"PRODUCT", @"QUANTITY", @"REWORK", @"REJECT", @"OPERATOR"];
    NSMutableArray *tableData = [NSMutableArray arrayWithObject:headers];
    [data_ enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        [tableData addObject:array];
    }];
    
    [self drawTableWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth width:660 numberOfRows:numberOfRows];
    [self drawTableDataWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth lP:lPadd tp:tPadd data:tableData];
}

+ (void) drawWSRListTable:(NSMutableArray*)data_
{
    //carr products = [CoreDataManager getProducts];
    
    cp origin = ccp(90, 250);
    int rowHeight = 20;
    carr cWidth = @[@(50), @(50), @(160), @(40), @(40), @(40), @(40), @(40), @(50)];
    carr lPadd  = @[@(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5)];
    carr tPadd  = @[@(15), @(15), @(30), @(15), @(15), @(15), @(15), @(15), @(15)];
    NSUInteger numberOfRows = [data_ count] + 1;
    int numberOfColumns = 9;
    
    NSArray *headers = @[@"Run ID", @"Priority", @"Product Name", @"Quantity", @"Shipped", @"Ready", @"In Process", @"Rejects", @"Status"];
    NSMutableArray *tableData = [NSMutableArray arrayWithObject:headers];
    [data_ enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        [tableData addObject:array];
    }];
    
    [self drawTableWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth width:600 numberOfRows:numberOfRows];
    [self drawTableDataWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth lP:lPadd tp:tPadd data:tableData];
}


+ (void) drawUnitChecklistTable:(NSMutableArray*)data_ pageIndex:(int)index_
{
    //carr products = [CoreDataManager getProducts];
    
    cp origin = ccp(90, 250);
    int rowHeight = 20;
    carr cWidth = @[@(50), @(50), @(40), @(50), @(40), @(40), @(40), @(40), @(50), @(40),@(50),@(40),@(40),@(40)];
    carr lPadd  = @[@(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5)];
    carr tPadd  = @[@(15), @(15), @(15),@(15), @(15), @(15), @(15), @(15), @(15), @(15), @(15), @(15), @(15), @(15)];
    NSUInteger numberOfRows = 30+1;
    int numberOfColumns = 14;
    
    NSArray *headers = @[@"SENSOR ID", @"ENCLOSURE FITMENT",@"STICKER PRINT", @"UNIT ACTIVATION", @"READ IN APP", @"TEMP READING", @"TEMP CHANGES", @"LOGO", @"ENCLOSURE FINISHING", @"BATTERY STATUS", @"UNIT CLEANING", @"UNIT PACKING", @"CHECKED BY", @"STATUS"];
    NSMutableArray *tableData = [NSMutableArray arrayWithObject:headers];
    [data_ enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        if ((idx >= (30*index_))&&(idx < (30*(index_+1)))) {
            [tableData addObject:array];
        }
    }];
    
    [self drawTableWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth width:700 numberOfRows:numberOfRows];
    [self drawTableDataWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth lP:lPadd tp:tPadd data:tableData];
}

+ (void) drawPCBChecklistTable:(NSMutableArray*)data_ pageIndex:(int)index_
{
    //carr products = [CoreDataManager getProducts];
    
    cp origin = ccp(90, 250);
    int rowHeight = 20;
    carr cWidth = @[@(70), @(60), @(60), @(60), @(60), @(60), @(60), @(50)];
    carr lPadd  = @[@(5), @(5), @(5), @(5), @(5), @(5), @(5), @(5)];
    carr tPadd  = @[@(15), @(15), @(15),@(15), @(15), @(15), @(15), @(15)];
    NSUInteger numberOfRows = 30+1;
    int numberOfColumns = 8;
    
    NSArray *headers = @[@"MAC ADDRESS", @"VISUAL INSPECTION",@"SOLDER SIDE CHECK", @"FLASHING", @"CURRENT CHECK", @"BLINKING", @"CHECKED BY", @"STATUS"];
    NSMutableArray *tableData = [NSMutableArray arrayWithObject:headers];
    [data_ enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        if ((idx >= (30*index_))&&(idx < (30*(index_+1)))) {
            [tableData addObject:array];
        }
    }];
    
    [self drawTableWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth width:570 numberOfRows:numberOfRows];
    [self drawTableDataWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth lP:lPadd tp:tPadd data:tableData];
}


+ (void) drawRunListTable:(NSMutableArray*)data_
{
    //carr products = [CoreDataManager getProducts];
    
    cp origin = ccp(90, 250);
    int rowHeight = 20;
    carr cWidth = @[@(70), @(90), @(190), @(50), @(50), @(50)];
    carr lPadd  = @[@(5), @(5), @(5), @(5), @(5), @(5)];
    carr tPadd  = @[@(15), @(15), @(15), @(15), @(15), @(15)];
    NSUInteger numberOfRows = [data_ count] + 1;
    int numberOfColumns = 6;
    
    NSArray *headers = @[@"RUN ID", @"PRODUCT ID", @"PRODUCT NAME", @"QUANTITY", @"REWORK", @"REJECT"];
    NSMutableArray *tableData = [NSMutableArray arrayWithObject:headers];
    [data_ enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        [tableData addObject:array];
    }];
    
    [self drawTableWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth width:590 numberOfRows:numberOfRows];
    [self drawTableDataWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth lP:lPadd tp:tPadd data:tableData];
}

+ (void) drawDefectsListTable:(NSMutableArray*)data_
{
    //carr products = [CoreDataManager getProducts];
    
    cp origin = ccp(40, 250);
    int rowHeight = 70;
    carr cWidth = @[@(55), @(70), @(120), @(120), @(170), @(80), @(60)];
    carr lPadd  = @[@(5), @(30), @(5), @(5), @(5), @(5), @(5)];
    carr tPadd  = @[@(25), @(25), @(25), @(25), @(25), @(25), @(25)];
    NSUInteger numberOfRows = [data_ count] + 1;
    int numberOfColumns = 7;
    
    NSArray *headers = @[@"Defect ID", @"Type", @"Process Name" ,@"Title", @"Description", @"Operator name", @"Status"];
    NSMutableArray *tableData = [NSMutableArray arrayWithObject:headers];
    [data_ enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        [tableData addObject:array];
    }];
    
    [self drawTableWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth width:715 numberOfRows:numberOfRows];
    [self drawTableDataWithOrigin:origin rH:rowHeight nC:numberOfColumns cW:cWidth lP:lPadd tp:tPadd data:tableData];
}

+ (void) drawText:(NSString*)text atPoint:(CGPoint)origin withFont:(UIFont*)font
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    [text drawAtPoint:origin withFont:font];
}

+ (void) drawAngledText:(NSString*)text withFont:(UIFont*)font
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 0.2);
    CGContextSaveGState(context);
    CGContextRotateCTM(context, -(M_PI/3));
    [text drawAtPoint:ccp(-650, 430) withFont:font];
    CGContextRestoreGState(context);
}

+ (void) drawViewWithFrame:(CGRect)frame
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    [self drawLineFromPoint:frame.origin toPoint:ccp(frame.origin.x+frame.size.width, frame.origin.y)];
}

+ (void) drawText:(NSString*)textToDraw
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(currentText);
    CFRelease(frameRef);
    CFRelease(framesetter);
}

+ (void) drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0, 0, 0, 1};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

+ (void) drawImage:(UIImage*)image inRect:(CGRect)rect
{
    [image drawInRect:rect];
}

+ (void) drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect isHeader:(BOOL)header
{
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef str = CFAttributedStringCreate(NULL, (__bridge CFStringRef)textToDraw, NULL);
    CFMutableAttributedStringRef currentText = CFAttributedStringCreateMutableCopy(NULL, textToDraw.length, str);
    
    // set font
    CTFontRef font;
    if (header)
        font = CTFontCreateWithName((CFStringRef)@"Helvetica-Bold", 7, nil);
    else
        font = CTFontCreateWithName((CFStringRef)@"Helvetica", 6, nil);
    
    CFAttributedStringSetAttribute(currentText,CFRangeMake(0, textToDraw.length),kCTFontAttributeName,font);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    CFRelease(currentText);
    CFRelease(frameRef);
    CFRelease(framesetter);
}

+ (void) drawViewsForNib:(NSString*)nib withDate:(NSString*)dateString
{
    NSArray* objects  = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    UIView * mainView = [objects objectAtIndex:0];
    UIFont *font = [UIFont systemFontOfSize:15];
    for (UIView* view in [mainView subviews])
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            if (label.tag == 10)
                [self drawAngledText:label.text withFont:label.font];
            else if (label.tag == 20)
            {
                cstr text = dateString;
                cs size = [text sizeWithFont:label.font constrainedToSize:ccs(MAXFLOAT, 30)];
                [self drawText:text atPoint:ccp(660-size.width, label.frame.origin.y) withFont:label.font];
            }
            else if (label.tag == 30)
            {
                cstr text = @"246";
                cs size = [text sizeWithFont:label.font constrainedToSize:ccs(MAXFLOAT, 30)];
                [self drawText:text atPoint:label.frame.origin withFont:label.font];
            }
            else
                [self drawText:label.text atPoint:label.frame.origin withFont:label.font];
        }
        else if ([view isKindOfClass:[UIView class]])
            [self drawViewWithFrame:view.frame];
    }
}

+ (void) drawViewsForNib:(NSString*)nib forRunId:(int)runId
{
    NSArray* objects  = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    UIView * mainView = [objects objectAtIndex:0];
    UIFont *font = [UIFont systemFontOfSize:15];
    for (UIView* view in [mainView subviews])
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            if (label.tag == 10)
                [self drawAngledText:label.text withFont:label.font];
            else if (label.tag == 20)
            {
                cstr text = [__User getDateString];
                cs size = [text sizeWithFont:label.font constrainedToSize:ccs(MAXFLOAT, 30)];
                [self drawText:text atPoint:ccp(660-size.width, label.frame.origin.y) withFont:label.font];
            }
            else if (label.tag == 30)
            {
                cstr text = [NSString stringWithFormat:@"%d",runId];
                cs size = [text sizeWithFont:label.font constrainedToSize:ccs(MAXFLOAT, 30)];
                [self drawText:text atPoint:label.frame.origin withFont:label.font];
            }
            else
                [self drawText:label.text atPoint:label.frame.origin withFont:label.font];
        }
        else if ([view isKindOfClass:[UIView class]])
            [self drawViewWithFrame:view.frame];
    }
}


+ (void)drawLogoForNib:(NSString*)nib
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews])
    {
        if([view isKindOfClass:[UIImageView class]])
            [self drawImage:ccimg(@"Default.png") inRect:view.frame];
    }
}

+ (void) drawTableWithOrigin:(CGPoint)origin rH:(float)rowHeight nC:(int)numberOfColumns cW:(NSArray*)cWidth width:(float)width numberOfRows:(NSUInteger)numberOfRows
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    float yOffset = origin.y;
    for (int i = 0; i <=numberOfRows; i++)
    {
        CGPoint from = CGPointMake(origin.x, yOffset);
        CGPoint to = CGPointMake(width, yOffset);
        
        [self drawLineFromPoint:from toPoint:to];
        
        if (i!=numberOfRows)
            yOffset += (i==0?rowHeight+20:rowHeight);
    }
    
    float tableHeight = numberOfRows*rowHeight+20;
    float xOffset = origin.x;
    for (int i = 0; i <=numberOfColumns; i++)
    {
        CGPoint from = CGPointMake(xOffset, origin.y);
        CGPoint to = CGPointMake(xOffset, origin.y+tableHeight);
        
        [self drawLineFromPoint:from toPoint:to];
        
        if (i!=numberOfColumns)
            xOffset += [cWidth[i] floatValue];
    }
}

+ (void) drawTableDataWithOrigin:(cp)origin rH:(float)rowHeight nC:(int)numberOfColumns cW:(carr)cWidth lP:(carr)leftPaddings tp:(carr)topPaddings data:(NSArray*)allInfo
{
    float yOffset = origin.y + rowHeight + 20;
    for (int i=0;i<[allInfo count];i++)
    {
        int extraY = (i==0)?20:0;
        
        NSArray *infoToDraw = allInfo[i];
        float xOffset = origin.x;
        for (int j=0;j<numberOfColumns;j++)
        {
            int leftPadding = (i==0)?[leftPaddings[j] floatValue]:4;
            int topPadding  = (i==0)?[topPaddings[j] floatValue]:4;
            float width = [cWidth[j] floatValue];
            
            CGRect frame = CGRectMake(xOffset + leftPadding, yOffset + topPadding, width, rowHeight+extraY);
            [self drawText:infoToDraw[j] inFrame:frame isHeader:i==0];
            
            xOffset += width;
        }
        
        yOffset += rowHeight;
    }
}

#pragma mark - Private utils

+ (NSString*) nibForType:(ReportType)type
{
    cstr nib = @"";
    if (type == ReportDefectList)
        nib = @"DefectsReport";
    else if (type == ReportRunList)
        nib = @"RunReport";
    else if (type == ReportUnitChecklist)
        nib = @"ChecklistReport";
    else if (type == ReportPCBChecklist)
        nib = @"ChecklistReport";
    else if (type == ReportStatusList)
        nib = @"WSRReport";
    else
        nib = @"ListReport";
    
    return nib;
}

+ (NSString*) runTimeForDate:(NSDate*)date
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm:ss  MM-dd-yyyy"];
    cstr text = [f stringFromDate:date];
    return text;
}

+ (NSString*) reportDateForDate:(NSDate*)date
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm:ss MMM dd, yyyy"];
    cstr text = [f stringFromDate:date];
    return text;
}

/*+ (NSArray*) infoForProduct:(Product*)product
{
    carr info = nil;
    
    cstr name = (product.name!=nil)?product.name:@"";
    if ([product.isWireless boolValue])
    {
        cstr net  = (product.wifiNetwork!=nil)?product.wifiNetwork:@"";
        cstr cV   = (product.codeVersion!=nil)?product.codeVersion:@"";
        cstr mac  = (product.mac!=nil)?product.mac:@"";
        if (product.sensorID != nil)
            info = @[product.sensorID, name, [product.type description], cV, mac, cstrf(@"%@V", product.batteryVoltage), cstrf(@"%@dBm", product.rssi), [product.commMode description], net];
    }
    else
        info = @[@"-", name, [product.type description], @"-", @"-", @"-", @"-", @"-", @"-"];
    
    return info;
}*/

@end
