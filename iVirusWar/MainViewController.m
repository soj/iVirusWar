//
//  MainViewController.m
//  iVWar1
//
//  Created by sergey on 02.03.10.
//  Copyright Sergey Mingalev 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "VirusA.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {

	 [super viewDidLoad];
     
     UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
     activity.frame = CGRectMake(20, 400, 40, 40);
     activity.tag=111;
	 [(MainView*)[self view] addSubview:activity];
     
	 [(MainView*)[self view] myInit];
 }
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
