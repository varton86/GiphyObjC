//
//  GiphyService.m
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import "GiphyService.h"

@implementation GiphyService
{
    NSString *api_key;
    BOOL isFetchInProgress;
    
    NSMutableArray<Giphy *> *giphies;
}

- (instancetype)initWithApiKey:(NSString *)aCode
{
    if (self = [super init])
    {
        api_key = aCode;
        isFetchInProgress = NO;
    }
    return self;
}

- (NSInteger)currentCount
{
    return giphies.count;
}

- (Giphy *)giphyAtIndex:(NSInteger)index
{
    return [giphies objectAtIndex:index] ;
}

- (void)fetchDataWithSearchKey:(NSString *)searchKey
{
    if (YES == isFetchInProgress)
    {
        return;
    }
    isFetchInProgress = YES;
    giphies = [[NSMutableArray alloc] init];
    
    NSString *dataUrl = [NSString stringWithFormat:ENDPOINT, api_key, searchKey, (unsigned long)NUMBER_OF_ITEMS_AT_PAGE];
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    __auto_type __weak weakSelf = self;
    NSURLSessionDataTask *fetchTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if ([response respondsToSelector:@selector(statusCode)] && [(NSHTTPURLResponse *) response statusCode] == 200)
        {
            self->isFetchInProgress = NO;
            __auto_type __strong strongSelf = weakSelf;
            [strongSelf processResponseUsingData:data];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->isFetchInProgress = NO;
                __auto_type __strong strongSelf = weakSelf;
                [strongSelf.delegate onFetchFailedWithReason:@"An error occurred while fetching data. Please, check network connection"];
            });
            
        }
    }];
    [fetchTask resume];
}

- (void)processResponseUsingData:(NSData *)data
{
    NSError *parseJsonError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseJsonError];
    
    __auto_type __weak weakSelf = self;
    if (nil == parseJsonError)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *items = jsonDict[@"data"];
            __auto_type __strong strongSelf = weakSelf;
            [strongSelf addData:items];
            [strongSelf.delegate onFetchCompleted];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            __auto_type __strong strongSelf = weakSelf;
            [strongSelf.delegate onFetchFailedWithReason:@"An error occurred while decoding data. Please, check data"];
        });
    }
}

- (void)addData:(NSArray *)items
{
    for (NSDictionary *item in items)
    {
        Giphy *giphy = [[Giphy alloc] init];
        NSDictionary *images = item[@"images"];
        NSDictionary *original = images[@"original"];
        giphy.url = original[@"url"];
        giphy.height = [original[@"height"] floatValue];
        giphy.width = [original[@"width"] floatValue];
        [giphies addObject:giphy];
    }
}

@end
