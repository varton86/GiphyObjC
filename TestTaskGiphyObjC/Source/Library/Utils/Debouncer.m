//
//  Debouncer.m
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 03.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import "Debouncer.h"

@implementation Debouncer
{
    NSTimeInterval delay;
    dispatch_block_t block;
}

- (instancetype)initWithDelay:(NSTimeInterval)aDelay;
{
    if (self = [super init])
    {
        delay = aDelay;
    }
    return self;
}

- (void)scheduleWithAction:(Block1Bool)aOnChange
{
    if (block)
    {
        dispatch_block_cancel(block);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);

    block = dispatch_block_create(0, ^{
        Block1BoolSafeCall(aOnChange, YES);
    });
    
    dispatch_async(queue, block);
}

@end
