//
//  GiphyService.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Giphy.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GiphyServiceDelegate;

static NSUInteger const NUMBER_OF_ITEMS_AT_PAGE = 24;
static NSString * const ENDPOINT = @"https://api.giphy.com/v1/gifs/search?api_key=%@&q=%@&limit=%lu&offset=0&rating=g&lang=en";

@interface GiphyService : NSObject

@property (nonatomic, weak) id <GiphyServiceDelegate> delegate;

- (instancetype)initWithApiKey:(NSString *)api_key;
- (void)fetchDataWithSearchKey:(NSString *)aKey;
- (NSInteger)currentCount;
- (Giphy *)giphyAtIndex:(NSInteger)index;

@end

@protocol GiphyServiceDelegate <NSObject>

- (void)onFetchCompleted;
- (void)onFetchFailedWithReason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
