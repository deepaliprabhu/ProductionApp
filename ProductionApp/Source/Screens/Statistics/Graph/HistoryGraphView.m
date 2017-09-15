//
//  HistoryGraphView.m
//  SentinelNext
//
//  Created by Aginova on 24/11/14.
//  Copyright (c) 2014 Aginova. All rights reserved.
//

#import "HistoryGraphView.h"
#import "DataManager.h"
#import "Plot.h"
#import "PNColor.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)


@implementation HistoryGraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
__CREATEVIEW(HistoryGraphView, @"HistoryGraphView", 0);

- (void)initLayout {
  //  timestampArray = [graphData getTimestampArray];
    aggregate = 60*60*24;
    //dateArray = [graphData getDateArray];
    thresholdMinVal = -2000;
    thresholdMaxVal = -2000;
    graphScaleX = 1;
    graphScaleY = 1;
    tempArray = [[NSMutableArray alloc] init];
    temp1Array = [[NSMutableArray alloc] init];
    humidityArray = [[NSMutableArray alloc] init];
    alarms = [[NSMutableArray alloc] init];
    alarmStartDates = [[NSMutableArray alloc] init];
    alarmPinned = [[NSMutableArray alloc] init];
    alarmIndices = [[NSMutableArray alloc] init];

    detailsView.layer.cornerRadius = 5.0f;
    detailsView.layer.borderColor = [UIColor blackColor].CGColor;
    detailsView.layer.borderWidth = 0.5f;
    detailsButton.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
    
    //[self createPlotWithIdentifier:@"Quantity" andColor:[UIColor purpleColor] andData:quantityArray];
    [self initGraph];
    if (graphType == 1) {
        expandButton.hidden = true;
        zoomButton.hidden = true;
    }
}

- (void)setStatsDataArray:(NSMutableArray*)statsArray {
    timestampArray = [[NSMutableArray alloc] init];
    quantityArray = [[NSMutableArray alloc] init];
    dateArray = [[NSMutableArray alloc] init];
    plots = [[NSMutableArray alloc] init];
    aggregate = 1;
    statsDataArray = statsArray;
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (int i =statsDataArray.count-1; i >= 0; --i) {
        NSMutableDictionary *statsData = statsDataArray[i];
        [quantityArray addObject:statsData[@"TotalQuantity"]];
        [timeArray addObject:statsData[@"TotalTime"]];
        [timestampArray addObject:statsData[@"Date"]];
    }
    NSLog(@"tistamp array :%@",timestampArray);
    [self createPlotWithIdentifier:@"Quantity" andColor:[UIColor purpleColor] andData:quantityArray];
    [self createPlotWithIdentifier:@"Time" andColor:[UIColor whiteColor] andData:timeArray];
}

- (void)reverseArray:(NSMutableArray*)array {
    
}

- (void)initWithGraphData:(GraphData*)graphData_ {
    graphData = graphData_;
   // timestampArray = [graphData getTimestampArray];
    aggregate = [graphData getAggregateValue];
    dateArray = [graphData getDateArray];
    [_selectedGraphButton setTitle:[graphData getTitle] forState:UIControlStateNormal];
    timeperiodLabel.text = [graphData getTimeString];
    [self initLayout];
}

- (void)setGraphType:(int)type {
    graphType = type;
}

