//
//  TextInput.h
//  TwoDGPS
//
//  Created by zhuyali on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class POI;

@interface TextInput : UITextField {
	POI * poi;
}
@property (nonatomic) POI * poi;
@end
