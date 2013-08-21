//
//  ScaleRuler.h
//  PaperMapII
//
//  Created by Yali Zhu on 6/17/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleRuler : UIView
{
	int len;
	CGFloat mid;
	CGFloat end;
	UILabel * startPoint;
	UILabel * middlePoint;
	UILabel * endPoint;
	UILabel * unitLabel;
    BOOL    bMetric;
}
@property int len;
@property CGFloat mid,end;
@property BOOL bMetric;
@property(nonatomic,strong)UILabel * startPoint;
@property(nonatomic,strong)UILabel * middlePoint;
@property(nonatomic,strong)UILabel * endPoint;
@property(nonatomic,strong)UILabel * unitLabel;

-(void)drawLineFrom:(CGPoint) p0 to:(CGPoint)p1 withColor:(UIColor *)color andWidth:(CGFloat)width;
-(void)updateRuler:(UIScrollView *)scrollView;
+(id)shareScaleRuler:(CGRect)frame;
@end
