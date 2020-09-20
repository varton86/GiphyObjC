//
//  CollectionViewCell.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Giphy.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

- (void)configureWithGiphy:(nullable Giphy *)giphy;

@end

NS_ASSUME_NONNULL_END
