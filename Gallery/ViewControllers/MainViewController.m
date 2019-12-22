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


    imageUrls = [NSMutableArray new];

    [imageUrls addObject:@"https://avatars.mds.yandex.net/get-pdb/1774534/fa0473b1-2936-4815-b2fd-3295397e4563/s1200"];
    [imageUrls addObject:@"https://wallbox.ru/resize/1024x768/wallpapers/main/201407/63883e862ce5139.jpg"];
    [imageUrls addObject:@"https://www.nastol.com.ua/pic/201509/1680x1050/nastol.com.ua-150389.jpg"];
    [imageUrls addObject:@"https://wallbox.ru/wallpapers/main2/201715/149218094758f0dfd310e6b5.70800569.jpg"];
    [imageUrls addObject:@"https://images.wallpaperscraft.ru/image/devushka_lico_glaza_blondinka_zagadochnyy_11405_1920x1200.jpg"];
    [imageUrls addObject:@"https://img4.goodfon.com/original/2048x1363/9/41/devushka-briunetka-vzgliad-pricheska-makiiazh-kurtka-mekh-ka.jpg"];

    [imageUrls addObject:@"https://wallbox.ru/wallpapers/main/201407/63883e862ce5139.jpg"];
    [imageUrls addObject:@"https://wallbox.ru/wallpapers/main2/201728/14996982235963942f293c18.02682269.jpg"];
    [imageUrls addObject:@"https://cdn.fishki.net/upload/post/2017/05/23/2296943/e69cba7e5841a6f724c3c3ab6b2da9e8.jpg"];
    [imageUrls addObject:@"https://armcasting.am/wp-content/uploads/2018/01/Girls_Smiling_beautiful_girl__photo_George_Chernyad_ev_111193_.jpg"];
    [imageUrls addObject:@"https://pbs.twimg.com/media/BJANyPNCYAENgZI.jpg:large"];
    [imageUrls addObject:@"https://wallbox.ru/wallpapers/main/201624/e9de2b3d7d91ce4.jpg"];
    [imageUrls addObject:@"https://bipbap.ru/wp-content/uploads/2017/09/diana_melison_girl_model_russian_tattoos_grass_green_birthmark_66286_1280x1024-1.jpg"];
    [imageUrls addObject:@"https://img1.badfon.ru/original/1920x1200/8/17/fon-belyy-krasivaya-volosy.jpg"];
    [imageUrls addObject:@"https://i.artfile.me/wallpaper/13-08-2012/1920x1188/ara-ampaio-devushki-652797.jpg"];
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


// MARK: --
// MARK: UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];


    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = imageUrls[(NSUInteger) indexPath.row];
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
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


@end
