//
//  OfficialAccountsToolBar.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/25.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountsToolBar.h"

#import "OfficialAccountMenu.h"

@protocol MenuViewCellDelegate

@optional

- (void)didSelectMenuViewCell:(UICollectionViewCell *)cell;

@end

@interface MenuViewCell : UICollectionViewCell

@property (nonatomic, weak) id<MenuViewCellDelegate> delegate;

@property (nonatomic, strong) UIButton *imageButton;

@end

@implementation MenuViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = self.bounds;
        _imageButton.userInteractionEnabled = YES;
        [_imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_imageButton addTarget:self action:@selector(imageButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imageButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageButton.frame = self.bounds;
}

- (void)setOfficialAccountMenu:(OfficialAccountMenu *)menu
{
    [_imageButton setTitle:menu.title forState:UIControlStateNormal];
}

- (void)imageButtonAction
{
    if (_delegate) {
        [_delegate didSelectMenuViewCell:self];
    }
}

@end

@interface OfficialAccountsToolBar () <UICollectionViewDelegate,UICollectionViewDataSource,MenuViewCellDelegate>

@property (nonatomic, strong) UICollectionView *bottomCollectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation OfficialAccountsToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomCollectionView];
    }
    return self;
}

#pragma mark - getter

- (UICollectionView *)bottomCollectionView
{
    if (_bottomCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        [_bottomCollectionView registerClass:[MenuViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [_bottomCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        _bottomCollectionView.backgroundColor = [UIColor clearColor];
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        _bottomCollectionView.showsVerticalScrollIndicator = NO;
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.alwaysBounceHorizontal = YES;
        _bottomCollectionView.pagingEnabled = YES;
        _bottomCollectionView.userInteractionEnabled = YES;
    }
    return _bottomCollectionView;
}

#pragma mark - Public

- (void)setMenus:(NSArray*)menus
{
    _dataSource = [menus copy];
    [_bottomCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource !=nil && [self.dataSource count] > 0) {
        return [self.dataSource count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"collectionCell";
    MenuViewCell *cell = (MenuViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    OfficialAccountMenu *menu = [self.dataSource objectAtIndex:indexPath.row];
    [cell setOfficialAccountMenu:menu];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;
        
    }
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = footerview;
    }
    return reusableview;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = self.frame.size.width / [self.dataSource count];
    return CGSizeMake(itemWidth, self.frame.size.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OfficialAccountMenu *menu = [self.dataSource objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectWithOfficialAccountMenu:)]) {
        [_delegate didSelectWithOfficialAccountMenu:menu];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - MenuViewCellDelegate

- (void)didSelectMenuViewCell:(UICollectionViewCell *)cell
{
    NSIndexPath *indexPath = [_bottomCollectionView indexPathForCell:cell];
    OfficialAccountMenu *menu = [self.dataSource objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectWithOfficialAccountMenu:)]) {
        [_delegate didSelectWithOfficialAccountMenu:menu];
    }
}

@end
