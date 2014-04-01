//
//  CoinViewController.m
//  Coin
//
//  Created by epics on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoinViewController.h"
#import "Coin.h"
#define pennyX 337
#define pennyY 315
#define nickelX 460
#define nickelY 333
#define dimeX 458
#define dimeY 450
#define quarterX 335
#define quarterY 445
#define centering 75
//spawn point, top-left pixel + center adjust

@implementation CoinViewController
- (IBAction) unlockButton {
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

//Needs to be reworked for better feedback
- (IBAction) buyButton {//Compare sum with priceCompare
	if (sum == priceCompare){// && oldNumCoins != numCoins){
		UIAlertView *win = [[UIAlertView alloc] initWithTitle:@"Item Purchased" 
													  message:@"You bought the item with exact change."
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles: nil];
		[win show];
		[win release];
	}else if(sum > priceCompare){// && oldNumCoins != numCoins){
		float diff = sum - priceCompare;
        if ((float)diff <  0.001)
        {
            UIAlertView *win = [[UIAlertView alloc] initWithTitle:@"Item Purchased"
                                                          message:@"You bought the item with exact change."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
            [win show];
            [win release];
        }
        else{
		NSString *message = [NSString stringWithFormat: @"You got $%1.2f in change.",diff];
		UIAlertView *win = [[UIAlertView alloc] initWithTitle:@"Item Purchased" 
													  message:message
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles: nil];
		[win show];
            [win release];}
	}else if(sum < priceCompare){ //&& oldNumCoins != numCoins){
		UIAlertView *win = [[UIAlertView alloc] initWithTitle:@"Try Again" 
													  message:@"You don't have enough money!"
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles: nil];
		[win show];
		[win release];		
	}
}

-(id) init:(NSString *)select :(NSString*)price{
	selected_item = select;
	item_price = price;
	NSLog(@"selected_sheet: %@",selected_item);
	NSLog(@"price: %@",item_price);
	int length = (int)[item_price length];
	NSString *priceStr; 
	priceStr = [item_price substringWithRange: NSMakeRange(1, length-1)];
	priceCompare = [priceStr floatValue];
	NSLog(@"price: %1.2f", priceCompare);
	return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSSet *allTouches = [event allTouches];
    
	if([allTouches count])
	{
        UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:self.view];
        
			for(i = 0; (i < 4) && (dragBusy == -1); i++){
				if([Stacks[i] pointInside:[self.view convertPoint:location toView:Stacks[i]] withEvent:event]){
                    
                    dragBusy = i;
                    Stacks[i].center = location;
                    [self.view bringSubviewToFront:Stacks[i]];
                    j = -1;
                }
			}
			
			for(i = 0; (i < [Coins count]) && (dragBusy == -1); i++)
			{
				if([[[Coins objectAtIndex:i] getIview] pointInside:[self.view convertPoint:location toView:[[Coins objectAtIndex:i] getIview]] withEvent:event]) {
                    
                    dragBusy = i;
                    [[Coins objectAtIndex:i] getIview].center = location;
                    [self.view bringSubviewToFront:[[Coins objectAtIndex:i] getIview]];
                }
            }
        }
    }

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //causing an error
    
    NSSet *allTouches = [event allTouches];
    
    if([allTouches count]) {
    
        UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:self.view];
    
        if(j != -1 && dragBusy != -1){
            [[Coins objectAtIndex:dragBusy] getIview].center = location;
        }else if(dragBusy != -1){
            Stacks[dragBusy].center = location;
        }
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
    dragBusy = -1;
	sum = 0;
	oldNumCoins = numCoins;
    
    
    i = 0;
    j = 0;
    
     //assignment of Coin Val should be reduced to one line if possible
    
     coinVal[0] = 1;
     coinVal[1] = 5;
     coinVal[2] = 10;
     coinVal[3] = 25;
     
     for(i = 0; i < 4; i++){
        if(Stacks[i].center.x >= 666){//If penny placed in tray
            Coin *temporary = [Coin new];
            UIImageView *temp = [[UIImageView alloc] initWithImage:images[i]];
            temp.frame = CGRectMake(Stacks[i].center.x-75,Stacks[i].center.y-75,150,150);
            [temporary setIview:temp];
            [temporary setVal:coinVal[i]];
            [Coins addObject:temporary];
            [self.view addSubview:[temporary getIview]];
            [temporary release];
            numCoins+=1;
        }
     
     }
    
    
	for (i = 0; i<[Coins count]; i++) {//Check if removed from tray
		if ([[Coins objectAtIndex:i] getIview].center.x < 666) {
			numCoins-=1;
			[[[Coins objectAtIndex:i] getIview] removeFromSuperview];
			[[[Coins objectAtIndex:i] getIview] release];
			[Coins removeObjectAtIndex:i];
		}
	}
	
	for (i = 0; i<[Coins count]; i++) {
		sum += [[Coins objectAtIndex:i] getVal] / 100.0;
		NSLog(@"%1.2f",sum);//Display sum by adding every coin individually
	}
	
	
	NSString *sumstr = [[NSString alloc] initWithFormat:@"$%1.2f",sum];
	Amount.text = sumstr;
	[sumstr release];
    
    [self stackRefresh];
	
	}

