//
//  CBChartView.m
//  CBChart
//
//  Created by pacific on 14/12/1.
//  Copyright (c) 2014年 pacific. All rights reserved.
//

#import "CBChartView.h"
#import "UIView+FrameSet.h"

#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/155.0 green:arc4random_uniform(255)/155.0 blue:arc4random_uniform(255)/155.0 alpha:0.7]

#define coorLineWidth 2
#define bottomLineMargin 20
#define coordinateOriginFrame CGRectMake(self.leftLineMargin, self.height - bottomLineMargin, coorLineWidth, coorLineWidth)  // 原点坐标
#define xCoordinateWidth (self.width - self.leftLineMargin - 25)
#define yCoordinateHeight (self.height - bottomLineMargin - 5)


@interface CBChartView ()

@property (strong, nonatomic) NSMutableArray *xPoints;
@property (strong, nonatomic) NSMutableArray *yPoints;
@property (strong, nonatomic) NSDictionary   *textStyleDict;
@property (assign, nonatomic) CGFloat maxYValue;

// 左边间距要根据具体的坐标值去计算
@property (assign, nonatomic) CGFloat leftLineMargin;
@property (assign, nonatomic) BOOL islineDrawDone;
@end

@implementation CBChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //        self.layer.backgroundColor = [UIColor purpleColor].CGColor;
        //        self.layer.opacity = 0.2;
        self.isDrawDashLine = YES;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.isDrawDashLine = YES;
        
    }
    return self;
}

+(instancetype)charView
{
    CBChartView *chartView = [[self alloc] init];
    // 默认值
    chartView.frame = CGRectMake(10, 70, 300, 220);
    return chartView;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    // 算出合理的左边距
    CGFloat maxStrWidth = 0;
    for (NSString *yValue in yValues) {
        CGSize size = [yValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
        // 得到文本的最大宽度
        if (size.width > maxStrWidth) {
            maxStrWidth = size.width;
        }
    }
    
    self.leftLineMargin = maxStrWidth + 6;
    //    self.leftLineMargin = 0 + 6;
    if (self.xValues.count != 0) {
        if (!self.shutDefaultAnimation) {
            [self setUpCoordinateSystem];
        }
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.shutDefaultAnimation) {
        [self drawCoordinateXy];
        [self drawCoorPointAndDashLine];
    }
    
    if (self.islineDrawDone) {
        [self drawCoorPointAndDashLine];
    }
}

#pragma mark - 懒加载

-(NSMutableArray *)xPoints
{
    if (!_xPoints) {
        _xPoints = [NSMutableArray array];
    }
    return _xPoints;
}

-(NSMutableArray *)yPoints
{
    if (!_yPoints) {
        _yPoints = [NSMutableArray array];
    }
    return _yPoints;
}

-(NSDictionary *)textStyleDict
{
    if (!_textStyleDict) {
        UIFont *font = [UIFont systemFontOfSize:8];
        NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init]; // 段落样式
        style.alignment = NSTextAlignmentCenter;
        
        _textStyleDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style,NSStrokeWidthAttributeName:@3, NSStrokeColorAttributeName:[UIColor whiteColor]};
    }
    return _textStyleDict;
}


#pragma mark - 创建坐标系
-(void)setUpCoordinateSystem // 利用UIView作为坐标轴动态画出坐标系
{
    UIView *xCoordinate = [self getLineCoor];
    UIView *yCoordinate = [self getLineCoor];
    [self addSubview:xCoordinate];
    [self addSubview:yCoordinate];
    //添加 scroller
    
    [UIView animateWithDuration:0 animations:^{
        xCoordinate.width = xCoordinateWidth + 2;
        yCoordinate.height = -yCoordinateHeight - 2;
    } completion:^(BOOL finished) {
        self.islineDrawDone = YES;
        [self createAnimation];
        [self setNeedsDisplay];
    }];
}

