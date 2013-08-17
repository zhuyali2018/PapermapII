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
@synthesize offImage,onImage;
@synthesize textLabel;
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
        textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 29)];
        textLabel.textAlignment=NSTextAlignmentCenter;
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:textLabel];
    }
    return self;
}
- (id)init
{
    CGRect frame=CGRectMake(0, 0, 100, 69);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        btnOn=false;
        withGroup=true;
        pushButton=false;
        OffBackgroundColor=[UIColor clearColor];
        OnBackgroundColor=[UIColor clearColor];
        [self setBackgroundColor:OffBackgroundColor];
        [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 29)];
        textLabel.textAlignment=NSTextAlignmentCenter;
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:textLabel];
    }
    return self;
}
-(void)setPositionX:(int)x Y:(int)y{
    CGRect fr=CGRectMake(x,y,self.frame.size.width,self.frame.size.height);
    [self setFrame:fr];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setImage:offImage forState:UIControlStateNormal];
    if (pushButton) {
        [self setImage:onImage forState:UIControlStateHighlighted];
    }
    [textLabel setText:self.onText];
}


-(void)buttonTapped{
    if (pushButton) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
     }else{
        btnOn=!btnOn;
        if (btnOn) {
            [self setBackgroundColor:OnBackgroundColor];
            [self setTitle:onText forState:UIControlStateNormal];
            [self setImage:onImage forState:UIControlStateNormal];
            [textLabel setText:onText];
        }else{
            [self setTitle:offText forState:UIControlStateNormal];
            [self setBackgroundColor:OffBackgroundColor];
            [self setImage:offImage forState:UIControlStateNormal];
            [textLabel setText:offText];
        }
    }
    if (tapEventHandler) {
        [onOffBnDelegate performSelector:tapEventHandler withObject:self];
    }
}
@end
