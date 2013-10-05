//
//  TAShotsListModel.h
//  TestAppv2
//
//  Created by Дмитрий Багров on 03.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TADataModel : NSObject
{
    NSMutableArray *shotsList_;
    NSMutableArray *shotsListFotoCache_;
    
    NSMutableArray *favoriteList_;
}

@property(readonly) NSInteger shotsCount;

@property(readonly) NSInteger favariteCount;

@property(assign) BOOL isNeedRedisplayData;


-(void)loadImageCache;
-(NSString*)getItemNameByIndex:(NSInteger) index;
-(UIImage*)getImageByIndex:(NSInteger) index;

-(void)addNewItemToFavoriteList:(NSObject*)newItem;
-(void)deleteItemFromFavoriteList:(NSObject*)deletingItem;
-(BOOL)isItemInFavoriteList:(NSObject*)item;

-(NSString*)getFavoriteListItemNameByIndex:(NSInteger)index;
-(UIImage*)getFavoriteListImageByIndex:(NSInteger)index;
-(NSInteger)getFavoriteIndexInShotsListByIndexInArray:(NSInteger)index;

@end
