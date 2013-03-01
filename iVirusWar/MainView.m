//
//  MainView.m
//  iVWar1
//
//  Created by sergey on 02.03.10.
//  Copyright Sergey Mingalev 2010. All rights reserved.
//

#import "MainView.h"
#import "VirusA.h"

@implementation MainView

@synthesize compvirLabel,humanLabel,compkillLabel,humankillLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
    }
    return self;
}

- (void) myInit
{
	myboard= [[Virus alloc] init];

	firstMove=YES;

	moveNumber=0;
    
    counter=1;

	// начальная клетка без нее пока не работает поиск
	[myboard markSpaceAtScreenPos:99 withFigure:TILE_HUMANVIR];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	// Drawing code
	
	int n,x,y;
	int starty=70;
	
    compvir=0;
    compkill=0;
    humankill=0;
    humanvir=0;
    
	CGContextRef	context;
	
	context = UIGraphicsGetCurrentContext ();
	
	// рисуем линии
	
	CGContextSetLineWidth(context, 1.0);
	UIColor *currentColor = [UIColor whiteColor];
	CGContextSetStrokeColorWithColor(context, currentColor.CGColor );
	
	for (x=0; x<11; x++) {
		
		CGContextMoveToPoint(context, x*32, starty); 
		CGContextAddLineToPoint(context, x*32, starty+320);
		CGContextStrokePath(context);
		
	}
	
	for (y=0; y<11; y++) {
		
		CGContextMoveToPoint(context, 0, starty+y*32); 
		CGContextAddLineToPoint(context, 320, starty+y*32);
		CGContextStrokePath(context);
		
	}

	//здесь написать количество взятых фигур
	
	compvirLabel.text=@"01";
	compkillLabel.text=@"01";
	humanLabel.text=@"01";
	humankillLabel.text=@"01";
	
	for(n=0;n<100;n++)
	{		
		int sx=n%10;
		int sy=n/10;
			
			CGRect currentRect = CGRectMake (sx*32+1,sy*32+1+starty,30,30);
			UIColor *currentColor;
			switch([myboard whatInCellWithScreenPos:n])
			{
				case TILE_EMPTY:
					currentColor =  [UIColor colorWithRed:1 green:1 blue:0.75 alpha:1];
					break;
				case TILE_COMPVIR:
					currentColor =  [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
                    compvir++;
					break;
				case TILE_HUMANKILLED:
					currentColor =  [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
                    humankill++;
					break;
				case TILE_HUMANKILLFRESH:
					currentColor =  [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
                    humankill++;
					break;
				case TILE_HUMANVIR:
					currentColor =  [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
                    humanvir++;
					break;
				case TILE_COMPKILLED:
					currentColor =  [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
                    compkill++;
					break;
				case TILE_COMPKILLFRESH:
					currentColor =  [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
                    compkill++;
			}

			CGContextSetFillColorWithColor(context, currentColor.CGColor);
			CGContextAddRect(context, currentRect);
			CGContextDrawPath(context, kCGPathFillStroke);
        
        if ([myboard isPosinBestLine:n]) {
			CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
			CGContextAddRect(context, CGRectMake (sx*32+5,sy*32+5+starty,7,7));
			CGContextDrawPath(context, kCGPathFillStroke);
        }
	}
    
    compvirLabel.text = [NSString stringWithFormat:@"%d",compvir];
	humanLabel.text = [NSString stringWithFormat:@"%d",humanvir];
	compkillLabel.text = [NSString stringWithFormat:@"%d",compkill];
	humankillLabel.text = [NSString stringWithFormat:@"%d",humankill];
    
    
    
}	


-(void)searchAndMakeMove
{

//	[myboard testMoves];
	
	[myboard removeFreshes];
	
	if (moveNumber==0) {
		
		[myboard markSpaceAtScreenPos:0 withFigure:TILE_COMPVIR];
		[myboard markSpaceAtScreenPos:11 withFigure:TILE_COMPVIR];
		[myboard markSpaceAtScreenPos:22 withFigure:TILE_COMPVIR];
		
		moveNumber++;
//		
//	} else if (moveNumber==11111) {
//		
//		[myboard markSpaceAtX:0 andY:1 withFigure:TILE_COMPVIR];
//		[myboard markSpaceAtX:0 andY:2 withFigure:TILE_COMPVIR];
//		[myboard markSpaceAtX:0 andY:3 withFigure:TILE_COMPVIR];
//		
//		moveNumber++;
//		
//		
//	} else if (moveNumber==10000) {
//		
//		[myboard markSpaceAtX:1 andY:0 withFigure:TILE_COMPVIR];
//		[myboard markSpaceAtX:2 andY:0 withFigure:TILE_COMPVIR];
//		[myboard markSpaceAtX:3 andY:0 withFigure:TILE_COMPVIR];
//		
//		moveNumber++;
//		
	} else	 {
	
		[myboard timeSet];
		[myboard searchPositionAlpha:-10000 beta:10000 depth:0 side:0];
		[myboard markBestLine];
	}
	
	//  [myboard testMoves];
		
	[myboard removeFreshes];

    [(UIActivityIndicatorView*)[self viewWithTag:111] stopAnimating];
	[self setNeedsDisplay];	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint		touched;
	int what,mPos,sPos;
	BOOL found;
	
	int starty=70;
	
	// find position of the touch
	touched = [[touches anyObject] locationInView:self];
	
	if (touched.y<380) { 
		
		int y=(touched.y-starty)/32;
		int x= touched.x/32;
		
		mPos=y*10+x;
		
		int whatIn = [myboard whatInCellWithScreenPos:mPos];
		
		found = NO;
		
		if (whatIn == TILE_EMPTY || whatIn == TILE_COMPVIR) {
			for(sPos=0;sPos<100;sPos++) {
				what = [myboard whatInCellWithScreenPos:sPos];
				if (what == TILE_HUMANVIR) {
					
					found = [myboard findPathFromScreenPos:sPos To:mPos side:HUMAN_PLAYER];
					
					if (found == YES) {
						if (whatIn == TILE_EMPTY)
							[myboard markSpaceAtScreenPos:mPos withFigure:TILE_HUMANVIR];
						else 
							[myboard markSpaceAtScreenPos:mPos withFigure:TILE_COMPKILLFRESH];
                        counter++;
						break;
					}
				}
			}
			
            if (counter==3) {
                counter=0;
                [(UIActivityIndicatorView*)[self viewWithTag:111] startAnimating];
                [self performSelector:@selector(searchAndMakeMove) withObject:self afterDelay:0.1];
            }
		}
		
		[self setNeedsDisplay];
		
	}
}



@end
