//
//  Virus.m
//  Virus Model
//
//  Created by Сергей on 08.01.10.
//  Copyright 2010 Sergey Mingalev. All rights reserved.
//

#import "VirusA.h"

static int boardPos[256] = {
	0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0,0,0,0,0,0,0,0,0,0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,
	0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0,0xf0	
};

static int Map[100] = {
	51,52,53,54,55,56,57,58,59,60,
	67,68,69,70,71,72,73,74,75,76,
	83,84,85,86,87,88,89,90,91,92,
	99,100,101,102,103,104,105,106,107,108,
	115,116,117,118,119,120,121,122,123,124,
	131,132,133,134,135,136,137,138,139,140,
	147,148,149,150,151,152,153,154,155,156,
	163,164,165,166,167,168,169,170,171,172,
	179,180,181,182,183,184,185,186,187,188,
	195,196,197,198,199,200,201,202,203,204
};	

#define maxThinkingTimeSec 100

@interface PathFindNode : NSObject {
@public
	int nodePos;
	int cost;
	PathFindNode *parentNode;
}

+(id)node;

@end

@implementation PathFindNode

+(id)node
{
	return [[PathFindNode alloc] init];
}
@end


@interface MoveLine : NSObject {

@public
	int Pos1,Pos2,Pos3,posSum;
}

+(id)line;

@end

@implementation MoveLine

+(id)line
{
	return [[MoveLine alloc] init];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    
    MoveLine * other = object;
    return self->posSum == other->posSum;
}

- (NSUInteger)hash
{
    // Based upon standard hash algorithm ~ http://stackoverflow.com/a/4393493/337735
    NSUInteger result = 1;
    NSUInteger prime = 31;

    result = prime*result+self->posSum;
    
    return result;
}

@end

/*********************************************************************************/

@implementation Virus

-(id)init
{	
	if (self = [super init]) {
		
		// initializing array for my positions 
		
		compTurn=YES;
		
		bestLine = [MoveLine line];
		
		n_compvir=0;
		n_humanvir=0;
		n_compkill=0;
		n_humankill=0;
 	}
	return (self);
}

-(BOOL)spaceIsBlockedPos:(int)mPos side:(int)iside
{
	int what = boardPos[mPos];
	if (iside == 1) {
		if (what == TILE_COMPVIR || what == TILE_HUMANKILLED || what == TILE_COMPKILLFRESH || what == TILE_EMPTY)
			return YES;
		else
			return NO;		
	} else  {
		if (what == TILE_HUMANVIR || what == TILE_COMPKILLED || what == TILE_HUMANKILLFRESH || what == TILE_EMPTY)
			return YES;
		else
			return NO;
	}
}

-(PathFindNode*)nodeInArrayFast:(NSMutableArray*)a withPos:(int)mPos
{
	
	PathFindNode *n;

	for (n in a) {
		if(n->nodePos == mPos)
		{
			return n;
		}
	}
	
	return nil;
}


-(MoveLine*)lineInArrayFast:(NSMutableArray*)a withPos:(int)mPos
{

	for (MoveLine *n in a) {
	
		if(n->posSum == mPos)
		{
			return n;
		}
	}
	
	return nil;
}


-(PathFindNode*)lowestCostNodeInArrayFast:(NSMutableArray*)a
{
	//Finds the node in a given array which has the lowest cost
	PathFindNode *n, *lowest;
	lowest = nil;
	
	for (n in a) {
		if(lowest == nil)
		{
			lowest = n;
		}
		else
		{
			if(n->cost < lowest->cost)
			{
				lowest = n;
			}
		}
	}
	return lowest;
}	

-(int)unmapPosition:(int)mPos {
	return ((mPos/16-3)*10+mPos%16-3);
}

-(BOOL)findPathFromScreenPos:(int)sPos To:(int)ePos side:(int)side
{
	return([self findPathFromPos:Map[sPos] To:Map[ePos] side:side]);
}

