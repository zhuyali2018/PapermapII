//
//  OnOffButton.m
//  PaperMapII
//
//  Created by Yali Zhu on 7/9/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "OnOffButton.h"

@implementation OnOffButton

@synthesize btnOn;
@synthesize onText,offText;
@synthesize tapEventHandler;
@synthesize onOffBnDelegate;
@synthesize withGroup;
@synthesize pushButton;
@synthesize OnBackgroundColor;
@synthesize OffBackgroundColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        btnOn=false;
        withGroup=true;
        pushButton=false;
        OffBackgroundColor=[UIColor lightGrayColor];
        OnBackgroundColor=[UIColor redColor];
        [self setBackgroundColor:OffBackgroundColor];
        [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (id)init
{
    CGRect frame=CGRectMake(0, 0, 60, 60);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        btnOn=false;
        withGroup=true;
        pushButton=false;
        OffBackgroundColor=[UIColor lightGrayColor];
        OnBackgroundColor=[UIColor redColor];
        [self setBackgroundColor:OffBackgroundColor];
        [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)setPositionX:(int)x Y:(int)y{
    CGRect fr=CGRectMake(x,y,self.frame.size.width,self.frame.size.height);
    [self setFrame:fr];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)buttonTapped{
    if (pushButton) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    }else{
        btnOn=!btnOn;
        if (btnOn) {
            [self setBackgroundColor:OnBackgroundColor];
            [self setTitle:onText forState:UIControlStateNormal];
        }else{
            [self setTitle:offText forState:UIControlStateNormal];
            [self setBackgroundColor:OffBackgroundColor];
        }
    }
    if (tapEventHandler) {
        [onOffBnDelegate performSelector:tapEventHandler withObject:self];
    }
}
@end
