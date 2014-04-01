//
//  CoinViewController.h
//  Coin
//
//  Created by epics on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Coin;

@interface CoinViewController : UIViewController {
	
	UIImageView *Stacks[4];
    NSArray *coinVal[4];
	NSMutableArray *Coins;
    
	int numCoins;
	IBOutlet UILabel *Amount;
	IBOutlet UIButton *Refresh;
	UIImage *images[4];
    
    int i; // lcv
    int j; // need better names still (helps drag busy)
    
	int xOffset,yOffset;
	int dragBusy; // avoids coin eating (requires int j)
	NSString *selected_item;
	NSString *item_price;
    NSString *priceFloat;
    float priceCompare, sum;
	int oldNumCoins;
}

-(IBAction) coinRefresh;
-(IBAction) unlockButton;
-(IBAction) buyButton;
-(id) init:(NSString *)select :(NSString*)price;

@end
