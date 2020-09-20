//
//  MainViewController.m
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 02.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
    
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation MainViewController
{
    GiphyService *giphyService;
    GiphyLayout *layout;
    Debouncer * debouncer;

    NSString *cellIdentifier;
    CGFloat bottomInset;
    CGFloat searchBarHeight;
    CGFloat searchViewHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setupSearchBar];
    [self configureDataService];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self setupSubviews];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI
{
    self.title = @"Test Task";
    self.view.backgroundColor = UIColor.whiteColor;
    
    bottomInset = 30;
    searchBarHeight = 50;
    searchViewHeight = searchBarHeight + bottomInset;
    debouncer = [[Debouncer alloc] initWithDelay:2];

    cellIdentifier = @"CellIdentifier";
    layout = [[GiphyLayout alloc] init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[CollectionViewCell self] forCellWithReuseIdentifier:cellIdentifier];
    self.collectionView.hidden = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.collectionView];

    self.searchView = [[UIView alloc] init];
    self.searchView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.searchView];

    self.indicatorView = [[UIActivityIndicatorView alloc] init];
    self.indicatorView.hidesWhenStopped = YES;
    [self.indicatorView startAnimating];
    [self.view addSubview:self.indicatorView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchView addSubview:self.searchBar];
}

- (void)setupSubviews
{
    self.indicatorView.frame = self.view.bounds;
    self.searchView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - searchViewHeight, self.view.bounds.size.width, searchViewHeight);
    self.searchBar.frame = CGRectMake(self.searchView.bounds.origin.x, self.searchView.bounds.origin.y, self.searchView.bounds.size.width, searchBarHeight);
    self.collectionView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - searchViewHeight);
}

- (void)configureDataService
{
    giphyService = [[GiphyService alloc] initWithApiKey:API_KEY];
    giphyService.delegate = self;
    [giphyService fetchDataWithSearchKey:@"Hey"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [giphyService currentCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell configureWithGiphy:[giphyService giphyAtIndex:indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemSize = (collectionView.frame.size.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2;
    return CGSizeMake(itemSize, itemSize);
}

- (void)onFetchCompleted
{
    if (YES == self.collectionView.hidden)
    {
        [self.indicatorView stopAnimating];
        self.collectionView.hidden = NO;
        if ([giphyService currentCount] == 0)
        {
            AlertDisplayer(self, @"No Data");
        }
    }
    [self.collectionView reloadData];
}

- (void)onFetchFailedWithReason:(NSString *)reason
{
    if (YES == self.collectionView.hidden)
    {
        [self.indicatorView stopAnimating];
        self.collectionView.hidden = NO;
    }
    [self.collectionView reloadData];
    AlertDisplayer(self, reason);
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView heightForImageAtIndexPath:(nonnull NSIndexPath *)indexPath
{    
    return [giphyService giphyAtIndex:indexPath.item].height;
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView widthForImageAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return [giphyService giphyAtIndex:indexPath.item].width;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (nil != searchText && searchText.length > 1)
    {
        self.collectionView.hidden = YES;
        [self.indicatorView startAnimating];

        __auto_type __weak weakSelf = self;
        [debouncer scheduleWithAction:^(BOOL enable){
            if (YES == enable)
            {
                __auto_type __strong strongSelf = weakSelf;
                [strongSelf->giphyService fetchDataWithSearchKey:[NSString stringWithFormat:@"%@", searchText]];
            }
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
{
    NSDictionary* userInfo = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect kbFrameInView = [self.view.window convertRect:keyboardEndFrame toWindow:self.view.window];

    CGRect newFrame = self.searchView.frame;
    if (up == YES)
    {
        newFrame.origin.y = self.view.bounds.size.height - kbFrameInView.size.height - searchBarHeight;
    }
    else
    {
        newFrame.origin.y = self.view.bounds.size.height - searchViewHeight;
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    self.searchView.frame = newFrame;

    [UIView commitAnimations];
}

@end