- (void)initGraph {
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    [hostView removeFromSuperview];
    if (graphType == 0) {
            hostView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 40, 310, 220)];
        
    }
    else {
        hostView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 40, 550, 280)];
        xAxisSeparatorView.hidden = true;
    }
    hostView.backgroundColor = [UIColor clearColor];
    hostView.allowPinchScaling = true;
    [self addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    // 1 - Create the graph
    CGRect bounds = hostView1.bounds;
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    hostView.hostedGraph = graph;
    
    // 2 - Set graph title
    NSString *title = @"";
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 10.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTopLeft;
    graph.titleDisplacement = CGPointMake(50.0f, 15.0f);
    // 4 - Set padding for plot area
    if (graphType == 0) {
        [graph.plotAreaFrame setPaddingLeft:0.0f];
        [graph.plotAreaFrame setPaddingBottom:15.0f];
        [graph.plotAreaFrame setPaddingTop:5.0f];
    }
    else {
        [graph.plotAreaFrame setPaddingLeft:0.0f];
        [graph.plotAreaFrame setPaddingBottom:15.0f];
        [graph.plotAreaFrame setPaddingTop:5.0f];
    }
    
    graph.plotAreaFrame.borderLineStyle = nil;
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    //plotSpace.yScaleType = CPTScaleTypeLog;
    
    
    
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    
    //Add Threshold plots
    CPTScatterPlot* thresholdMin = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    thresholdMin.dataSource = self;
    thresholdMin.delegate = self;
    thresholdMin.identifier = @"ThresholdMin";
    
    CPTScatterPlot* thresholdMax = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    thresholdMax.dataSource = self;
    thresholdMax.delegate = self;
    thresholdMax.identifier = @"ThresholdMax";
    
    if (thresholdMaxVal > -2000) {
        // [graph addPlot:thresholdMax toPlotSpace:plotSpace];
    }
    
    if (thresholdMinVal > -2000) {
        // [graph addPlot:thresholdMin toPlotSpace:plotSpace];
    }
    
    
    /* CPTMutableLineStyle *thresholdLineStyle = [plot.dataLineStyle mutableCopy];
     thresholdLineStyle.lineWidth = 0.5;
     thresholdLineStyle.lineColor = [CPTColor redColor];
     
     thresholdMin.dataLineStyle = thresholdLineStyle;
     thresholdMax.dataLineStyle = thresholdLineStyle;*/
    
    for (int i =0; i < [plots count]; ++i) {
        Plot *myPlot = [plots objectAtIndex:i];
        CPTColor *plotColor = [CPTColor whiteColor];
        CPTMutableLineStyle *plotLineStyle = [myPlot.dataLineStyle mutableCopy];
        plotLineStyle.lineWidth = 1.5;
        plotLineStyle.lineColor = plotColor;
        myPlot.plotSymbolMarginForHitDetection = 20.0f;
        plotLineStyle.lineColor = (CPTColor *)[myPlot plotColor];
        myPlot.dataLineStyle = plotLineStyle;
        [graph addPlot:myPlot toPlotSpace:plotSpace];
        /*CPTColor *areaColor = [CPTColor blueColor];
         CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor redColor]];
         [areaGradient setAngle:-90.0f];
         CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
         myPlot.areaFill = areaGradientFill;
         myPlot.areaBaseValue = CPTDecimalFromInteger(0);*/
    }
    Plot *myPlot = [plots objectAtIndex:0];
    myPlot.hidden = false;
    
    //    if ([humidityArray count]>0) {
    //        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:plot,plot2, nil]];
    //    }
    //    //else
    [self configureAxes];
    
    
    //plotSpace.yScaleType = CPTScaleTypeLog;
    // plotSpace.yRange     = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(100.0) length:CPTDecimalFromDouble(-199.9)];
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:[plots objectAtIndex:0],[plots objectAtIndex:1], nil]];
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:[NSNumber numberWithFloat:3.0]];
    plotSpace.yRange = yRange;
    
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:[NSNumber numberWithFloat:1.5]];
    plotSpace.xRange = xRange;
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 10.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [CPTColor yellowColor];
    
    CPTMutableTextStyle *axisTextStyle = [CPTMutableTextStyle textStyle];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 8.0f;
    axisTextStyle.textAlignment = NSTextAlignmentCenter;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 1.2f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor whiteColor];
    gridLineStyle.lineWidth = 0.2f;
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineColor = [CPTColor whiteColor];
    minorGridLineStyle.lineWidth = 0.1f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    CPTXYAxis *x = axisSet.xAxis;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm MMM dd, yyyy"];
    
    NSDateFormatter *refdateFormatter = [[NSDateFormatter alloc] init];
    [refdateFormatter setDateFormat:@"dd mm yyyy"];
    NSDate *refDate = [refdateFormatter dateFromString:[timestampArray objectAtIndex:0]];

    
    NSTimeInterval oneDay = aggregate * 60;
    x.majorIntervalLength         = [NSNumber numberWithLong:oneDay];
    //x.orthogonalPosition = [NSNumber numberWithInt:2];
    x.minorTicksPerInterval       = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (aggregate == 60*24*60)
        [dateFormatter setDateFormat:@"dd MMM, yyyy"];
    else if (aggregate == 60*24*7)
        [dateFormatter setDateFormat:@"dd MMM, HH:mm"];
    else
        [dateFormatter setDateFormat:@"dd MMM, HH:mm"];
    NSLog(@"refdate=%@",[dateFormatter stringFromDate:refDate]);

    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = refDate;
    x.labelFormatter            = timeFormatter;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    NSTimeInterval xLow = 0.0f;
    // sets the range of x values
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) hostView.hostedGraph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:xLow] length:[NSNumber numberWithFloat:(oneDay*[timestampArray count])]];
    
    x.title = @"";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = tickLineStyle;
    x.minorTickLineStyle = tickLineStyle;
    x.majorTickLength = 3.0f;
    x.minorTickLength = 1.0f;
    
    x.tickDirection = CPTSignNegative;
    NSLog(@"timestamp array = %@",timestampArray);
    CGFloat dateCount = [timestampArray count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
     NSMutableSet *xMajorLocations = [NSMutableSet set];
     NSMutableSet *xMinorLocations = [NSMutableSet set];
     for (int i=0; i < [timestampArray count]; ++i) {
     CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[timestampArray objectAtIndex:i]  textStyle:x.labelTextStyle];
     label.offset = x.majorTickLength;
     CGFloat location = i;
    /* if ([timestampArray count]>10&&i%([timestampArray count]/5)!=0) {
     //label = [[CPTAxisLabel alloc] initWithText:@""  textStyle:x.labelTextStyle];
     [xMinorLocations addObject:[NSNumber numberWithFloat:location]];
     }
     else*/
     [xMajorLocations addObject:[NSNumber numberWithFloat:location]];
     
     label.tickLocation = [NSNumber numberWithFloat:location];
     //if (label) {
      [xLabels addObject:label];
     // }
     }
   // x.axisLabels = xLabels;
   // x.majorTickLocations = xMajorLocations;
   // x.minorTickLocations = xMinorLocations;
   // axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    
    // 4 - Configure y-axis
    CPTXYAxis *y = axisSet.yAxis;
    NSString *tempUnit = [[NSUserDefaults standardUserDefaults] valueForKey:@"TempUnit"];
    y.title = [NSString stringWithFormat:@"Temp(°%@)",tempUnit];
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -30.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = -5.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLineStyle = tickLineStyle;
    y.minorTickLength = 0.0f;
    y.tickDirection = CPTSignPositive;
    /*NSInteger majorIncrement = 5;
     NSInteger minorIncrement = 2;
     CGFloat yMax = 150.0f;  // should determine dynamically based on max price
     NSMutableSet *yLabels = [NSMutableSet set];
     NSMutableSet *yMajorLocations = [NSMutableSet set];
     NSMutableSet *yMinorLocations = [NSMutableSet set];
     for (NSInteger j = 1; j <= yMax; j += minorIncrement) {
     NSUInteger mod = j % majorIncrement;
     if (mod == 0) {
     CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
     //NSDecimal location = CPTDecimalFromInteger(j);
     label.tickLocation = [NSNumber numberWithInteger:j];
     label.contentLayer.frame = CGRectMake(label.contentLayer.frame.origin.x, label.contentLayer.frame.origin.y-15, label.contentLayer.frame.size.width, label.contentLayer.frame.size.height);
     label.offset = -y.majorTickLength - y.labelOffset;
     if (label) {
     // [yLabels addObject:label];
     }
     [yMajorLocations addObject:[NSNumber numberWithInteger:j]];
     } else {
     [yMinorLocations addObject:[NSNumber numberWithInteger:j]];
     }
     }
     y.axisLabels = yLabels;
     y.majorTickLocations = yMajorLocations;
     y.minorTickLocations = yMinorLocations;*/
    
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    // Add legend
    CPTGraph *graph = hostView.hostedGraph;
    graph.legend = [CPTLegend legendWithGraph:graph];
    graph.legend.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1 green:1 blue:1 alpha:0.2]];
    graph.legend.textStyle = axisTextStyle;
    graph.legend.cornerRadius = 5.0;
    graph.legend.swatchSize = CGSizeMake(25.0, 25.0);
    graph.legendAnchor = CPTRectAnchorBottom;
    graph.legendDisplacement = CGPointMake(0.0, 0.0);
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx {
    Plot *myPlot = (Plot*)plot;
    CPTMutableLineStyle *plotSymbolLineStyle = [plot.dataLineStyle mutableCopy];
    plotSymbolLineStyle.lineWidth = 0.8;
    plotSymbolLineStyle.lineColor = [CPTColor yellowColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];

    plotSymbolLineStyle.lineColor = (CPTColor*)[myPlot plotColor];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    plotSymbol.lineStyle = plotSymbolLineStyle;
    plotSymbol.size = CGSizeMake(3.0f, 3.0f);
    return plotSymbol;
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    return [timestampArray count];
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
             //return [NSNumber numberWithUnsignedInteger:index];
            return  [NSNumber numberWithFloat:aggregate*index];
            break;
            
        case CPTScatterPlotFieldY:{
            Plot *myPlot = (Plot*)plot;
            if ([[[myPlot plotArray] objectAtIndex:index] isEqualToString:@"-"]) {
                return nil;
            }
            return  [NSNumber numberWithDouble:[[[myPlot plotArray] objectAtIndex:index] doubleValue]];
        }
            break;
    }
    return [NSNumber numberWithInt:0];
}

