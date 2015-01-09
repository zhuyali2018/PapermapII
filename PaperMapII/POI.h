//
//  POI.h
//  TwoDGPS
//
//  Created by zhuyali on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuDataSource.h"
#import "MenuNode.h"

typedef enum{
	BLUEFLAG=0,
	PURPLEFLAG,
	GREENFLAG,
	YELLOWFLAG,
	ORANGEFLAG,
	REDFLAG
}FLAGTYPE;

@interface POI : MenuNode<NSCoding,NSCopying,MenuDataSource> {
	int res;	//resolution
	int x;
	int y;
	FLAGTYPE nType;		//flagType
	CGFloat lat;		//latitude
	CGFloat lon;		//longitude
	NSString * title;
	NSString * description;
	//UIImageView * imageView;
}
@property int res;	//resolution
@property int x;
@property int y;
@property FLAGTYPE nType;		//flagType
@property CGFloat lat;		//latitude
@property CGFloat lon;		//longitude
//@property (nonatomic, strong) NSString * title;
@property (atomic, copy) NSString * description;
//@property (nonatomic,retain) UIImageView * imageView;

-(void)encodeWithCoder:(NSCoder *)coder;
-(id)copyWithZone:(NSZone *)zone;
-(id)initWithCoder:(NSCoder *)coder;
- (id)initWithPoint:(CGPoint)pt;


-(void)setTitle:(NSString *)title1;
-(NSString *)title;

@end
