//
//  LinePropStorageViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/22/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//
#import "AllImports.h"
#import "LinePropStorageViewController.h"
#import "PM2OnScreenButtons.h"
#import "PropertyButton.h"

@interface LinePropStorageViewController ()

@end

@implementation LinePropStorageViewController

@synthesize  propBns,propChgBns;
@synthesize linePPVCtrl;
const static int NUM=5;     //number of stored property
- (id) init{
    self=[super init];
    if(self){
        [self.view setBackgroundColor:[UIColor redColor]];
        propBns     =[[NSMutableArray alloc]initWithCapacity:NUM];
        propChgBns  =[[NSMutableArray alloc]initWithCapacity:NUM];
        for (int i=0; i<NUM; i++) {   //TODO:donot hardcode the size
            PropertyButton *bn=[[PropertyButton alloc] initWithFrame:CGRectMake(15, 10+70*i,  240, 60)];
            bn.ID=i+1;
            NSString *t=[[NSString alloc]initWithFormat:@"Stored Property %d:",i+1];
            [bn.titleLabel setText:t];
            [bn setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];
            bn.lineProperty=[LineProperty sharedDrawingLineProperty];
            [bn addTarget:self action:@selector(gotSelectedColor:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:bn];
            [propBns addObject:bn];
            //change button that follows it
            UIButton * cbn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cbn setTitle:@"Change" forState:UIControlStateNormal];
            [cbn setFrame:CGRectMake(265, 10+70*i, 70, 60)];
            [cbn addTarget:self action:@selector(changeStorageColor:) forControlEvents:UIControlEventTouchUpInside];
            [cbn setTag:i+1];
            [self.view addSubview:cbn];
            [propChgBns addObject:cbn];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) gotSelectedColor:(id)sender{
    NSLOG8(@"You just selected %@",((PropertyButton *)sender).titleLabel.text);
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.colorPickPopover isPopoverVisible]){
         [OSB.colorPickPopover dismissPopoverAnimated:YES];
    }
    
    if(OSB.linePropertyViewCtrlr.trackProperty==DrawingLineProperty){
        [LineProperty sharedDrawingLineProperty].red    = ((PropertyButton *)sender).lineProperty.red;
        [LineProperty sharedDrawingLineProperty].green  = ((PropertyButton *)sender).lineProperty.green;
        [LineProperty sharedDrawingLineProperty].blue   = ((PropertyButton *)sender).lineProperty.blue;
        [LineProperty sharedDrawingLineProperty].alpha  = ((PropertyButton *)sender).lineProperty.alpha;
        [LineProperty sharedDrawingLineProperty].lineWidth= ((PropertyButton *)sender).lineProperty.lineWidth;
    }else{
        [LineProperty sharedGPSTrackProperty].red    = ((PropertyButton *)sender).lineProperty.red;
        [LineProperty sharedGPSTrackProperty].green  = ((PropertyButton *)sender).lineProperty.green;
        [LineProperty sharedGPSTrackProperty].blue   = ((PropertyButton *)sender).lineProperty.blue;
        [LineProperty sharedGPSTrackProperty].alpha  = ((PropertyButton *)sender).lineProperty.alpha;
        [LineProperty sharedGPSTrackProperty].lineWidth= ((PropertyButton *)sender).lineProperty.lineWidth;
    }
}
- (void) changeStorageColor:(id)sender{
    int tagNum=((UIButton *)sender).tag;
    NSLOG8(@"You pick to change storeage property %d",tagNum);

    if(linePPVCtrl==nil){
		linePPVCtrl=[[LinePropPickerViewController alloc] init];
        [linePPVCtrl.view setFrame:CGRectMake(0, 0, 350, 400)];
	}
    linePPVCtrl.view.tag=((UIButton *)sender).tag;
    [linePPVCtrl setProperty:((PropertyButton *)propBns[tagNum-1]).lineProperty];  //Pass lineProperty to the Property Picker view controller
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
    
    UIViewAnimationTransition transition=UIViewAnimationTransitionCurlUp;
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    
    //[linePPVCtrl viewWillAppear:YES];    //this line made the willAppear called twice!
    [self.view addSubview:linePPVCtrl.view];
	
	[UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
