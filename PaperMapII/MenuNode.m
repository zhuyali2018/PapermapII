//
//  MenuNode.m
//  CollapsableMenu
//
//  Created by Yali Zhu on 7/21/13.
//  Copyright (c) 2013 Yali Zhu. All rights reserved.
//

#define IDT  20      //indent of the items in a folder
#define MLEN 240     //main label length
#define MHI  30      //main label height
#define CKW  32      //CheckBox and icon Width and height
#import "MenuNode.h"

@implementation MenuNode

@synthesize mainText;
@synthesize rootArrayIndex;
@synthesize checkbox;
@synthesize mainLabel,subLabel;
@synthesize iconTrail;
@synthesize openFolder;
@synthesize closeFolder;
@synthesize icon;
@synthesize emvc;
@synthesize cdate;
//TODO: make nscoder compatible ?
- (id) initWithTitle:(NSString *)title{
    self=[super init];
    if(self){
        self.mainText=[title copy];   //key for any initialization
        NSDate * now = [NSDate date];
        cdate=now;
        [self initInternalItems];   
    }
    return self;
}
- (id) initWithTitle:(NSString *)title asFolder:(bool)asFolder{
    self=[super init];
    if(self){
        self.folder=asFolder;
        self.mainText=[title copy];   //key for any initialization
        NSDate * now = [NSDate date];
        cdate=now;
        [self initInternalItems];
    }
    return self;
}