- (NSMutableArray*)getPlots {
    return plots;
}


/*-(BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint
{
    return YES;
}

-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    graphScaleX = graphScaleX*newRange.lengthDouble;
    graphScaleY = graphScaleY*newRange.lengthDouble;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)hostView.hostedGraph.graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    
    CPTXYAxis *y          = axisSet.yAxis;
    
    x.majorIntervalLength=CPTDecimalFromFloat(graphScaleX);
    y.majorIntervalLength=CPTDecimalFromFloat(graphScaleY);
    
    return newRange;
}*/



- (void)createPlotWithIdentifier:(NSString*)identifier andColor:(UIColor*)color andData:(NSMutableArray*)dataArray{
    Plot* plot = [[Plot alloc] initWithFrame:CGRectZero];
    [plot initWithIdentifier:identifier withColor:color withTag:[plots count] andData:dataArray];
    plot.dataSource = self;
    plot.delegate = self;
    plot.plotSymbolMarginForHitDetection = 10.0f;
    [plots addObject:plot];
}

- (void)refreshGraph {
    noGraphLabel.text = @"Loading Graph...";
    noGraphLabel.hidden = false;
    [hostView removeFromSuperview];
    tempArray = [[NSMutableArray alloc] init];
    temp1Array = [[NSMutableArray alloc] init];
    humidityArray = [[NSMutableArray alloc] init];
    dateArray = [[NSMutableArray alloc] init];
    timestampArray = [[NSMutableArray alloc] init];
    dateArray = [[NSMutableArray alloc] init];
    alarms = [[NSMutableArray alloc] init];
    alarmStartDates = [[NSMutableArray alloc] init];
    alarmPinned = [[NSMutableArray alloc] init];
    alarmIndices = [[NSMutableArray alloc] init];
}

