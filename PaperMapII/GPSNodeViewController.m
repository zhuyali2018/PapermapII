//
//  GPSNodeViewController.m
//  PaperMapII
//
//  Created by Yali Zhu on 6/30/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#import "GPSNodeViewController.h"

@interface GPSNodeViewController ()

@end

@implementation GPSNodeViewController
@synthesize node;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblTim.text=[NSDateFormatter localizedStringFromDate:node.timestamp dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    self.lblLat.text=[[NSString alloc]initWithFormat:@"%8.4f degrees",node.latitude];
    self.lblLon.text=[[NSString alloc]initWithFormat:@"%8.4f degrees",node.longitude];
    self.lblAlt.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node.altitude];
    self.lblDir.text=[[NSString alloc]initWithFormat:@"%8.1f degrees",node.direction];
    self.lblSpd.text=[[NSString alloc]initWithFormat:@"%8.1f MPH",node.speed*3600/1609];
    self.lblDis1.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node.distanceFromLastNode];
    self.lblDis2.text=[[NSString alloc]initWithFormat:@"%8.0f meters",node.distanceFromStart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
