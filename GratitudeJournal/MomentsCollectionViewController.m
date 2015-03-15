//
//  MomentsCollectionViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/15/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "MomentsCollectionViewController.h"
#import "MomentsCollectionViewCell.h"
#import <sys/utsname.h>

@interface MomentsCollectionViewController ()

@property NSArray *recipePhotos;

@end

@implementation MomentsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _recipePhotos = [NSArray arrayWithObjects:@"creme_brelee.png", @"egg_benedict.png", @"full_breakfast.png", @"green_tea.png", @"ham_and_cheese_panini.png", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDelegateFlowLayout

//define the size of each cell rendered by the collection view
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(140, 140);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"EDGE INSETS");

    UIEdgeInsets edgeInsets;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSLog(@"Current device is an iPad");
        
        edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    }
    else {
        NSLog(@"Current device is an iPhone");
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        NSLog(@"Current device screen height: %f", screenBounds.size.height);
        
        //return these edge inset values for iPhone 5S or older
        if (screenBounds.size.height <= 568) {
            edgeInsets = UIEdgeInsetsMake(30,15,30,15);
        }
        //iPhone 6 and 6+
        else if (screenBounds.size.height <= 736) {
            edgeInsets = UIEdgeInsetsMake(50, 30, 50, 30);
        }
        else {
            edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
        }
    }
    
    return edgeInsets;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return [self.savedMoments count];
    return _recipePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recipeCell" forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:300];
    //recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
    recipeImageView.clipsToBounds = YES;
    recipeImageView.image = [UIImage imageNamed:[_recipePhotos objectAtIndex:indexPath.row]];
    
//    // Configure the cell
//    
//    NSLog(@"populating collection view cells");
//    
//    NSData *currentMoment = [self.savedMoments objectAtIndex:indexPath.row];
//    
//    //DECODE DATA: NSDATA -> MOMENT
//    Moment *currentMomentDecoded= (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:currentMoment];
//    
//    NSLog(@"DECODED MOMENT: %@", currentMomentDecoded.text);
//    
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    cell.imageView.clipsToBounds = YES;
//    [cell.imageView setImage:currentMomentDecoded.image];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
