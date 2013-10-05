//
//  TASinglton.m
//  TestAppVer2
//
//  Created by Дмитрий Багров on 05.10.13.
//  Copyright (c) 2013 Ramotion. All rights reserved.
//

#import "TASingleton.h"

@implementation TASingleton

static TASingleton *instance_;

static void singleton_remover(){
    [instance_ release];
}

+ (TASingleton*)instance
{
    @synchronized(self)
    {
        if( instance_ == nil )
        {
            [[self alloc] init];
        }
    }
    
    return instance_;
}

- (id)init
{
    self = [super init];
    instance_ = self;
    
    atexit(singleton_remover);
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


@end
