//
//  MainView.h
//  iVWar1
//
//  Created by sergey on 02.03.10.
//  Copyright Sergey Mingalev 2010. All rights reserved.
//
@class Virus;

#import <UIKit/UIKit.h>

@interface MainView : UIView {
	Virus *myboard;
	BOOL firstMove;
	int moveNumber;
	NSTimer *moveTimer;
    int counter;
    
    int compvir;
    int humanvir;
    int compkill;
    int humankill;

	UILabel *compvirLabel;
	UILabel *humanLabel;
	UILabel *compkillLabel;
	UILabel *humankillLabel;
	
}

@property (nonatomic,strong) IBOutlet UILabel *compvirLabel;
@property (nonatomic,strong) IBOutlet UILabel *humanLabel;
@property (nonatomic,strong) IBOutlet UILabel *compkillLabel;
@property (nonatomic,strong) IBOutlet UILabel *humankillLabel;

-(void)searchAndMakeMove;
-(void)myInit;

@end
