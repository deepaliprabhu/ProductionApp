//
//  PDFRenderer.h
//  iCelsius
//
//  Created by Andrei Ghidoarca on 12/06/14.
//  Copyright (c) 2014 Aginova Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ReportDefectList,
    ReportRunList,
    ReportSensorList,
    ReportStatusList,
    ReportUnitChecklist,
    ReportPCBChecklist
}ReportType;

@interface PDFRenderer : NSObject {
}
@property NSString *runId;
+ (void) drawPDF:(NSString*)fileName forType:(ReportType)type withData:(NSMutableArray*)data_ andDate:(NSString*)dateString;
+ (void) drawPDF:(NSString*)fileName forType:(ReportType)type withData:(NSMutableArray*)data_;
+ (void) drawPDF:(NSString*)fileName forRunId:(int)runId_ forType:(ReportType)type withData:(NSMutableArray*)data_;
@end