-(BOOL)findPathFromPos:(int)startPos To:(int)endPos side:(int)side
{
	int newPos,currentPos,PosN;
	NSMutableArray *openList, *closedList;
	
	if(startPos==endPos)
		return YES;
	
	int saveTile=boardPos[endPos];
	
	boardPos[endPos]=TILE_TEMP;
	
	int addPos[8] = {1,-1,-15,-16,-17,15,16,17};
	
	openList = [[NSMutableArray alloc] initWithCapacity:1];
	closedList = [[NSMutableArray alloc] initWithCapacity:1];
	
	PathFindNode *currentNode = nil;
	PathFindNode *aNode = nil;
	
	PathFindNode *startNode = [PathFindNode node];
	startNode->nodePos = startPos;
	startNode->parentNode = nil;
	startNode->cost = 0;
	[openList addObject: startNode];
	
	while([openList count])
	{
		
		currentNode = [self lowestCostNodeInArrayFast: openList];
		
		if(currentNode->nodePos == endPos)
		{			
			// path found
			boardPos[endPos]=saveTile;
			
			return YES;
		}
		else
		{
			[closedList addObject: currentNode];
			[openList removeObject: currentNode];
			currentPos = currentNode->nodePos;

            for(PosN=0;PosN<8;PosN++)
			{
				newPos = currentPos+addPos[PosN];

				if(boardPos[newPos]!=0xf0)
				{
					if(![self nodeInArrayFast:openList withPos:newPos])
					{
						if(![self nodeInArrayFast:closedList withPos:newPos])
						{
							if(![self spaceIsBlockedPos:newPos side:side])
							{
								aNode = [PathFindNode node];
								aNode->nodePos = newPos;
								aNode->parentNode = currentNode;
								aNode->cost = currentNode->cost + 1;
								
								int newX = newPos%16;
								int newY = newPos/16;
								int endX = endPos%16;
								int endY = endPos/16;
								
								aNode->cost += (abs((newX) - endX) + abs((newY) - endY));
								
								[openList addObject: aNode];
							}
						}
					}
				}				
			}
		}		
	}
    
	//  NO PATH FOUND 
	boardPos[endPos]=saveTile;
	
	return NO;
}

-(void)removeFreshes
{
	int mPos;
	
	for (mPos=0;mPos<100;mPos++) {
		int whatInPos = boardPos[Map[mPos]];
		if (whatInPos == TILE_COMPKILLFRESH) {
			[self markSpaceAtScreenPos:mPos withFigure:TILE_COMPKILLED];
		} else if (whatInPos == TILE_HUMANKILLFRESH) {	
			[self markSpaceAtScreenPos:mPos withFigure:TILE_HUMANKILLED];
		}
	}
}

-(void)markBestLine
{
	
	int mPos1=bestLine->Pos1;
	int mPos2=bestLine->Pos2;
	int mPos3=bestLine->Pos3;	
	
	int whatInCell1 = boardPos[Map[mPos1]];
	int whatInCell2 = boardPos[Map[mPos2]];
	int whatInCell3 = boardPos[Map[mPos3]];
	
	int	tempMark1=TILE_COMPVIR;
	int	tempMark2=TILE_HUMANKILLED;
	
	if (whatInCell1 == TILE_EMPTY)
		[self markSpaceAtScreenPos:mPos1 withFigure:tempMark1];
	else {
		[self markSpaceAtScreenPos:mPos1 withFigure:tempMark2];
	}
	
	if (whatInCell2 == TILE_EMPTY)
		[self markSpaceAtScreenPos:mPos2 withFigure:tempMark1];
	else {
		[self markSpaceAtScreenPos:mPos2 withFigure:tempMark2];
	}
	
	if (whatInCell3 == TILE_EMPTY)
		[self markSpaceAtScreenPos:mPos3 withFigure:tempMark1];
	else {
		[self markSpaceAtScreenPos:mPos3 withFigure:tempMark2];
	}
}

-(BOOL)isPosinBestLine:(int)pos
{
    if (pos==bestLine->Pos1 || pos==bestLine->Pos2 || pos==bestLine->Pos3) {
        return YES;
    }
    
    return NO;
}

-(BOOL)markSpaceAtScreenPos:(int)mPos withFigure:(int)figure
{	
	boardPos[Map[mPos]]=figure;
	return (YES);
}

-(BOOL)markSpaceAtPos:(int)mPos withFigure:(int)figure
{
	boardPos[mPos]=figure;
	return (YES);
}

-(void)timeSet
{
	startDate=[NSDate date]; 
}

