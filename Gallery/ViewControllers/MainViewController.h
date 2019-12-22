//
//  MainViewController.h
//  Gallery
//
//  Created by Nikolay Eckert on 16.12.2019.
//  Copyright © 2019 Nikolay Eckert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
}


@end

