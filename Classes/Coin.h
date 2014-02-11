//
//  Coin.h
//  Drag
//
//  Created by epics on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Coin : NSObject {
	 UIImageView *iview;
	int value;
}
@property (retain, nonatomic)  UIImageView *iview;//remove iboutlet anusha 05/04/2013
-(void) setVal:(int)val;
-(void) setIview:(UIImageView*)imageview;
-(UIImageView *) getIview;
-(int) getVal;
@end