-(NSMutableArray *)fillFirstMovesArrays:(int)side
{
	int n,m,testPos,newPos;
	BOOL found;
	
	int testCondition1,testCondition2,testCondition3;
	
	int addPos[8] = {1,-1,-15,-16,-17,15,16,17};
	
	if (side == 0) { // computer's move
		testCondition1=TILE_HUMANVIR;
		testCondition2=TILE_COMPVIR;
		testCondition3=TILE_HUMANKILLED;
	} else  {
		testCondition1=TILE_COMPVIR;
		testCondition2=TILE_HUMANVIR;
		testCondition3=TILE_COMPKILLED;
	}
	
	NSMutableArray *myMoves = [[NSMutableArray alloc] init];
	
	for (testPos=0;testPos<100;testPos++) {
		
		int realPos = Map[testPos];
		
		int whatInPos = boardPos[realPos];
		
		if (whatInPos == testCondition1 || whatInPos == TILE_EMPTY) {  // if empty or we can eat opponent 
			
			for (m=0;m<8;m++) {
				
				newPos=realPos+addPos[m];
				
				if (boardPos[newPos]==testCondition2) { // searching for living our virus nearby 
					
					PathFindNode *mNode = [PathFindNode node];
					mNode->nodePos=testPos;
					[myMoves addObject:mNode]; 
					
					break;
					
				} else if (boardPos[newPos]==testCondition3) { // if dead virus nearby we test connection to living exists
					
					for (n=0; n<100; n++) {
						
						if (boardPos[Map[n]]==testCondition2) { // we found living virus
							
							found = [self findPathFromPos:Map[n] To:newPos side:side];
							
							if (found == YES) {
								
								PathFindNode *mNode = [PathFindNode node];
								mNode->nodePos=testPos;								
								[myMoves addObject:mNode];								
								
							}
						}
					}
				}
			}
		}
	}
	
	return (myMoves);
	
}

-(int)findSmallest:(int)a :(int)b :(int)c
{
    int lesser;

    if (a > b) {
        lesser = b;
    } else {
        lesser = a;
    }
    
    if (lesser > c) {
        lesser = c;
    }

    return lesser;
}

-(NSMutableArray *)fillSecondMovesArrays:(int)side
{
	int m,n,realPos,newPos,newPos3,sumPos;
	
	MoveLine *mLine;
	
	int testCondition1;//,testCondition2,testCondition3;
	
	int addPos[8] = {1,-1,-15,-16,-17,15,16,17};
	
	if (side == 0) { // computer
		testCondition1=TILE_HUMANVIR;
//		testCondition2=TILE_COMPVIR;
//		testCondition3=TILE_HUMANKILLED;
	} else {
		testCondition1=TILE_COMPVIR;
//		testCondition2=TILE_HUMANVIR;
//		testCondition3=TILE_COMPKILLED;
	}
	
	
	NSMutableArray *firstMoves=[self fillFirstMovesArrays:side];
	
	NSMutableArray *secondMoves=[[NSMutableArray alloc] initWithCapacity:10];
	
	
	for (PathFindNode *oneFirstMove in firstMoves) {
		for (PathFindNode *secondFirstMove in firstMoves) {
			if (oneFirstMove->nodePos!=secondFirstMove->nodePos) {
				for (PathFindNode *thirdFirstMove in firstMoves) {
					if (thirdFirstMove->nodePos!=oneFirstMove->nodePos && thirdFirstMove->nodePos!=secondFirstMove->nodePos) {
						sumPos=oneFirstMove->nodePos+secondFirstMove->nodePos+thirdFirstMove->nodePos;
                        
							mLine=[MoveLine line];
							
							mLine->Pos1=oneFirstMove->nodePos;
							mLine->Pos2=secondFirstMove->nodePos;
							mLine->Pos3=thirdFirstMove->nodePos;
							mLine->posSum=sumPos;
							
							[secondMoves addObject:mLine];
					}
				}
			}
		}
	}
	
	
	for (PathFindNode *oneFirstMove in firstMoves) {
		
		realPos=Map[oneFirstMove->nodePos];
		
		if (boardPos[realPos]==TILE_EMPTY) {
			
			for (m=0;m<8;m++) {
				
				newPos=realPos+addPos[m];
				
				if (boardPos[newPos]==testCondition1 || boardPos[newPos]==TILE_EMPTY) {
					
					for (PathFindNode *thirdFirstMove in firstMoves) {
						
						if (thirdFirstMove->nodePos!=oneFirstMove->nodePos && thirdFirstMove->nodePos!=[self unmapPosition:newPos]) {
							
							sumPos=oneFirstMove->nodePos+[self unmapPosition:newPos]+thirdFirstMove->nodePos;
							
								mLine=[MoveLine line];
								
								mLine->Pos1=oneFirstMove->nodePos;
								mLine->Pos2=[self unmapPosition:newPos];
								mLine->Pos3=thirdFirstMove->nodePos;
								mLine->posSum=sumPos;
								
								[secondMoves addObject:mLine];
						}
					}
					
					if (boardPos[newPos]==TILE_EMPTY) {
						
						for (n=0;n<8;n++) {
							newPos3=newPos+addPos[n];
							
							if ((boardPos[newPos3]==testCondition1 || boardPos[newPos3]==TILE_EMPTY) && newPos3!=realPos) {
								
								sumPos=oneFirstMove->nodePos+[self unmapPosition:newPos]+[self unmapPosition:newPos3];
								
									mLine=[MoveLine line];
									
									mLine->Pos1=oneFirstMove->nodePos;
									mLine->Pos2=[self unmapPosition:newPos];
									mLine->Pos3=[self unmapPosition:newPos3];
									mLine->posSum=sumPos;
									
									
									[secondMoves addObject:mLine];
							}
						}
					}
					
				}
			}		
		}			
	}
	
    NSMutableArray *array = [self removeDuplicates:secondMoves];
	
	return (array);
}

