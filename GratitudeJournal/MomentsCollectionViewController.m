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
@property CGRect zoomFrame;

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
    //if we arrived at this view controller from the submitMoment segue
    if (self.moment != NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.savedMoments = [defaults objectForKey:@"moments"];
        
        NSLog(@"Adding moment to user defaults");
        NSLog(@"IMAGE: %@", self.moment.image);
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.title = @"Moments";
        [self addMomentToDefaults];
    }
    
    NSLog(@"updating savedMoments");
    self.savedMoments = [defaults objectForKey:@"moments"];
    
    //refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tag = 303;
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshCollection) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView reloadData];
}

- (void)refreshCollection {
    NSLog(@"Pull To Refresh");
    
    //Reload the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.view viewWithTag:303];
    
    [refreshControl endRefreshing];
    [self.collectionView reloadData];
}

#pragma mark - NSUserDefaults

- (void)addMomentToDefaults {
    //if a Moment object was passed in, that means a new moment was just created and must be added to NSUserDefaults.
    //(aka we arrived at this view controller via the "Submit" button and not the tab bar controller.)
    if (self.moment != NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //@@@WHY AREN'T FILTERED IMAGES ENCODING PROPERLY?!?!? *********
        //ENCODE THE DATA: MOMENT -> NSDATA
        NSData *momentData = [NSKeyedArchiver archivedDataWithRootObject:self.moment];
        
        //MOMENTS IS AN NSMUTABLEARRAY OF TYPE NSDATA
        NSMutableArray *tempMoments = [[NSMutableArray alloc] init];
        tempMoments = [NSMutableArray arrayWithArray:[defaults objectForKey:@"moments"]]; //NSArray -> NSMutableArray
        [tempMoments insertObject:momentData atIndex:0]; //then add the new moment to it
        
        self.savedMoments = [NSArray arrayWithArray:tempMoments]; //NSMutableArray -> NSArray
        
        [defaults setObject:self.savedMoments forKey:@"moments"];
        [defaults synchronize];
        
        [self.collectionView reloadData];
        NSLog(@"Finished adding new moment to defaults");
    }
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
    return [self.savedMoments count];
    //return _recipePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recipeCell" forIndexPath:indexPath];
    MomentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"momentsCell" forIndexPath:indexPath];
    
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:300];
//    //recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
//    recipeImageView.clipsToBounds = YES;
//    recipeImageView.image = [UIImage imageNamed:[_recipePhotos objectAtIndex:indexPath.row]];
    
    // Configure the cell
    
    NSLog(@"populating collection view cells");
    
    NSData *currentMoment = [self.savedMoments objectAtIndex:indexPath.row];
    
    //DECODE DATA: NSDATA -> MOMENT
    Moment *currentMomentDecoded= (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:currentMoment];
    
    NSLog(@"DECODED MOMENT: %@", currentMomentDecoded.text);
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.clipsToBounds = YES;
    [cell.imageView setImage:currentMomentDecoded.image];
    
    return cell;
}

#pragma mark - Cell selection

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    [self zoomToSelectedImage:indexPath];
}


- (void)zoomToSelectedImage:(NSIndexPath *)indexPath

{
    NSLog(@"zoom image");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];

    NSData* selectedMomentData =[self.savedMoments objectAtIndex:indexPath.row];
    
    Moment *selectedMoment= (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:selectedMomentData];
    
    UIImageView *zoomImage = [[UIImageView alloc] initWithImage:selectedMoment.image];
    zoomImage.contentMode = UIViewContentModeScaleAspectFit;
    zoomImage.tag = 302;
    
    CGRect zoomFrameTo = CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height);
    UICollectionView *cv = (UICollectionView *)[self.view viewWithTag:301];
    cv.hidden = TRUE;
    UICollectionViewCell *cellToZoom =(UICollectionViewCell *)[cv cellForItemAtIndexPath:indexPath];
    CGRect zoomFrameFrom = cellToZoom.frame;
    
    NSLog(@"got here");
    [self.view addSubview:zoomImage];
    zoomImage.frame = zoomFrameFrom;
    zoomImage.alpha = 0.2;
    
    [UIView animateWithDuration:0.2 animations:
     ^{
         zoomImage.frame = zoomFrameTo;
         zoomImage.alpha = 1;
     } completion:nil];
    
    self.zoomFrame = zoomFrameFrom;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 60, 25)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 10;
    backButton.clipsToBounds = YES;
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [[backButton layer] setBorderWidth:1.0f];
    [[backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    backButton.backgroundColor = [UIColor blueColor];
    backButton.titleLabel.textColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(dismissCell:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (IBAction)dismissCell:(UIButton *)sender {
    [self zoomOutFromSelectedImage:self.zoomFrame];
}

- (void)zoomOutFromSelectedImage:(CGRect)zoomFrame
{
    UIImageView *zoomImage = (UIImageView*)[self.view viewWithTag:302];
    [UIView animateWithDuration:0.2 animations:^{
        zoomImage.frame = zoomFrame;
        zoomImage.alpha = 1;
    } completion:^(BOOL finished) {
        [zoomImage removeFromSuperview];
        UICollectionView *cv = (UICollectionView *)[self.view viewWithTag:301];
        cv.hidden = FALSE;
    }];
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
