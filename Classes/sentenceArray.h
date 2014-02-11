//
//  sentenceArray.h
//  ActivityMode
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface sentenceArray : NSObject {
	int Array[10][2];
	int LabelArr[10][2];
	
}
-(void) setImageViewNumber: (int) num;
-(int) getVal: (int) a : (int) b;
-(int) getLabelVal:(int)labelnumber :(int)value;

@end
