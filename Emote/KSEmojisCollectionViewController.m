//
//  KSEmojisCollectionViewController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmojisCollectionViewController.h"
#import "KSEmojiDataController.h"
#import "KSEmojiImageDownloader.h"
#import "KSEmoji.h"
#import "KSEmojiCollectionViewCell.h"
#import "KSEmojiDetailViewController.h"
#import "KSUtility.h"

@interface KSEmojisCollectionViewController () <UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *emojis;
@property(nonatomic, strong) NSMutableDictionary *emojiImageDownloadsInProgress;
@property(nonatomic, assign) NSUInteger imageSize;
@property(nonatomic, assign) UIEdgeInsets sectionInsets;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation KSEmojisCollectionViewController

static NSString * const emojiCellReuseIdentifier = @"EmojiCell";
static NSString * const defaultCellReuseIdentifier = @"DefaultCell";
static NSString * const detailsSegueIdentifier = @"EmojiDetailSegue";
static NSString * const internetUnavailableErrorMessage = @"No internet available. Please check your internet connection.";
static NSUInteger const imageWidth = 35;

#pragma mark - View controller life cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    _emojiImageDownloadsInProgress = [NSMutableDictionary new];
        
    CGFloat cellPaddingSpace = self.view.bounds.size.width * 0.5;
    CGFloat availableWidthSpace = (self.view.bounds.size.width - cellPaddingSpace);
    NSUInteger itemsPerRow = availableWidthSpace/imageWidth;
    _imageSize = availableWidthSpace/itemsPerRow;
    _sectionInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    [self setupRefreshControl];
    [self fetchEmojiData];
}

-(void)dealloc
{
    [self terminateAllEmojiImageDownloads];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self terminateAllEmojiImageDownloads];
}

#pragma mark - View
-(void)setupRefreshControl
{
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView addSubview:_refreshControl];
}

-(void)pullToRefresh
{
    [self fetchEmojiData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _emojis.count ? _emojis.count : 1;
}

#pragma mark UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_emojis && _emojis.count > 0)
    {
        KSEmojiCollectionViewCell *cell = (KSEmojiCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:emojiCellReuseIdentifier forIndexPath:indexPath];
        KSEmoji *emoji = _emojis[indexPath.row];
        
        if (emoji.image)
        {
            [cell updateCellWithEmoji:emoji];
        }
        else
        {
            [cell updateCellWithPlaceholder];
            [cell showActivityIndicator];
            if (!self.collectionView.dragging && !self.collectionView.decelerating)
            {
                [self beginEmojiImageDownloadForEmoji:emoji forIndexPath:indexPath];
            }
        }
        
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:defaultCellReuseIdentifier forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_emojis)
    {
        return CGSizeMake(_imageSize, _imageSize);
    }
    else
    {
        return CGSizeMake(self.view.bounds.size.width * 0.6, imageWidth);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return _sectionInsets;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return _sectionInsets.left;
}

#pragma mark - Emoji data
-(void)fetchEmojiData
{
    if ([KSUtility isInternetAvailable])
    {
        [_refreshControl layoutIfNeeded]; //https://openradar.appspot.com/27468436
        [_refreshControl beginRefreshing];
        KSEmojiDataController *emojiDataController = [KSEmojiDataController new];
        [emojiDataController fetchEmojisFromAPIWithCompletion:^(NSArray *emojis, NSError *error) {
            if (emojis)
            {
                _emojis = emojis;
            }
            else if (error)
            {
                [KSUtility showErrorWithMessage:error.localizedDescription onViewController:self];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_refreshControl endRefreshing];
                [self.collectionView reloadData];
            });
        }];
    }
    else
    {
        [KSUtility showErrorWithMessage:internetUnavailableErrorMessage onViewController:self];
    }
}

#pragma mark - Emoji image
-(void)beginEmojiImageDownloadForEmoji:(KSEmoji*)emoji forIndexPath:(NSIndexPath*)indexPath
{
    KSEmojiImageDownloader *emojiImageDownloader = _emojiImageDownloadsInProgress[indexPath];
    
    if (!emojiImageDownloader)
    {
        emojiImageDownloader = [KSEmojiImageDownloader new];
        _emojiImageDownloadsInProgress[indexPath] = emojiImageDownloader;
        [emojiImageDownloader startEmojiImageDownloadWithURL:emoji.URL WithCompletion:^(NSData *data, NSError *error) {
            [_emojiImageDownloadsInProgress removeObjectForKey:indexPath];
            KSEmojiCollectionViewCell *cell = (KSEmojiCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            if (data)
            {
                emoji.image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell hideActivityIndicator];
                    [cell updateCellWithEmoji:emoji];
                });
            }
            else if (error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell hideActivityIndicator];
                    [cell updateCellWithPlaceholder];
                });
            }
        }];
    }
}

-(void)loadImagesForOnscreenRows
{
    if (_emojis.count > 0)
    {
        NSArray *visibleEmojisIndexPath = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visibleEmojisIndexPath)
        {
            KSEmoji *emoji = _emojis[indexPath.row];
            
            if (!emoji.image)
            {
                [self beginEmojiImageDownloadForEmoji:emoji forIndexPath:indexPath];
            }
        }
    }
}

-(void)terminateAllEmojiImageDownloads
{
    NSArray *allEmojiImageDownloads = [_emojiImageDownloadsInProgress allValues];
    [allEmojiImageDownloads makeObjectsPerformSelector:@selector(cancelEmojiImageDownload)];
    NSArray *allVisibleEmojiCells = [self.collectionView visibleCells];
    [allVisibleEmojiCells makeObjectsPerformSelector:@selector(hideActivityIndicator)];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - Segue
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:detailsSegueIdentifier])
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:(KSEmojiCollectionViewCell*)sender];
        KSEmoji *emoji = _emojis[indexPath.row];
        
        return emoji.image ? YES : NO;
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:detailsSegueIdentifier])
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:(KSEmojiCollectionViewCell*)sender];
        KSEmojiCollectionViewCell *cell = (KSEmojiCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        CGRect cellFrame = [self.collectionView convertRect:cell.frame toView:self.view];
        KSEmojiDetailViewController *emojiDetailViewController = (KSEmojiDetailViewController*)[segue destinationViewController];
        emojiDetailViewController.emoji = _emojis[indexPath.row];
        emojiDetailViewController.emojiRootPostion = cellFrame;
    }
}

@end
