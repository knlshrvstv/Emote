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

@interface KSEmojisCollectionViewController () <UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *emojis;
@property(nonatomic, strong) NSMutableDictionary *emojiImageDownloadsInProgress;
@property(nonatomic, assign) NSUInteger imageSize;
@property(nonatomic, assign) UIEdgeInsets sectionInsets;

@end

@implementation KSEmojisCollectionViewController

static NSString * const reuseIdentifier = @"EmojiCell";
static NSString * const detailsSegueIdentifier = @"EmojiDetailSegue";
static NSUInteger const imageWidth = 25;

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _emojiImageDownloadsInProgress = [NSMutableDictionary new];
        
    CGFloat cellPaddingSpace = self.view.bounds.size.width * 0.5;
    CGFloat availableWidthSpace = (self.view.bounds.size.width - cellPaddingSpace);
    NSUInteger itemsPerRow = availableWidthSpace/imageWidth;
    _imageSize = availableWidthSpace/itemsPerRow;
    _sectionInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    [self fetchEmojiData];
}

- (void)dealloc
{
    [self terminateAllEmojiImageDownloads];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self terminateAllEmojiImageDownloads];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _emojis.count;
}

#pragma mark UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSEmojiCollectionViewCell *cell = (KSEmojiCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    KSEmoji *emoji = _emojis[indexPath.row];
    
    if (emoji.image)
    {
        [cell updateCellWithEmoji:emoji];
    }
    else
    {
        [cell updateCellWithPlaceholder];
        if (!self.collectionView.dragging && !self.collectionView.decelerating)
        {
            [cell showActivityIndicator];
            [self beginEmojiImageDownloadForEmoji:emoji forIndexPath:indexPath];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_imageSize, _imageSize);
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
    KSEmojiDataController *emojiDataController = [KSEmojiDataController new];
    [emojiDataController fetchEmojisFromAPIWithCompletion:^(NSArray *emojis, NSError *error) {
        _emojis = emojis;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
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
            else
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

#pragma mark - Storyboard
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
