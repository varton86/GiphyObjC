//
//  MainViewController.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Debouncer.h"
#import "GiphyLayout.h"
#import "GiphyService.h"
#import "AlertDisplayer.h"
#import "CollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const API_KEY = @"LLhYntmara5YmXu5vPunvkNJGyRP8At9";

@interface MainViewController : UIViewController <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GiphyServiceDelegate, GiphyLayoutDelegate>

@end

NS_ASSUME_NONNULL_END
