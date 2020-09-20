//
//  Giphy.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Giphy : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@end

NS_ASSUME_NONNULL_END