-(void) stackRefresh{
    
	Stacks[0].center = CGPointMake(pennyX + centering, pennyY + centering);
	Stacks[1].center = CGPointMake(nickelX + centering, nickelY + centering);
	Stacks[2].center = CGPointMake(dimeX + centering, dimeY + centering);
	Stacks[3].center = CGPointMake(quarterX + centering, quarterY + centering);
	
	NSLog(@"\ncoin count = %lu\n",(unsigned long)[Coins count]);
}

-(IBAction) coinRefresh{
	
	while ([Coins count]>0) // should look for less itterative approach
	{
		[[[Coins lastObject] getIview] removeFromSuperview];
		[[[Coins lastObject] getIview] release];
		[Coins removeLastObject];
	}
	
	Amount.text = @"$0.00";
	NSLog(@"reset coins");
}

-(void)viewDidLoad{
    
    i = 0;
    
	[Amount setFont: [UIFont fontWithName: @"Lucida Grande" size: 64]];
	Coins = [[NSMutableArray alloc] initWithCapacity:0];
	//const float colorMask[6] = {255,255,255,255,255,255};
	images[0] = [UIImage imageNamed:@"pennydemo.png"];
	images[1] = [UIImage imageNamed:@"nickeldemo.png"];
	images[2] = [UIImage imageNamed:@"dimedemo.png"];
	images[3] = [UIImage imageNamed:@"quarterdemo.png"];
	//for (int i = 0; i<4; i++) {
	//	images[i] = [UIImage imageWithCGImage:CGImageCreateWithMaskingColors(images[i].CGImage,colorMask)];
	//}
	CGRect frame;
	
	//0
	frame = CGRectMake(pennyX, pennyY, 150, 150);//0 , 100
	Stacks[0] = [[UIImageView alloc] initWithImage:images[0]];
	Stacks[0].frame = frame;
	[self.view addSubview:Stacks[0]];
	//1
	frame = CGRectMake(nickelX, nickelY, 150, 150);//0, 250
	Stacks[1] = [[UIImageView alloc] initWithImage:images[1]];
	Stacks[1].frame = frame;
	[self.view addSubview:Stacks[1]];
	//2
	frame = CGRectMake(dimeX, dimeY, 150, 150);//0, 400
	Stacks[2] = [[UIImageView alloc] initWithImage:images[2]];
	Stacks[2].frame = frame;
	[self.view addSubview:Stacks[2]];
	//3
	frame = CGRectMake(quarterX, quarterY, 150, 150);//0, 550
	Stacks[3] = [[UIImageView alloc] initWithImage:images[3]];
	Stacks[3].frame = frame;
	[self.view addSubview:Stacks[3]];
	
	dragBusy = -1;
	Amount.text = @"$0.00";
	numCoins=0;
	
	UIImage* item_image = [UIImage imageWithContentsOfFile:selected_item];
	UIImageView* item = [[UIImageView alloc] initWithImage:item_image];
	item.frame = CGRectMake(5, 5, 275, 275);//item location
	UILabel* price_label;
	price_label = [[UILabel alloc] initWithFrame:CGRectMake(5,280,275,30)] ;//price label location
	price_label.text = item_price;
	price_label.textAlignment = UITextAlignmentCenter;
	price_label.font = [UIFont fontWithName:@"Helvetica" size: 30];
	[self.view addSubview:price_label];
	
	[self.view addSubview:item];
	//[item release];

    [super viewDidLoad];
}



-(void)viewDidUnload {
	for(i = 0;i<4;i++){
		[Stacks[i] release];
	}
	while ([Coins count]>0)
	{
		[[[Coins lastObject] getIview] removeFromSuperview];
		[[[Coins lastObject] getIview] release];
		[Coins removeLastObject];
	}
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
// Override to allow orientations other than the default portrait orientation.
//for ios6 orientation
-(BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    
    if (orientation == UIInterfaceOrientationLandscapeLeft  ||orientation ==  UIInterfaceOrientationLandscapeRight )
        
    {
        
        return YES;
    }
    
    return NO;
}
//for ios5 orientation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    //interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||interfaceOrientation ==  UIInterfaceOrientationLandscapeRight ) {
        
        return YES;
    }
    
    return NO;
}
-(void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(void)dealloc {
    [super dealloc];
}
@end
