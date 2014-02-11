//
//  frameArray.h
//  ActivityMode
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface frameArray : NSObject {
	int Array[16][4];
	int LabelArr[16][2];
	
}
-(void) setButtonNumber: (int) num;
-(int) getVal: (int) a : (int) b;
-(int) getLabelVal:(int)labelnumber :(int)value;

@end