-(NSMutableArray *)removeDuplicates:(NSMutableArray*)originalArray
{
    NSMutableSet* existingNames = [NSMutableSet set];
    NSMutableArray* filteredArray = [NSMutableArray array];
    for (id object in originalArray) {
        if (![existingNames member:object]) {
            [existingNames addObject:object];
            [filteredArray addObject:object];
        }
    }
    
    return filteredArray;
}


-(int)searchPositionAlpha:(int)alpha beta:(int)beta depth:(int)ply side:(int)side
{
	int pos1,pos2,pos3;
	int tempMark1, tempMark2;//, testCondition1;
	int oppside;
		
	if (ply == 2) // (ply == MAXPLY)
	{
		// тут оценочная функция
		int qqq = [self evaluateBoard:side];
		return(qqq); 
	}
	
	if (side == COMP_PLAYER) {
		oppside = HUMAN_PLAYER;
	} else {
		oppside = COMP_PLAYER;
	}
	
//    NSDate *date = [NSDate date];
    
	NSMutableArray *allLines=[self fillSecondMovesArrays:side];
    
//    NSDate *date2 = [NSDate date];
//    NSLog(@"%f",[date2 timeIntervalSinceDate:date]);
    
	for (MoveLine *mLine in allLines) {
        
        @autoreleasepool {

		if ([startDate timeIntervalSinceNow] < -maxThinkingTimeSec)  break;
		
		pos1=mLine->Pos1;
		pos2=mLine->Pos2;
		pos3=mLine->Pos3;
				
		int whatInCell1 = boardPos[Map[pos1]];
		int whatInCell2 = boardPos[Map[pos2]];
		int whatInCell3 = boardPos[Map[pos3]];
		
		if (side == 0) { // computer
			tempMark1=TILE_COMPVIR;
			tempMark2=TILE_HUMANKILLED;
//			testCondition1=TILE_HUMANVIR;
		} else {
			tempMark1=TILE_HUMANVIR;
			tempMark2=TILE_COMPKILLED;
//			testCondition1=TILE_COMPVIR;
		}

		if (whatInCell1 == TILE_EMPTY)
			[self markSpaceAtScreenPos:pos1 withFigure:tempMark1];
		else {
			[self markSpaceAtScreenPos:pos1 withFigure:tempMark2];
		}

		if (whatInCell2 == TILE_EMPTY)
			[self markSpaceAtScreenPos:pos2 withFigure:tempMark1];
		else {
			[self markSpaceAtScreenPos:pos2 withFigure:tempMark2];
		}

		if (whatInCell3 == TILE_EMPTY)
			[self markSpaceAtScreenPos:pos3 withFigure:tempMark1];
		else {
			[self markSpaceAtScreenPos:pos3 withFigure:tempMark2];
		}
		
		int score=-[self searchPositionAlpha:-beta beta:-alpha depth:ply+1 side:oppside];
		
		[self markSpaceAtScreenPos:pos1 withFigure:whatInCell1];
		[self markSpaceAtScreenPos:pos2 withFigure:whatInCell2];
		[self markSpaceAtScreenPos:pos3 withFigure:whatInCell3];
		
		
		if (score>alpha) {
			alpha=score;
			if (ply==0) {
				bestLine->Pos1=pos1;
				bestLine->Pos2=pos2;
				bestLine->Pos3=pos3;
				//				NSLog(@"Best move is X=%d and Y=%d with Score=%d",mNode->nodeX,mNode->nodeY,score);
			}
		}
	//	if (alpha>beta) break;
        }
	}
	
    return (alpha);
}
 
