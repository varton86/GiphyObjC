//
//  GiphyLayout.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GiphyLayoutDelegate;

static NSUInteger const NUMBER_OF_COLUMNS = 3;
static CGFloat const HEIGHT_OF_ITEM = 100;

@interface GiphyLayout : UICollectionViewLayout

@property (nonatomic, strong) id <GiphyLayoutDelegate> delegate;

@end

@protocol GiphyLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForImageAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView widthForImageAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