-(void)drawCoorPointAndDashLine
{
    CGRect myRect = CGRectMake(2, self.height - bottomLineMargin + 4 , self.leftLineMargin, bottomLineMargin);
    [@"0" drawInRect:myRect withAttributes:self.textStyleDict];
    // 根据值画x/y轴的值
    [self setUpXcoorWithValues:self.xValues];
    [self setUpYcoorWithValues:self.yValues];
    if (self.isDrawDashLine) {
        // 绘制网格
        [self drawDashLine];
    }
    // 画曲线
    [self drawFuncLine];
}

-(void)drawFuncLine
{
    if (self.xValues.count != 0 && self.yValues.count != 0) {
        NSMutableArray *funcPoints = [NSMutableArray array];
        NSInteger pointCount = self.xValues.count;
        [[UIColor clearColor] set];
        
        if (self.xValues.count != self.yValues.count) {
            pointCount = (self.xValues.count < self.yValues.count ? self.xValues.count : self.yValues.count);
        }
        
        for (int i = 0; i < pointCount; i++) {
            CGFloat funcXPoint = [self.xPoints[i] CGPointValue].x;
            // 微调由于线条太粗而引起的起始点和结束点的丑陋
            if (i == 0) {
                funcXPoint += 3;
            }
            if (i == pointCount - 1) {
                funcXPoint -= 3;
            }
            CGFloat yValue = [self.yValues[i] floatValue];
            CGFloat funcYPoint = (yCoordinateHeight) - (yValue / self.maxYValue) * (yCoordinateHeight) + 3;
            [funcPoints addObject:[NSValue valueWithCGPoint:CGPointMake(funcXPoint, funcYPoint)]];
        }
        
        UIBezierPath *funcLinePath = [UIBezierPath bezierPath];
        [funcLinePath moveToPoint:[[funcPoints firstObject] CGPointValue]];
        [funcLinePath setLineCapStyle:kCGLineCapRound];
        [funcLinePath setLineJoinStyle:kCGLineJoinRound];
        int index = 0;
        for (NSValue *pointValue in funcPoints) {
            if (index != 0) {
                [funcLinePath addLineToPoint:[pointValue CGPointValue]];
                [funcLinePath moveToPoint:[pointValue CGPointValue]];
                [funcLinePath stroke];
            }
            index++;
        }
        
        CAShapeLayer *lineLayer = [self setUpLineLayer];
        lineLayer.path = funcLinePath.CGPath;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [lineLayer addAnimation:pathAnimation forKey:@"lineLayerAnimation"];
        lineLayer.strokeEnd = 1.0;
        [self.layer addSublayer:lineLayer];
    }
}

-(CAShapeLayer *)setUpLineLayer
{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinBevel;
    
    lineLayer.strokeEnd   = 4.0;
    if (self.chartColor) {
        lineLayer.strokeColor =[UIColor whiteColor].CGColor ;//[UIColor whiteColor].CGColor;//self.chartColor.CGColor;
    }else{
        lineLayer.strokeColor =[UIColor whiteColor].CGColor ;// RandomColor.CGColor;
    }
    if (self.chartWidth) {
        lineLayer.lineWidth   = self.chartWidth;
    }else{
        lineLayer.lineWidth   = 3.0;
    }
    return lineLayer;
}

