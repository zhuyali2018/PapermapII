//
//  LinePropPickerViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define VALUE 0.9
#import "AllImports.h"
#import "LinePropPickerViewController.h"
#import "PM2OnScreenButtons.h"

@interface LinePropPickerViewController ()

@end

@implementation LinePropPickerViewController
@synthesize okBn;
@synthesize sampleLineLabel,sampleTextLabel;
@synthesize redSlider,greSlider,bluSlider,alfSlider,widSlider;
@synthesize redBarLabel,greBarLabel,bluBarLabel,opqBarLabel,thiBarLabel;
@synthesize sampleLine;
@synthesize savedTitle;
- (id) init{
    self=[super init];
    if(self){
        [self.view setBackgroundColor:[UIColor colorWithRed:VALUE green:VALUE blue:VALUE alpha:1]];
    }
    return self;
}
-(void) viewDidDisappear:(BOOL)animated{
    NSLOG8(@"View did disappear");
    [self.view removeFromSuperview];
    savedTitle=NULL;
}
-(void) viewWillAppear:(BOOL)animated{
    NSLOG8(@"View will appear");
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if (!savedTitle) {
        savedTitle=[[NSString alloc] initWithString:OSB.linePropertyViewCtrlr.title];
    }
    NSString * headline=[[NSString alloc]initWithFormat:@"Setting for Stored Property %d",self.view.tag];
    [OSB.linePropertyViewCtrlr setTitle:headline];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLOG8(@"Line Prop picker view did Load !");
    sampleLine=[[PropertyButton alloc]initWithFrame:CGRectMake(20, 0, 300, 70)];
    [sampleLine setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sampleLine];

	// Do any additional setup after loading the view.
        
    sampleLineLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 25)];
    [sampleLineLabel setBackgroundColor:[UIColor clearColor]];
    [sampleLineLabel setText:@"Sample Line:"];
    
    sampleTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 20, 250, 50)];
    [sampleTextLabel setBackgroundColor:[UIColor clearColor]];
    [sampleTextLabel setText:@"Sample Underneath The Line"];
    
    [self.view addSubview:sampleTextLabel];
    [self.view addSubview:sampleLineLabel];
    
    //sliders initialization
    int x=20;   //horizontal starting position
    int y=90;   //vertical starting point
    int r=60;   //row distance
    int w=280;  //width
    int h=40;   // height
    
    okBn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okBn setTitle:@"OK" forState:UIControlStateNormal];
    [okBn setFrame:CGRectMake(110, y+325, 100, 30)];
    [okBn addTarget:self action:@selector(propertiesPicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBn];

    redSlider=[[UISlider alloc]initWithFrame:CGRectMake(x, y, w, h)];         [redSlider setBackgroundColor:[UIColor redColor]];
    greSlider=[[UISlider alloc]initWithFrame:CGRectMake(x, y+r, w, h)];       [greSlider setBackgroundColor:[UIColor greenColor]];
    bluSlider=[[UISlider alloc]initWithFrame:CGRectMake(x, y+r*2, w, h)];     [bluSlider setBackgroundColor:[UIColor blueColor]];
    alfSlider=[[UISlider alloc]initWithFrame:CGRectMake(x, y+r*3, w, h)];     [alfSlider setBackgroundColor:[UIColor clearColor]];
    widSlider=[[UISlider alloc]initWithFrame:CGRectMake(x, y+r*4, w, h)];     [widSlider setBackgroundColor:[UIColor clearColor]];
    
    [redSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [greSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [bluSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [alfSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [widSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:redSlider];
    [self.view addSubview:greSlider];
    [self.view addSubview:bluSlider];
    [self.view addSubview:alfSlider];
    [self.view addSubview:widSlider];
    
    redSlider.maximumValue=1.0;
	redSlider.minimumValue=0.0001;
	redSlider.continuous=YES;
	redSlider.value=0;
	
	greSlider.maximumValue=1.0;
	greSlider.minimumValue=0;
	greSlider.continuous=YES;
	greSlider.value=0;
	
	bluSlider.maximumValue=1.0;
	bluSlider.minimumValue=0;
	bluSlider.continuous=YES;
	bluSlider.value=1;
	
	alfSlider.maximumValue=1.0;
	alfSlider.minimumValue=0;
	alfSlider.continuous=YES;
	alfSlider.value=1;
	
	widSlider.maximumValue=50;
	widSlider.minimumValue=1;
	widSlider.continuous=YES;
	widSlider.value=3;

#define BKCOLOR [UIColor clearColor]
    int j=y-9-r;
    w=150;
    h=25;
    redBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, j+r, w, h)];    [redBarLabel setBackgroundColor:BKCOLOR]; 
    greBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, j+r*2, w, h)];  [greBarLabel setBackgroundColor:BKCOLOR];
    bluBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, j+r*3, w, h)];  [bluBarLabel setBackgroundColor:BKCOLOR];
    opqBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, j+r*4, w, h)];	[opqBarLabel setBackgroundColor:BKCOLOR];	//label for opaque
    thiBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, j+r*5, w, h)];	[thiBarLabel setBackgroundColor:BKCOLOR];	//label for thickness
    
    [self.view addSubview:redBarLabel];
    [self.view addSubview:greBarLabel];
    [self.view addSubview:bluBarLabel];
    [self.view addSubview:opqBarLabel];
    [self.view addSubview:thiBarLabel];
    
}
-(void)setProperty:(LineProperty *)lp{
    sampleLine.lineProperty=lp;
    [sampleLine setNeedsDisplay];
    redSlider.value=sampleLine.lineProperty.red;
    greSlider.value=sampleLine.lineProperty.green;
	bluSlider.value=sampleLine.lineProperty.blue;
	alfSlider.value=sampleLine.lineProperty.alpha;
	widSlider.value=sampleLine.lineProperty.lineWidth;
    
    NSString * msg=[[NSString alloc]initWithFormat:@"Red:%.0f%%",lp.red*100];
    redBarLabel.text=msg;
    msg=[[NSString alloc]initWithFormat:@"Green:%.0f%%",lp.green*100];
    greBarLabel.text=msg;
    msg=[[NSString alloc]initWithFormat:@"Blue:%.0f%%",lp.blue*100];
    bluBarLabel.text=msg;
    msg=[[NSString alloc]initWithFormat:@"Opaqe:%.0f%%",lp.alpha*100];
    opqBarLabel.text=msg;
    msg=[[NSString alloc]initWithFormat:@"Thickness:%.0f",lp.lineWidth];
    thiBarLabel.text=msg;
}
- (void) valueChanged:(id)sender{
    UISlider* slider = sender;
    if (slider==redSlider) {
        _red=[slider value];
        NSString * msg=[[NSString alloc]initWithFormat:@"Red:%.0f%%",_red*100];
        redBarLabel.text=msg;
        sampleLine.lineProperty.red=_red;
    }else if (slider==greSlider){
        _green=[slider value];
        NSString * msg=[[NSString alloc]initWithFormat:@"Green:%.0f%%",_green*100];
        greBarLabel.text=msg;
        sampleLine.lineProperty.green=_green;
    }else if (slider==bluSlider){
        _blue=[slider value];
        NSString * msg=[[NSString alloc]initWithFormat:@"Blue:%.0f%%",_blue*100];
        bluBarLabel.text=msg;
        sampleLine.lineProperty.blue=_blue;
    }else if (slider==alfSlider){
        _alf=[slider value];
        NSString * msg=[[NSString alloc]initWithFormat:@"Opaqe:%.0f%%",_alf*100];
        opqBarLabel.text=msg;
        sampleLine.lineProperty.alpha=_alf;
    }else if (slider==widSlider){
        _wid=[slider value];
        NSString * msg=[[NSString alloc]initWithFormat:@"Thickness:%.0f",_wid];
        thiBarLabel.text=msg;
        sampleLine.lineProperty.lineWidth=_wid;
    }
    
    [sampleLine setNeedsDisplay];
}
- (void) propertiesPicked:(id)sender{
    NSLOG8(@"You just selected a line property");
    
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    [OSB.linePropertyViewCtrlr setTitle:savedTitle];
    //save the new settings
    PropertyButton *pBn=((PropertyButton *)OSB.linePropertyViewCtrlr.linePSVCtrl.propBns[self.view.tag-1]);
    NSString * titleKey=pBn.titleLabel.text;
    [pBn.lineProperty saveSettings:titleKey];
    [pBn setNeedsDisplay];
    
    [UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
    
    UIViewAnimationTransition transition=UIViewAnimationTransitionCurlDown;
    [UIView setAnimationTransition:transition forView:[self.view superview] cache:YES];
    
    [self.view removeFromSuperview];
	
	[UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
