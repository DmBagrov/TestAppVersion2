//
//  TAShotsListModel.m
//  TestAppv2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import "TADataModel.h"

@implementation TADataModel

@synthesize shotsCount, favariteCount;

-(id)init
{
    if(self = [super init])
    {
        //init array with 50 images
        shotsList_ = [[NSMutableArray alloc] init];
        
        for(int i=0;i<50;i++)
        {
            [shotsList_ addObject:[NSString stringWithFormat:@"foto%d.png",i]];
        }
        //
        shotsCount = [shotsList_ count];
        //
        
        //init fav list
        favoriteList_ = [[NSMutableArray alloc] init];
        //
        
        //fill favorite list
        favoriteList_ = [(NSArray*)[self getFavoriteList] mutableCopy];
        favariteCount = [favoriteList_ count];
        //
    }
    return self;
}

//-----------------------------------------------
//Shots list methods
//-----------------------------------------------

-(NSString*)getItemNameByIndex:(NSInteger)index
{
    return [shotsList_ objectAtIndex:index];
}

-(UIImage*)getImageByIndex:(NSInteger)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"foto%d.png",index]];
}

//-----------------------------------------------
// Favorite list methods
//-----------------------------------------------

-(NSArray*)getFavoriteList
{
    NSArray *favArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"FavoriteList"];
    
    if(favArray == nil)
    {
        //init fav list in memory
        [self saveFavoriteListToLongMemory:favoriteList_];
    }
    else
    {
        //fav list is exist, copy to RAM
        favoriteList_ = [(NSArray*) favArray mutableCopy];
    }
    
    return favArray;
}

-(void)saveFavoriteListToLongMemory:(NSMutableArray*) newFavList
{
    favoriteList_ = newFavList;
    
    //update property
    favariteCount = [favoriteList_ count];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:newFavList] forKey:@"FavoriteList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)addNewItemToFavoriteList:(NSObject*)newItem
{
    //if this elemet is not in fav list
    if(![self isItemInFavoriteList:newItem])
    {
        [favoriteList_ addObject:newItem];
        
        //update property
        favariteCount = [favoriteList_ count];
    
        [self saveFavoriteListToLongMemory:favoriteList_];
    }
}

-(void)deleteItemFromFavoriteList:(NSObject*)deletingItem
{
    //NSMutableArray *newFavoriteList = [(NSArray*)[self getFavoriteList] mutableCopy];
    [favoriteList_ removeObject:deletingItem];
    //
    //update property
    favariteCount = [favoriteList_ count];
    [self saveFavoriteListToLongMemory:favoriteList_];
}

-(BOOL)isItemInFavoriteList:(NSObject*)item
{
    for (NSObject *favItem in [self getFavoriteList])
    {
        if ([item isEqual:favItem])
        {
            return YES;
        }
    }
    return NO;
}

-(NSString*)getFavoriteListItemNameByIndex:(NSInteger)index
{
    //NSLog(@"%d",index);
    return [self getItemNameByIndex:[[favoriteList_ objectAtIndex:index] integerValue]];
}

-(UIImage*)getFavoriteListImageByIndex:(NSInteger)index
{
    return [self getImageByIndex:[[favoriteList_ objectAtIndex:index] integerValue]];
}
-(NSInteger)getFavoriteIndexInShotsListByIndexInArray:(NSInteger)index
{
    return [shotsList_ indexOfObject:[shotsList_ objectAtIndex:[[favoriteList_ objectAtIndex:index] integerValue]]];
}
//-----------------------------------------------

-(void)dealloc
{
    //save list in long memory and release
    [self saveFavoriteListToLongMemory:favoriteList_];
    [favoriteList_ release];
    
    [shotsList_ release];
    
    [super dealloc];
}

@end