- (NSMutableArray *)reversedArray:(NSMutableArray*)array
{
    NSMutableArray *reverseArray = [NSMutableArray arrayWithCapacity:[array count]];
    int c = (int)array.count;
    for (int i=c-1;i>0;--i)
    {
        //NSLog(@"adding object in reverse array");
        [reverseArray addObject:[array objectAtIndex:i]];
    }
    return reverseArray;
}


-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx {\
    Plot *myPlot = (Plot*)plot;
    if ([plot.identifier isEqual:@"Temp1"]){
        NSLog(@"plot label selected: %f",[[tempArray objectAtIndex:idx] floatValue]);
    }
    if ([plot.identifier isEqual:@"Temp2"]){
        NSLog(@"plot label selected: %f",[[temp1Array objectAtIndex:idx] floatValue]);
    }
    else {
        NSLog(@"plot label selected: %f",[[humidityArray objectAtIndex:idx] floatValue]);
    }
    
    CGPoint plotPosition = [plot plotAreaPointOfVisiblePointAtIndex:idx];
    NSLog(@"plot symbol was tapped at index :%lu, position: %f",(unsigned long)idx,plotPosition.y);
    [[self viewWithTag:100] removeFromSuperview];
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(plotPosition.x+20, (hostView.bounds.origin.y+hostView.bounds.size.height/2+85)- plotPosition.y, 70, 40)];
    pointLabel.font = [UIFont systemFontOfSize:10.0f];
    pointLabel.numberOfLines = 2;
    if ([alarmIndices containsObject:[NSNumber numberWithInteger:idx]]) {
        pointLabel.text = @"Alarm was triggered";
    }
    else
        pointLabel.text = [humidityArray objectAtIndex:idx];
    pointLabel.text = [[myPlot plotArray] objectAtIndex:idx];
    pointLabel.textColor = [UIColor whiteColor];
    pointLabel.tag = 100;
    [self addSubview:pointLabel];
    [self bringSubviewToFront:pointLabel];
}


