//
//  MainViewController.m
//  Gallery
//
//  Created by Nikolay Eckert on 16.12.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

// MARK: --
// MARK: Fields

static NSString *cellIdentifier = @"cellIdentifier";
static CGFloat widthOfScreen;
static CGFloat inset = 10;

// MARK: --
// MARK: Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];

    [self.view addSubview:_collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"11111");
    widthOfScreen = [self getWidthOfScreen];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {

}


// MARK: --
// MARK: Services

- (CGFloat)getWidthOfScreen {
    return CGRectGetWidth(self.view.bounds) - inset * 4;
}


// MARK: --
// MARK: UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"jhfgio");

    return UIEdgeInsetsMake(inset, inset, inset, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"33333");
    return CGSizeMake(widthOfScreen, widthOfScreen);
}


@end
