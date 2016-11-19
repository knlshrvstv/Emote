//
//  KSEmojisCollectionViewController.m
//  Emote
//
//  Created by Kunal Shrivastava on 11/19/16.
//  Copyright © 2016 Kunal Shrivastava. All rights reserved.
//

#import "KSEmojisCollectionViewController.h"
#import "KSEmojiDataController.h"
#import "KSEmoji.h"

@interface KSEmojisCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSArray *emojis;
@property(nonatomic, strong) NSMutableDictionary *emojiImageDownloadsInProgress;
@property(nonatomic, assign) NSUInteger imageSize;
@property(nonatomic, assign) UIEdgeInsets sectionInsets;

@end

@implementation KSEmojisCollectionViewController

static NSString * const reuseIdentifier = @"EmojiCell";
static NSUInteger const imageWidth = 64;

#pragma mark - View controller life cycle methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _emojiImageDownloadsInProgress = [NSMutableDictionary new];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    CGFloat cellPaddingSpace = self.view.bounds.size.width * 0.5;
    CGFloat availableWidthSpace = (self.view.bounds.size.width - cellPaddingSpace);
    NSUInteger itemsPerRow = availableWidthSpace/imageWidth;
    _imageSize = availableWidthSpace/itemsPerRow;
    _sectionInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    [self fetchEmojiData];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _emojis.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

#pragma mark UICollectionViewDelegate methods

#pragma mark UICollectionViewDelegateFlowLayout methods

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

#pragma mark - Emoji data methods

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

@end