-(CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)proposedDisplacementVector {
    [[self viewWithTag:100] removeFromSuperview];
    return proposedDisplacementVector;
}

- (IBAction) detailsButtonTapped:(UIButton*)sender {
    NSLog(@"details button tapped");
    if (showingDetails) {
        showingDetails = false;
        [UIView animateWithDuration:0.3 animations:^{
            detailsView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
        }];
        detailsButton.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
    }
    else {
        showingDetails = true;
        [UIView animateWithDuration:0.3 animations:^{
            detailsView.transform = CGAffineTransformMakeTranslation(-75, 0);
        } completion:^(BOOL finished) {
        }];
        detailsButton.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void) graphTypeButtonTappedForPlotIndex:(NSUInteger)index {
    [[self viewWithTag:100] removeFromSuperview];
    if (index == selectedGraphIndex) {
        return;
    }
    [_logButton setTitle:@"Log" forState:UIControlStateNormal];
    
    selectedGraphIndex = index;
    NSLog(@"graphTypeButtonTappedForPlotIndex:%d",index);
    Plot *plot = [plots objectAtIndex:index];
    plot.hidden = false;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) hostView.hostedGraph.defaultPlotSpace;
    double yLength  = plotSpace.yRange.lengthDouble;
    plotSpace.yScaleType = CPTScaleTypeLinear;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithDouble:[[[plot plotArray] objectAtIndex:0] doubleValue] - yLength/4] length:[NSNumber numberWithDouble:yLength]];
    //CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    titleLabel.text = [plot plotIdentifier];
    [_selectedGraphButton setTitle:[plot plotIdentifier] forState:UIControlStateNormal];
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:[hostView.hostedGraph plotWithIdentifier:[plot plotIdentifier]], nil]];
    plotSpace.allowsUserInteraction = true;
    
    for (int i = 0; i < [plots count]; ++i) {
        if (i!=index) {
            Plot *myPlot = [plots objectAtIndex:i];
            myPlot.hidden = true;
        }
    }
    if ([[plot plotIdentifier] isEqualToString:@"Corr. rate (avg) µm/year"]||[[plot plotIdentifier] isEqualToString:@"Corr. rate (max) µm/year"]) {
        Plot *myPlot1 = [plots objectAtIndex:1];
        Plot *myPlot2 = [plots objectAtIndex:2];
        myPlot1.hidden = false;
        myPlot2.hidden = false;
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        [indexArray addObject:[NSNumber numberWithInt:1]];
        [indexArray addObject:[NSNumber numberWithInt:2]];
        [self setUpGraphLabels:indexArray];
        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:[plots objectAtIndex:1],[plots objectAtIndex:2], nil]];
    }
    
    if ([[plot plotIdentifier] isEqualToString:@"Impedance Real (1) Ohm"]||[[plot plotIdentifier] isEqualToString:@"Impedance Imaginary (1) Ohm"]) {
        Plot *myPlot1 = [plots objectAtIndex:7];
        Plot *myPlot2 = [plots objectAtIndex:9];
        myPlot1.hidden = false;
        myPlot2.hidden = false;
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        [indexArray addObject:[NSNumber numberWithInt:7]];
        [indexArray addObject:[NSNumber numberWithInt:9]];
        [self setUpGraphLabels:indexArray];
        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:[plots objectAtIndex:7],[plots objectAtIndex:9], nil]];
    }
    
    if ([[plot plotIdentifier] isEqualToString:@"Impedance Real (2) Ohm"]||[[plot plotIdentifier] isEqualToString:@"Impedance Imaginary (2) Ohm"]) {
        Plot *myPlot1 = [plots objectAtIndex:8];
        Plot *myPlot2 = [plots objectAtIndex:10];
        myPlot1.hidden = false;
        myPlot2.hidden = false;
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        [indexArray addObject:[NSNumber numberWithInt:8]];
        [indexArray addObject:[NSNumber numberWithInt:10]];
        [self setUpGraphLabels:indexArray];
        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:[plots objectAtIndex:8],[plots objectAtIndex:10], nil]];
    }

    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:[NSNumber numberWithFloat:3.0f]];
    plotSpace.yRange = yRange;
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:[NSNumber numberWithFloat:1.8f]];
    plotSpace.xRange = xRange;
}

