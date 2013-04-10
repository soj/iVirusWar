//
//  Virus.h
//  Virus Model
//
//  Created by Сергей on 08.01.10.
//  Copyright 2010 Sergey Mingalev. All rights reserved.
//

#define TILE_EMPTY 0 // empty
#define TILE_COMPVIR 1 // i am
#define TILE_HUMANVIR 2 // opponent
#define TILE_COMPKILLED 3 // my killed
#define TILE_HUMANKILLED 4 // opponent killed
#define TILE_BORDER 5 // border
#define TILE_COMPKILLFRESH 7
#define TILE_HUMANKILLFRESH 6
#define TILE_TEMP 8 //for temp 

#define KILL_COST 150

#define COMP_PLAYER 0
#define HUMAN_PLAYER 1

typedef struct {
	int x;
	int y;
} myMove;

@class MoveLine;

@interface Virus : NSObject {
	
	NSMutableArray *myPositions;
	NSArray *rozaMoves;

	myMove bestMove0;
	MoveLine *bestLine;
	BOOL compTurn;
	NSDate *startDate;
	
	int n_compvir,n_humanvir,n_compkill,n_humankill;
}

-(id)init;
-(void)markBestLine;
-(int)evaluateBoard:(int)side;
-(int)searchPositionAlpha:(int)alpha beta:(int)beta depth:(int)ply side:(int)side;
-(void)removeFreshes;
-(int)whatInCellWithScreenPos:(int)mPos;
-(BOOL)markSpaceAtScreenPos:(int)mPos withFigure:(int)figure;
-(void)timeSet;
-(BOOL)findPathFromScreenPos:(int)sPos To:(int)ePos side:(int)side;
-(BOOL)findPathFromPos:(int)startPos To:(int)endPos side:(int)side;
-(BOOL)markSpaceAtPos:(int)mPos withFigure:(int)figure;
-(BOOL)isPosinBestLine:(int)pos;

@end
