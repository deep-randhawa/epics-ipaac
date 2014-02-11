//
//  Coin.m
//  Drag
//
//  Created by epics on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Coin.h"


@implementation Coin

-(void) setVal:(int)val{
	value = val;
}

-(void) setIview:(UIImageView *)imageview{
	NSLog(@"special test");
	iview = imageview;
}

-(UIImageView *) getIview{
	return iview;
}

-(int) getVal{
	return value;
}

@end
