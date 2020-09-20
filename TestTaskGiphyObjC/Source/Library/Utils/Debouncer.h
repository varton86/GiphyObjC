//
//  Debouncer.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 03.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockHandlers.h"

NS_ASSUME_NONNULL_BEGIN

@interface Debouncer : NSObject

- (instancetype)initWithDelay:(NSTimeInterval)delay;
- (void)scheduleWithAction:(Block1Bool)aOnChange;

@end

NS_ASSUME_NONNULL_END