-(int)evaluateBoard:(int)side
{
	int mPos;
	int score;
	int kill_cost;
	int vir_cost;
	
	kill_cost=200;
	vir_cost=100;

	score=0;

	for (mPos=0;mPos<100;mPos++) {

			int whatInPos = boardPos[Map[mPos]];
			
			switch (whatInPos) {
				case TILE_COMPVIR:
					score=score+vir_cost;
					break;
				case TILE_HUMANVIR:
					score=score-vir_cost;
					break;
				case TILE_HUMANKILLED:
					score=score+kill_cost;
					break;
				case TILE_COMPKILLED:
					score=score-kill_cost;
					break;
				default:
					break;
			}
		}	
	
	
//	NSLog(@"Board overall score = %d",score);
	return score;
}


// -------------- отладочные функции ------------------

-(void)testMoves
{
//	int i;

//	for (i=0;i<3;i++) {
	[self markSpaceAtScreenPos:0 withFigure:TILE_COMPVIR];
//	[self markSpaceAtScreenPos:1 withFigure:TILE_HUMANKILLED];
//	[self markSpaceAtScreenPos:10 withFigure:TILE_HUMANKILLED];
//	[self markSpaceAtScreenPos:11 withFigure:TILE_HUMANKILLED];
//	[self markSpaceAtScreenPos:i withFigure:TILE_COMPVIR];
//	[self markSpaceAtScreenPos:i withFigure:TILE_COMPVIR];
//	[self markSpaceAtScreenPos:i withFigure:TILE_COMPVIR];
//	[self markSpaceAtScreenPos:i withFigure:TILE_COMPVIR];
//		NSLog(@"----- i=%d",i);
				[self printAllMoves];
		//		[self printAllLines];
		//      [self printAllCompactLines];
//	}
}
		


-(void)printAllMoves
{
	NSMutableArray *allMoves=[self fillSecondMovesArrays:COMP_PLAYER];
	
	for (MoveLine *mNode in allMoves) {		
		NSLog(@" ---- Pos1 = %d, Pos2 = %d, Pos3 = %d",mNode->Pos1,mNode->Pos2,mNode->Pos3);
	}
	
}

-(void)testMoves2:(NSMutableArray*)a
{	
	for (MoveLine *mNode in a) {		
		NSLog(@" ---- Pos1 = %d, Pos2 = %d, Pos3 = %d",mNode->Pos1,mNode->Pos2,mNode->Pos3);
	}
}

-(void)reportLines:(NSMutableArray*)a side:(int)side
{	
	int i,fig;
	i=0;
	
	if (side==COMP_PLAYER) {
		fig=TILE_HUMANVIR;
	} else {
		fig=TILE_COMPVIR;
	}
	
	for (MoveLine *mNode in a) {
		if (boardPos[Map[mNode->Pos1]]==fig || boardPos[Map[mNode->Pos2]]==fig || boardPos[Map[mNode->Pos3]]==fig) {
			i++;
		}
	}

	NSLog(@" ---- Side: %d, overall=%d, with_kill=%d",side,[a count],i);
	
	
}


-(void)testMoves1:(NSMutableArray*)a
{	
	for (PathFindNode *mNode in a) {		
		NSLog(@" ---- Pos = %d",mNode->nodePos);
	}
}



// выясняем что в этой ячейки
-(int)whatInCellWithScreenPos:(int)mPos
{
	return(boardPos[Map[mPos]]);
}


@end
