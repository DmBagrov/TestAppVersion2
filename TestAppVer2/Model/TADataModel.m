//
//  TAShotsListModel.m
//  TestAppv2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import "TADataModel.h"

#define imageCount 50

@implementation TADataModel

@synthesize shotsCount, favariteCount,isNeedRedisplayData;

-(id)init
{
    if(self = [super init])
    {
        //init array with 50 images
        shotsList_ = [[NSMutableArray alloc] init];
        
        for(int i=0; i < imageCount; i++)
        {
            [shotsList_ addObject:[NSString stringWithFormat:@"foto%d.png",i]];
        }
        //
        shotsCount = [shotsList_ count];
        //
        
        //load foto to cache (need be load in new thread)
        shotsListFotoCache_ = [[NSMutableArray alloc] init];
        
        //image for preview load
        UIImage *loadingImage = [UIImage imageNamed:@"loading.png"];
        for(int i=0; i < imageCount; i++)
        {
            //load image with loading img
            [shotsListFotoCache_ addObject:loadingImage];

        }
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
// Shots list methods
//-----------------------------------------------
-(void)loadImageCache
{
    //NSMutableArray *shotsListFotoCacheInNewThread = [[NSMutableArray alloc] init];
    
    
    //load images parallel
    dispatch_apply(imageCount, dispatch_get_global_queue(0, 0), ^(size_t i)
    {
        CGSize newSize = CGSizeMake(250, 200);
        UIGraphicsBeginImageContext(newSize);
        
        NSString *imageForResize = [NSString stringWithFormat:@"foto%zd.png",i];
        
        [[UIImage imageNamed:imageForResize] drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        [imageForResize release];

        //release old object
        [shotsListFotoCache_ replaceObjectAtIndex:i withObject:UIGraphicsGetImageFromCurrentImageContext()];
        isNeedRedisplayData = YES;
        
        UIGraphicsEndImageContext();
    });
}

-(NSString*)getItemNameByIndex:(NSInteger)index
{
    return [shotsList_ objectAtIndex:index];
}

-(UIImage*)getImageByIndex:(NSInteger)index
{
    return [shotsListFotoCache_ objectAtIndex:index];
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
        [favoriteList_ release];
        favoriteList_ = [(NSArray*) favArray mutableCopy];
    }
    
    return favArray;
}

-(void)saveFavoriteListToLongMemory:(NSMutableArray*) newFavList
{
    favoriteList_ = newFavList;
    
    //update property
    
    [[NSUserDefaults standardUserDefaults] setObject:favoriteList_ forKey:@"FavoriteList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)addNewItemToFavoriteList:(NSObject*)newItem
{
    //if this elemet is not in fav list
    if(![self isItemInFavoriteList:newItem])
    {
        [favoriteList_ addObject:newItem];
        
        //update property
        //favariteCount = [favoriteList_ count];
    
        [self saveFavoriteListToLongMemory:favoriteList_];
    }
}

-(void)deleteItemFromFavoriteList:(NSObject*)deletingItem
{
    [favoriteList_ removeObject:deletingItem];
    //
    //update property
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

-(NSInteger)favariteCount
{
    return [favoriteList_ count];
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
    [shotsListFotoCache_ release];
    
    [super dealloc];
}

@end