-(void) initInternalItems{
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    [checkbox setImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
    [checkbox addTarget:self action:@selector(setCheckBox:) forControlEvents:UIControlEventTouchUpInside];
    //_selected=true;  //no, not here or it will screwup the saved value. saved value already loaded in the _selected!!!
    [checkbox setFrame:CGRectMake(-30, -8, 90, 60)];
    mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, MLEN, MHI)];
    [mainLabel setBackgroundColor:[UIColor clearColor]];
    [mainLabel setText:mainText];      //key for any initialization
    
    subLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 30, MLEN, 15)];
    [subLabel setBackgroundColor:[UIColor clearColor]];
    [subLabel setTextColor:[UIColor grayColor]];
    [subLabel setFont:[UIFont systemFontOfSize:8]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    if (self.folder) {
        [subLabel setText:[outputFormatter stringFromDate:cdate]];
    }else
        [subLabel setText:[outputFormatter stringFromDate:[self.dataSource getTimeStamp]]];
    
    openFolder=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"folder0.png"]]; [openFolder setFrame:CGRectMake(0,0, 32, 32)];
    closeFolder=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"folder1.png"]]; [closeFolder setFrame:CGRectMake(0,0, 32, 32)];
    iconTrail=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trail.png"]];     [iconTrail setFrame:CGRectMake(0,0, 32, 32)];
    
    icon=[[UIView alloc]initWithFrame:CGRectMake(35,10, CKW, CKW)];
    [icon addSubview:openFolder];
    [icon addSubview:closeFolder];
    [icon addSubview:iconTrail];
}
- (void) setCheckBox:(id)sender{
    _selected=!_selected;
    
    UIButton * bn=sender;
    
    if((!self.folder)&&(_selected)){
        if ([self.dataSource respondsToSelector:@selector(loadNodes)]){
            [self.dataSource loadNodes];
            if ([self.dataSource respondsToSelector:@selector(numberOfNodes)]){
                if ([self.dataSource numberOfNodes]==0) {
                    return;
                }
            }
        }
    }
    
    if(_selected)
        [bn setImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
    else
        [bn setImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
    
    [bn setNeedsDisplay];   //update the checkbox image

    if(!_folder){
        if ([self.dataSource respondsToSelector:@selector(onCheckBox)])
            [self.dataSource onCheckBox];  //center and update track on map
        return;
    }
    int myIndex=(int)[emvc.trackList indexOfObject:self];
    if (myIndex<0) {
        return;
    }
    //check all the tracks in the folder
    for (int i=myIndex+1; i<[emvc.trackList count]; i++) {
        MenuNode * nd=[emvc.trackList objectAtIndex:i];
        if (!nd.infolder) {
            break;
        }
        nd.selected=_selected;
        
        if(nd.selected){
            if ([self.dataSource respondsToSelector:@selector(loadNodes)])
                [nd.dataSource loadNodes];   //should be [nd.dataSource loadNodes], not [self.datasource loadNodes]
            [nd.checkbox setImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
        }else{
            [nd.checkbox setImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
        }
        [nd.checkbox setNeedsDisplay];      //important to update the checkbox image here
        [nd updateAppearance];
        
    }
    if ([self.dataSource respondsToSelector:@selector(onCheckBox)])
        [self.dataSource onCheckBox];
}
-(void)updateAppearance{
    
    if(self.selected){
        if (!self.folder)
            if ([self.dataSource respondsToSelector:@selector(loadNodes)])
                [self.dataSource loadNodes];
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox1.png"] forState:UIControlStateNormal];
    }else{
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox0.png"] forState:UIControlStateNormal];
    }
    if (_folder) {
        [mainLabel setBackgroundColor:[UIColor clearColor]];
        [subLabel setBackgroundColor:[UIColor clearColor]];
        iconTrail.hidden=YES;
        if (_open) {
            closeFolder.hidden=YES;
            openFolder.hidden=NO;
            [icon bringSubviewToFront:openFolder];
            mainLabel.textColor=[UIColor redColor];
        }else{
            closeFolder.hidden=NO;
            openFolder.hidden=YES;
            [icon bringSubviewToFront:closeFolder];
            mainLabel.textColor=[UIColor blueColor];
        }
        [icon setFrame:CGRectMake(35, 10, CKW, CKW)];
        [mainLabel setFrame:CGRectMake(35+35, 0, MLEN, MHI)];
        [subLabel setFrame:CGRectMake(35+35, MHI, MLEN, 15)];
    }else{
        iconTrail.hidden=NO;
        [icon bringSubviewToFront:iconTrail];
        mainLabel.textColor=[UIColor blackColor];
        [mainLabel setBackgroundColor:[UIColor clearColor]];
        [subLabel setBackgroundColor:[UIColor clearColor]];
        [icon setBackgroundColor:[UIColor lightGrayColor]];
        if(_infolder){
            [mainLabel setFrame:CGRectMake(IDT+70, 0, MLEN, MHI)];
            [subLabel  setFrame:CGRectMake(IDT+70, MHI, MLEN, 15)];
            [icon setFrame:CGRectMake(IDT+35, 10, CKW, CKW)];
            [checkbox setFrame:CGRectMake(IDT-30, -8, 90, 60)];
        }else{
            [mainLabel setFrame:CGRectMake(35+35, 0, MLEN, MHI)];
            [subLabel  setFrame:CGRectMake(35+35, MHI, MLEN, 15)];
            [icon setFrame:CGRectMake(35, 10, CKW, CKW)];
            [checkbox setFrame:CGRectMake(-30, -8, 90, 60)];
        }
    }
    [mainLabel setText:mainText];      //key for updating
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    if (self.folder) {
        [subLabel setText:[outputFormatter stringFromDate:cdate]];
    }else
        [subLabel setText:[outputFormatter stringFromDate:[self.dataSource getTimeStamp]]];
    
    [icon setNeedsDisplay];
}
-(id)copyWithZone:(NSZone *)zone {
    MenuNode * nodeCopy=[[[self class]allocWithZone:zone]init];
    nodeCopy.folder=self.folder;
    nodeCopy.infolder=self.infolder;
    nodeCopy.open=self.open;
    nodeCopy.selected=self.selected;
    nodeCopy.rootArrayIndex=self.rootArrayIndex;
    nodeCopy.emvc=self.emvc;
    nodeCopy.mainText=[self.mainText copyWithZone:zone];   
    return nodeCopy;
}
-(id)initWithCoder:(NSCoder *)coder{
	if(self=[super init]){
		self.rootArrayIndex=[coder decodeIntForKey:@"ROOTARRAYINDEX"];
		self.folder=[coder decodeBoolForKey:@"FOLDER"];
		self.infolder=[coder decodeBoolForKey:@"INFOLDER"];
        self.open=[coder decodeBoolForKey:@"OPEN"];
		self.selected=[coder decodeBoolForKey:@"SELECTED"];
        self.mainText=[coder decodeObjectForKey:@"MAINTEXT"];   //key for any initialization
        self.cdate   =[coder decodeObjectForKey:@"CDATE"];
        [self initInternalItems];           //or all the labels are not initialized when loading from file 
	}
	return self;
}
-(void)encodeWithCoder:(NSCoder *)coder{
	[coder encodeInt:rootArrayIndex forKey:@"ROOTARRAYINDEX"];
	[coder encodeBool:self.folder forKey:@"FOLDER"];
    [coder encodeBool:self.open forKey:@"OPEN"];
    [coder encodeBool:self.selected forKey:@"SELECTED"];
    [coder encodeBool:self.infolder forKey:@"INFOLDER"];

    [coder encodeObject:self.mainText forKey:@"MAINTEXT"];      //key for any initialization
    [coder encodeObject:self.cdate forKey:@"CDATE"];
}
@end
