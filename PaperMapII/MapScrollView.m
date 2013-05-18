//
//  MapScrollView.m
//  PaperMapII
//
//  Created by Yali Zhu on 5/16/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "MapScrollView.h"

@implementation MapScrollView
@synthesize zoomView;

const int bz=0;        //bezel width, should be set to 0 eventually

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        zoomView=[[ZoomView alloc] initWithFrame:CGRectMake(bz,bz,1000, 1000)];
        [zoomView setBackgroundColor:[UIColor lightGrayColor]];
        
        [self addSubview:zoomView];
    
        [self setMaximumZoomScale:16];
		[self setMinimumZoomScale:1];
        self.delegate = self;
    }
    return self;
}
- (void)layoutSubviews{
    NSLog(@"in layoutSubviews");
    NSLog(@"ContentOffset:x:%.f, y:%.f",self.contentOffset.x,self.contentOffset.y);
    NSLog(@"ContentSize:W:%.f, H:%.f\n\n",self.contentSize.width,self.contentSize.height);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark ----------------------------
#pragma mark UIScrollViewDelegate methods
- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    NSLog(@"scale:%f",scale);
    NSLog(@"scrollviewContent:%.f,%.f :%.f x %.f",scrollView.contentOffset.x,scrollView.contentOffset.y,scrollView.contentSize.width,scrollView.contentSize.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	//return nil;  //return nil if you do not zooming to occur
    return zoomView;
}
@end
