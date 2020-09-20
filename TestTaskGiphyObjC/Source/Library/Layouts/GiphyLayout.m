//
//  GiphyLayout.m
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import "GiphyLayout.h"

@interface GiphyLayout ()
    
@end

@implementation GiphyLayout
{
    NSInteger numberOfColumns;
    CGFloat contentHeight;
    CGFloat itemHeight;
    NSMutableArray<UICollectionViewLayoutAttributes *> *cache;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        numberOfColumns = NUMBER_OF_COLUMNS;
        itemHeight = HEIGHT_OF_ITEM;
        contentHeight = 0;
        cache = [[NSMutableArray alloc] init];
    }
    return self;
}

- (CGFloat)contentWidth
{
    if (nil == self.collectionView)
    {
        return 0;
    } else {
        UIEdgeInsets insets = self.collectionView.contentInset;
        return self.collectionView.bounds.size.width - (insets.left + insets.right);
    }
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.contentWidth, contentHeight);
}

- (void)prepareLayout
{
    if (nil == self.collectionView && [cache count] == 0)
    {
        return;
    } else {
        CGFloat originalColumnWidth = self.contentWidth / (CGFloat) numberOfColumns;
        CGFloat columnWidth = originalColumnWidth;
        CGFloat xOffset = 0;
        CGFloat yOffset = 0;
        NSInteger column = 1;
        for (NSUInteger item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];

            CGFloat imageHeight = itemHeight;
            if (nil != self.delegate)
            {
                imageHeight = [self.delegate collectionView:self.collectionView heightForImageAtIndexPath:indexPath];
            }
            CGFloat imageWidth = columnWidth;
            if (nil != self.delegate)
            {
                imageWidth = [self.delegate collectionView:self.collectionView widthForImageAtIndexPath:indexPath];
                CGFloat ratio = imageWidth / imageHeight;
                imageWidth = itemHeight * ratio;
                imageWidth = column == numberOfColumns ? columnWidth : MIN(columnWidth, imageWidth);
            }
            CGRect frame = CGRectMake(xOffset, yOffset, imageWidth, itemHeight);
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = frame;
            [cache addObject:attributes];
            
            column = column < numberOfColumns ? (column + 1) : 1;
            xOffset = column == 1 ? 0 : (xOffset + imageWidth);
            columnWidth = column == 1 ? originalColumnWidth : column == numberOfColumns ? (self.contentWidth - xOffset) : ((self.contentWidth - xOffset) / ((CGFloat) numberOfColumns - column + 1));
            yOffset = column == 1 ? yOffset + itemHeight : yOffset;
            contentHeight = MAX(contentHeight, yOffset);
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *visibleLayoutAttributes = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attributes in cache)
    {
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            [visibleLayoutAttributes addObject:attributes];
        }
    }
    return visibleLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cache[indexPath.item];
}

@end