- (void) setUpGraphLabels:(NSMutableArray*)indexArray {
    [graphColorsView removeFromSuperview];
    graphColorsView = [[UIView alloc] initWithFrame:CGRectMake(135, 50, 150, 100)];
    for (int i=0; i < [indexArray count]; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 15+(i*15), 150, 20)];
        label.text = [[plots objectAtIndex:[[indexArray objectAtIndex:i] intValue]] plotIdentifier];
        label.textColor = [[plots objectAtIndex:[[indexArray objectAtIndex:i] intValue]] plotColor];
        label.font = [UIFont systemFontOfSize:9.0f];
        label.textAlignment = NSTextAlignmentRight;
        [graphColorsView addSubview:label];
    }
    [self addSubview:graphColorsView];
}


- (IBAction) closeButtonTapped:(UIButton*)sender {
    [_delegate contractGraph];
}

- (IBAction) zoomButtonTapped:(UIButton*)sender {
    [_delegate zoomGraph];
}



- (IBAction)selectGraph:(id)sender {
    [self showServerList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [plots count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    Plot *plot = [plots objectAtIndex:indexPath.row];
    cell.textLabel.text = [plot plotIdentifier];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    tableView.separatorColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideServerList];
    [self graphTypeButtonTappedForPlotIndex:indexPath.row];
    [_delegate enableGraphType:indexPath.row];
}

- (void)showServerList {
    if (showingGraphList) {
        [self hideServerList];
        return;
    }
    showingGraphList = true;
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(_selectedGraphButton.frame.origin.x, _selectedGraphButton.frame.origin.y+30, _selectedGraphButton.frame.size.width+50, 0)];
    table.delegate = self;
    table.dataSource = self;
    table.layer.cornerRadius = 5;
    table.backgroundColor = [UIColor whiteColor];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = [UIColor grayColor];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    table.frame = CGRectMake(_selectedGraphButton.frame.origin.x, _selectedGraphButton.frame.origin.y+30, _selectedGraphButton.frame.size.width+80, 200);
    [UIView commitAnimations];
    [self addSubview:table];
}

-(void)hideServerList {
    showingGraphList = false;
    //[serverButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    table.frame = CGRectMake(_selectedGraphButton.frame.origin.x, _selectedGraphButton.frame.origin.y+_selectedGraphButton.frame.size.height, _selectedGraphButton.frame.size.width, 0);
    [UIView commitAnimations];
}


#pragma mark - ConnectionProtocol

- (void) displayErrorWithMessage:(NSString *)errorMessage
{
    [_delegate displayErrorWithMessage:errorMessage];
}

@end
