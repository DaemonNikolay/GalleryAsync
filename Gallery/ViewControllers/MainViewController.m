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

NSMutableArray *imageUrls;
NSMutableSet *imagePaths;


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


    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_refreshControl];

    _collectionView.alwaysBounceVertical = YES;

    imageUrls = [NSMutableArray new];

    [imageUrls addObject:@"https://avatars.mds.yandex.net/get-pdb/1774534/fa0473b1-2936-4815-b2fd-3295397e4563/s1200"];
    [imageUrls addObject:@"https://wallbox.ru/resize/1024x768/wallpapers/main/201407/63883e862ce5139.jpg"];
    [imageUrls addObject:@"https://www.nastol.com.ua/pic/201509/1680x1050/nastol.com.ua-150389.jpg"];
    [imageUrls addObject:@"https://wallbox.ru/wallpapers/main2/201715/149218094758f0dfd310e6b5.70800569.jpg"];
    [imageUrls addObject:@"https://images.wallpaperscraft.ru/image/devushka_lico_glaza_blondinka_zagadochnyy_11405_1920x1200.jpg"];
    [imageUrls addObject:@"https://7themes.su/php/imres/resize.php?width=1152&height=864&cropratio=4:3&image=/_ph/31/255757667.jpg"];
}

- (void)refreshControlAction {
    [self clearCacheImages];

    [_collectionView reloadData];
    [_refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    widthOfScreen = [self getWidthOfScreen];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {

}


// MARK: --
// MARK: Services

- (CGFloat)getWidthOfScreen {
    return CGRectGetWidth(self.view.bounds) - inset * 4;
}

- (UIImage *)getImageFromLocalCache:(NSInteger)imgItemNumber {
    NSString *imgItem = [@(imgItemNumber) stringValue];
    UIImage *img = [self getImageFromCacheWithName:imgItem];

    if (img != nil) {
        return img;
    }

    NSString *imgName = imageUrls[(NSUInteger) imgItemNumber];
    NSURL *url = [NSURL URLWithString:imgName];

    NSData *data = [NSData dataWithContentsOfURL:url];
    img = [[UIImage alloc] initWithData:data];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self saveImage:img withName:imgItem];
    });

    return img;
}


// MARK: --
// MARK: Local cache

- (void)saveImage:(UIImage *)img withName:(NSString *)name {
    NSData *_pngData = UIImagePNGRepresentation(img);

    NSString *_imagePath = [NSString stringWithFormat:@"%@/%@.png", [self getCacheDirectoryPath], name];

    if ([[NSFileManager defaultManager] fileExistsAtPath:_imagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_imagePath error:nil];
    }

    [_pngData writeToFile:_imagePath atomically:YES];

    if (imagePaths == nil) {
        imagePaths = [NSMutableSet new];
    }

    [imagePaths addObject:_imagePath];
}

- (NSString *)getCacheDirectoryPath {
    NSArray *_array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    return _array[0];
}

- (UIImage *)getImageFromCacheWithName:(NSString *)name {
    NSString *_imagePath = [NSString stringWithFormat:@"%@/%@.png", [self getCacheDirectoryPath], name];

    if ([[NSFileManager defaultManager] fileExistsAtPath:_imagePath]) {
        UIImage *_image = [UIImage imageWithContentsOfFile:_imagePath];
        return _image;
    }

    return nil;
}

- (void)clearCacheImages {
    if (imagePaths == nil) {
        return;
    }

    for (NSString *path in imagePaths) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
        }
    }

    [imagePaths removeAllObjects];
}


// MARK: --
// MARK: UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *img = [self getImageFromLocalCache:indexPath.item];
        if (img == nil) {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = img;
            [cell.contentView addSubview:imgView];
        });
    });

    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(inset, inset, inset, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(widthOfScreen, widthOfScreen);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];

    [UIView animateWithDuration:0.7f animations:^{
        CGFloat pointXWithCoefficient = [self getWidthOfScreen] + inset * 2;
        cell.frame = CGRectOffset(cell.frame, pointXWithCoefficient, 0);

    }                completion:^(BOOL finished) {



//        [_collectionView cellForItemAtIndexPath:indexPath];
//        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        [imageUrls removeObjectAtIndex:(NSUInteger) indexPath.item];
    }];
}

@end
