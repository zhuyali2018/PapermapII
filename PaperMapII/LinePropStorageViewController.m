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
#import "PM2ViewController.h"
#import "PM2AppDelegate.h"

@interface LinePropStorageViewController ()

@end

@implementation LinePropStorageViewController

@synthesize  propBns,propChgBns;
@synthesize linePPVCtrl;
@synthesize parentView,parentViewCtrlr;

const static int NUM=7;     //number of stored property
- (id) init{
    self=[super init];
    if(self){
        [self.view setBackgroundColor:[UIColor redColor]];
        propBns     =[[NSMutableArray alloc]initWithCapacity:NUM];
        propChgBns  =[[NSMutableArray alloc]initWithCapacity:NUM];
        for (int i=0; i<NUM; i++) {   //TODO:do not hardcode the size
            PropertyButton *bn=[[PropertyButton alloc] initWithFrame:CGRectMake(5, 10+70*i,  230, 60)];
            bn.ID=i+1;
            NSString *t=[[NSString alloc]initWithFormat:@"Stored Property %d:",i+1];
            [bn.titleLabel setText:t];
            [bn setBackgroundImage:[UIImage imageNamed:@"icon72x72.png"] forState:UIControlStateHighlighted];  //TODO: Change for a nicer image
            bn.lineProperty=[LineProperty loadSettings:t];    //<===Should not let all stored one points to current LP address !!!
            //bn.lineProperty=[[LineProperty sharedDrawingLineProperty] copy];   //TODO: this one should be removed after making the stored properties sticky
            [bn addTarget:self action:@selector(gotSelectedColor:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:bn];
            [propBns addObject:bn];
            //change button that follows it
            UIButton * cbn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cbn setTitle:@"Change" forState:UIControlStateNormal];
            [cbn setFrame:CGRectMake(240, 10+70*i, 75, 60)];
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
    NSLOG10(@"You just selected %@",((PropertyButton *)sender).titleLabel.text);
    PM2OnScreenButtons * OSB=[PM2OnScreenButtons sharedBnManager];
    if([OSB.colorPickPopover isPopoverVisible]){
         [OSB.colorPickPopover dismissPopoverAnimated:YES];
    }
    if([OSB.menuPopover isPopoverVisible]){
         [OSB.menuPopover dismissPopoverAnimated:YES];
    }
    if(OSB.linePropertyViewCtrlr.trackProperty==DrawingLineProperty){
        LineProperty *lp=[LineProperty sharedDrawingLineProperty];
        lp.red    = ((PropertyButton *)sender).lineProperty.red;
        lp.green  = ((PropertyButton *)sender).lineProperty.green;
        lp.blue   = ((PropertyButton *)sender).lineProperty.blue;
        lp.alpha  = ((PropertyButton *)sender).lineProperty.alpha;
        lp.lineWidth= ((PropertyButton *)sender).lineProperty.lineWidth;
        [lp saveDrawingLineSettings];
    }else{
        LineProperty *tp=  [LineProperty sharedGPSTrackProperty];
        tp.red    = ((PropertyButton *)sender).lineProperty.red;
        tp.green  = ((PropertyButton *)sender).lineProperty.green;
        tp.blue   = ((PropertyButton *)sender).lineProperty.blue;
        tp.alpha  = ((PropertyButton *)sender).lineProperty.alpha;
        tp.lineWidth= ((PropertyButton *)sender).lineProperty.lineWidth;
        [tp saveGPSTrackSettings];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        [self.parentView removeFromSuperview];
//        [self.view removeFromSuperview];
        [parentViewCtrlr dismissViewControllerAnimated:YES completion:NULL];
    }
}
- (void) changeStorageColor:(id)sender{
    int tagNum=(int)((UIButton *)sender).tag;
    NSLOG8(@"You pick to change storeage property %d",tagNum);

    if(linePPVCtrl==nil){
		linePPVCtrl=[[LinePropPickerViewController alloc] init];
        [linePPVCtrl.view setFrame:CGRectMake(0, 0, 320, 550)];
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