// 绘制网格
-(void)drawDashLine
{
    if (self.xPoints.count != 0 && self.yPoints.count != 0) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGPoint maxXPoint = [[self.xPoints lastObject] CGPointValue];
        CGPoint minYPoint = [[self.yPoints firstObject] CGPointValue];
        
        // 设置上下文环境 属性
        CGFloat dashLineWidth = 1;
        //     [[UIColor lightGrayColor] setStroke];
        [[UIColor whiteColor] setStroke];
        CGContextSetLineWidth(ctx, dashLineWidth);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetAlpha(ctx, 0.6);
        CGFloat alilengths[2] = {5, 3};
        CGContextSetLineDash(ctx, 0, alilengths, 2);
        
        // 画竖虚线
        NSMutableArray *localXpoints = [self.xPoints mutableCopy];
        //        if ([self.xValues[0] isEqualToString:@"0"]){
        //            [localXpoints removeObjectAtIndex:0];
        //        }
        NSUInteger i = localXpoints.count+1;
        if (_indexDraw==3) {
            for (NSValue *xP in localXpoints) {
                i--;
                if (i%7==2) {
                    CGPoint xPoint = [xP CGPointValue];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, nil, xPoint.x, xPoint.y);
                    CGPathAddLineToPoint(path, nil, xPoint.x, xPoint.y-3);
                    CGContextAddPath(ctx, path);
                    CGContextDrawPath(ctx, kCGPathEOFillStroke);
                    CGPathRelease(path);
                }
                
            }
        }
        else if (_indexDraw==1) {
            for (NSValue *xP in localXpoints) {
                i--;
                if (i%2==0) {
                    CGPoint xPoint = [xP CGPointValue];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, nil, xPoint.x, xPoint.y);
                    CGPathAddLineToPoint(path, nil, xPoint.x, xPoint.y-3);
                    CGContextAddPath(ctx, path);
                    CGContextDrawPath(ctx, kCGPathEOFillStroke);
                    CGPathRelease(path);
                }
                
            }
        }
        else{
        for (NSValue *xP in localXpoints) {
            CGPoint xPoint = [xP CGPointValue];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, xPoint.x, xPoint.y);
            CGPathAddLineToPoint(path, nil, xPoint.x, xPoint.y-3);
            CGContextAddPath(ctx, path);
            CGContextDrawPath(ctx, kCGPathEOFillStroke);
            CGPathRelease(path);
              }
        }
        // 画横虚线
        NSUInteger j = localXpoints.count +1;
        if (_indexDraw==3) {
            for (NSValue *yP in self.yPoints) {
                j--;
                if (j%7==2) {
                    CGPoint yPoint = [yP CGPointValue];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, nil, yPoint.x, yPoint.y );
                    CGPathAddLineToPoint(path, nil, maxXPoint.x - 5, yPoint.y );
                    CGContextAddPath(ctx, path);
                    CGContextDrawPath(ctx, kCGPathEOFillStroke);
                    CGPathRelease(path);
                }
            }
        }
        if (_indexDraw==1) {
            for (NSValue *yP in self.yPoints) {
                j--;
                if (j%2!=0) {
                    CGPoint yPoint = [yP CGPointValue];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, nil, yPoint.x, yPoint.y );
                    CGPathAddLineToPoint(path, nil, maxXPoint.x - 5, yPoint.y );
                    CGContextAddPath(ctx, path);
                    CGContextDrawPath(ctx, kCGPathEOFillStroke);
                    CGPathRelease(path);
                }
            }
        }
        else if (_indexDraw==2){
            for (NSValue *yP in self.yPoints) {
                CGPoint yPoint = [yP CGPointValue];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, nil, yPoint.x, yPoint.y );
                CGPathAddLineToPoint(path, nil, maxXPoint.x - 5, yPoint.y );
                CGContextAddPath(ctx, path);
                CGContextDrawPath(ctx, kCGPathEOFillStroke);
                CGPathRelease(path);
            }
            
        }
        else if (_indexDraw == 3){
            
            for (NSValue *yP in self.yPoints) {
                j--;
                if (j%7==2) {
                    CGPoint yPoint = [yP CGPointValue];
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, nil, yPoint.x, yPoint.y );
                    CGPathAddLineToPoint(path, nil, maxXPoint.x - 5, yPoint.y );
                    CGContextAddPath(ctx, path);
                    CGContextDrawPath(ctx, kCGPathEOFillStroke);
                    CGPathRelease(path);
                }
            }
        }
        //        CGContextRelease(ctx);
    }
}

// 通过UIView得到x y轴坐标轴
-(UIView *)getLineCoor
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.alpha = 0.3;
    lineView.frame = CGRectMake(self.leftLineMargin, self.height - bottomLineMargin, coorLineWidth, coorLineWidth);
    return lineView;
}

