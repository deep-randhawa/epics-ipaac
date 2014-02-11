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
	NSMutableArray *Coins;
	int numCoins;
	IBOutlet UILabel *Amount;
	IBOutlet UIButton *Refresh;
	UIImage *images[4];
	int xOffset,yOffset;
	int dragBusy;
	NSString * selected_item;
	NSString *item_price;
	NSString *priceFloat;
	float priceCompare, sum;
	int oldNumCoins;
}
@property (nonatomic,retain) IBOutlet UIButton *Refresh;
-(IBAction) coinRefresh;
-(IBAction) unlockButton;
-(IBAction) buyButton;
-(id) init:(NSString *)select :(NSString*)price;

@end
