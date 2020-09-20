//
//  CollectionViewCell.m
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import "CollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface CollectionViewCell ()

@property (strong, nonatomic) SDAnimatedImageView *picture;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (nil == self.picture)
        {
        self.picture = [[SDAnimatedImageView alloc] init];
        self.picture.layer.borderColor = UIColor.grayColor.CGColor;
        self.picture.layer.borderWidth = 1;
        self.picture.contentMode = UIViewContentModeScaleAspectFill;
        self.picture.clipsToBounds = YES;
        [self addSubview:self.picture];
        }
        
        if (nil == self.indicatorView)
        {
        self.indicatorView = [[UIActivityIndicatorView alloc] init];
        self.indicatorView.hidesWhenStopped = YES;
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
        }
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self configureWithGiphy:nil];
}

- (void)configureWithGiphy:(Giphy *)giphy
{
    self.picture.frame = self.bounds;
    self.indicatorView.frame = self.bounds;

    if (nil == giphy)
    {
        self.picture.alpha = 0;
        [self.indicatorView startAnimating];
    } else {
        __auto_type __weak weakSelf = self;
        [self.picture sd_setImageWithURL:[NSURL URLWithString:giphy.url] placeholderImage:nil options:SDWebImageHighPriority
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __auto_type __strong strongSelf = weakSelf;
            [strongSelf.indicatorView stopAnimating];
            strongSelf.picture.alpha = 1;
            strongSelf.picture.shouldCustomLoopCount = true;
            strongSelf.picture.animationRepeatCount = 1;
            [strongSelf.picture startAnimating];
        }];
    }
}

@end