// 通过coreGraphics画坐标轴
-(void)drawCoordinateXy
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef xPath = CGPathCreateMutable();
    CGPathMoveToPoint(xPath, nil, self.leftLineMargin, self.height - bottomLineMargin);
    CGPathAddLineToPoint(xPath, nil, self.leftLineMargin + xCoordinateWidth + 2, self.height - bottomLineMargin);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetAlpha(ctx, 0.6);
    CGContextAddPath(ctx, xPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGPathRelease(xPath);
    CGMutablePathRef yPath = CGPathCreateMutable();
    CGPathMoveToPoint(yPath, nil, self.leftLineMargin, self.height - bottomLineMargin);
    CGPathAddLineToPoint(yPath, nil, self.leftLineMargin, self.height - bottomLineMargin - yCoordinateHeight - 2);
    CGContextAddPath(ctx, yPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGPathRelease(yPath);
    
}

#pragma mark - 添加坐标轴的值
-(void)setUpXcoorWithValues:(NSArray *)values
{
    if (values.count){
        NSUInteger count = values.count;
        NSUInteger j = count+1;
        for (int i = 0; i < count; i++) {
            NSString *xValue = values[i];
            j--;
            CGFloat cX = 0;
            if ([values[0] isEqualToString:@"0"]) { // 第一个坐标值是0
                cX = (xCoordinateWidth / (count - 1)) * i + self.leftLineMargin;
            }else{ // 第一个坐标值不是0
                cX = (xCoordinateWidth / count) * (i + 1) + self.leftLineMargin;
            }
            CGFloat cY = self.height - bottomLineMargin;
            // 收集坐标点
            [self.xPoints addObject:[NSValue valueWithCGPoint:CGPointMake(cX, cY)]];
            if (i == 0 && [values[0] isEqualToString:@"0"]) continue;
            CGSize size = [xValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
            if (_indexDraw==1) {
                if (j%2==0) {
                    [xValue drawAtPoint:CGPointMake(cX - size.width * 0.5, cY + 5) withAttributes:self.textStyleDict];
                }
            }
            else if (_indexDraw==2){
                [xValue drawAtPoint:CGPointMake(cX - size.width * 0.5, cY + 5) withAttributes:self.textStyleDict];
            }
            else if (_indexDraw == 3){
                if (j%7==2) {
                    [xValue drawAtPoint:CGPointMake(cX - size.width * 0.5, cY + 5) withAttributes:self.textStyleDict];
                }

            }
        }
    }
}

-(void)setUpYcoorWithValues:(NSArray *)values
{
    if (values.count) {
        NSUInteger count = 4;
        if (self.yValueCount) {
            count = self.yValueCount;
        }
        NSString *maxValue = values[0];
        for (int i = 1; i < count; i++) {
            if ([maxValue floatValue] < [values[i] floatValue]) {
                maxValue = values[i];
            }
        }
        self.maxYValue = [maxValue floatValue];
        CGFloat scale = [maxValue floatValue] / count;
        NSUInteger j = values.count + 1;
        for (int i = 0; i < count; i++) {
            j--;
            NSString *yValue = [NSString stringWithFormat:@"%.0f", [maxValue floatValue] - (i * scale)];
            CGFloat cX = self.leftLineMargin;
            CGFloat cY = i * (yCoordinateHeight / count) + 5;
            CGSize size = [yValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textStyleDict context:nil].size;
            if (_indexDraw==3) {
                if (j%7==2) {
                    [yValue drawAtPoint:CGPointMake(cX - size.width - 5, cY - size.height * 0.5 + 1) withAttributes:self.textStyleDict];
                }
            }
            else if (_indexDraw==1){
                if (j%2==0) {
                    [yValue drawAtPoint:CGPointMake(cX - size.width - 5, cY - size.height * 0.5 + 1) withAttributes:self.textStyleDict];
                }
            }
            else{
                [yValue drawAtPoint:CGPointMake(cX - size.width - 5, cY - size.height * 0.5 + 1) withAttributes:self.textStyleDict];
            }
            // 收集坐标点
            [self.yPoints addObject:[NSValue valueWithCGPoint:CGPointMake(cX, cY)]];
        }
    }
}

#pragma mark - 创建坐标系出现的动画
-(void)createAnimation
{
    CATransition *transition = [[CATransition alloc] init];
    //    transition.type = @"rippleEffect";
    transition.type = kCATransitionFade;
    transition.duration = 0.5;
    [self.layer addAnimation:transition forKey:nil];
}

@end



