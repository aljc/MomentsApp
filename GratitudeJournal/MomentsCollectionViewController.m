//
//  MomentsCollectionViewController.m
//  GratitudeJournal
//
//  Created by Alice Chang on 3/15/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "MomentsCollectionViewController.h"
#import "MomentsCollectionViewCell.h"
#import <sys/utsname.h>
#import <Social/Social.h>

@interface MomentsCollectionViewController ()

@property CGRect zoomFrame;
@property UIImage *zoomImage;

@end

@implementation MomentsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tag = 303;
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshCollection) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //If we arrived at this view controller from the submitMoment segue, add the new moment to saved moments.
    if (self.moment != NULL) {
        self.savedMoments = [defaults objectForKey:@"moments"];
        
        NSLog(@"Adding submitted moment to user defaults");
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.title = @"Moments";
        
        [self addMomentToDefaults];
    }
    
    NSLog(@"Updating savedMoments");
    self.savedMoments = [defaults objectForKey:@"moments"];
    
    [self.collectionView reloadData];
}

//Refresh the data.
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

//Add newly submitted moment to user defaults and update savedMoments.
- (void)addMomentToDefaults {
    if (self.moment != NULL) {
        [self presentComeBackTomorrow];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //Encode the data: Moment -> NSData
        NSData *momentData = [NSKeyedArchiver archivedDataWithRootObject:self.moment];
        
        NSMutableArray *tempMoments = [[NSMutableArray alloc] init];
        tempMoments = [NSMutableArray arrayWithArray:[defaults objectForKey:@"moments"]]; //NSArray -> NSMutableArray
        [tempMoments insertObject:momentData atIndex:0]; //then add the new moment to it
        
        self.savedMoments = [NSArray arrayWithArray:tempMoments]; //NSMutableArray -> NSArray
        
        [defaults setObject:self.savedMoments forKey:@"moments"];
        [defaults synchronize];
        
        [self.collectionView reloadData];
        
        self.moment = nil;
        NSLog(@"Finished adding new moment to defaults");
    }
}

//Present the "Come back tomorrow" view after user has finished submitting daily moment.
- (void) presentComeBackTomorrow {
    NSLog(@"Presenting come back tomorrow");
    
    UIView *comeBackTomorrow = [[UIView alloc] init];
    comeBackTomorrow.layer.cornerRadius = 10;
    
    [comeBackTomorrow setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/4, 200, 150)];
    comeBackTomorrow.backgroundColor = [UIColor colorWithRed:0.627 green:0.569 blue:0.929 alpha:1];
    comeBackTomorrow.alpha = 0;
    
    UILabel *mainText = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, comeBackTomorrow.frame.size.width, 30)];
    mainText.text = @"Great job!";
    [mainText setFont:[UIFont fontWithName:@"Avenir-Heavy" size:25.0]];
    mainText.textColor = [UIColor whiteColor];
    mainText.textAlignment = NSTextAlignmentCenter;
    UILabel *subtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, comeBackTomorrow.frame.size.width-15, 60)];
    subtext.text = @"Keep going, or come back tomorrow to record another moment!";
    subtext.numberOfLines = 3;
    [subtext setFont:[UIFont fontWithName:@"Avenir" size:14.0]];
    subtext.textColor = [UIColor whiteColor];
    subtext.textAlignment = NSTextAlignmentCenter;
    
    [comeBackTomorrow addSubview:mainText];
    [comeBackTomorrow addSubview:subtext];
    
    [self.view addSubview:comeBackTomorrow];
    
    //fade-in the view
    [UIView animateWithDuration:2.0 animations:^{
        comeBackTomorrow.alpha = 0.9;
    } completion:^(BOOL finished) { //fade-out the view
        [UIView animateWithDuration:1.0 animations:^{
            sleep(1.0); //keep the view on the screen for an extra 1.0 second
            comeBackTomorrow.alpha = 0;
        } completion:^(BOOL finished) {
            [comeBackTomorrow removeFromSuperview];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UICollectionViewDelegateFlowLayout

//define the size of each cell rendered by the collection view
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    //return these edge inset values for iPhone 5S or older
    if (screenBounds.size.height <= 568) {
        NSLog(@"Current device is iPhone 5S or older");
        return CGSizeMake(130, 130);
    }
    return CGSizeMake(150, 150);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.savedMoments count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MomentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"momentsCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    NSLog(@"Populating collection view cells");
    
    NSData *currentMoment = [self.savedMoments objectAtIndex:indexPath.row];
    
    //Decode NSData -> Moment
    Moment *currentMomentDecoded= (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:currentMoment];
    
    NSLog(@"Decoded moment: %@", currentMomentDecoded.text);
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.clipsToBounds = YES;
    [cell.imageView setImage:currentMomentDecoded.image];
    
    cell.layer.cornerRadius = 3;
    
    return cell;
}

#pragma mark - Cell selection

//If a cell is selected, zoom to the cell image.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self zoomToSelectedImage:indexPath];
}

//Animate the zoom to a cell image upon selection.
//Source: http://stackoverflow.com/questions/24741597/uicollectionview-full-screen-zoom-on-uicollectionviewcell
- (void)zoomToSelectedImage:(NSIndexPath *)indexPath

{
    NSLog(@"Zooming to cell image");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];

    NSData* selectedMomentData =[self.savedMoments objectAtIndex:indexPath.row];
    Moment *selectedMoment= (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:selectedMomentData];
    
    UIImageView *zoomImage = [[UIImageView alloc] initWithImage:selectedMoment.image];
    zoomImage.contentMode = UIViewContentModeScaleAspectFit;
    zoomImage.tag = 302;
    self.zoomImage = zoomImage.image;
    
    //Define the end frame of the zoom
    CGRect zoomFrameTo = CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height);
    UICollectionView *cv = (UICollectionView *)[self.view viewWithTag:301];
    cv.hidden = TRUE;
    UICollectionViewCell *cellToZoom =(UICollectionViewCell *)[cv cellForItemAtIndexPath:indexPath];
    //Define the begin frame of the zoom
    CGRect zoomFrameFrom = cellToZoom.frame;
    
    [self.view addSubview:zoomImage];
    zoomImage.frame = zoomFrameFrom;
    zoomImage.alpha = 0.2;
    
    //Create back button to return to grid view
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 70, 30)];
    backButton.tag = 304;
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 10;
    backButton.clipsToBounds = YES;
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [[backButton layer] setBorderWidth:1.0f];
    [[backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    backButton.backgroundColor = [UIColor colorWithRed:0.627 green:0.569 blue:0.929 alpha:1];
    backButton.titleLabel.textColor = [UIColor whiteColor];
    [backButton addTarget:self action:@selector(dismissCell:) forControlEvents:UIControlEventTouchUpInside];
    backButton.alpha = 0;
    [self.view addSubview:backButton];
    
    //Create share button to allow user to post selected image to Facebook
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 20, 70, 30)];
    shareButton.tag = 305;
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.layer.cornerRadius = 10;
    shareButton.clipsToBounds = YES;
    shareButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [[shareButton layer] setBorderWidth:1.0f];
    [[shareButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [shareButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    shareButton.backgroundColor = [UIColor colorWithRed:0.627 green:0.569 blue:0.929 alpha:1];
    shareButton.titleLabel.textColor = [UIColor whiteColor];
    [shareButton addTarget:self action:@selector(configureSocial:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.alpha = 0;
    [self.view addSubview:shareButton];
    
    //Animate the zoom
    [UIView animateWithDuration:0.3 animations:
     ^{
         zoomImage.frame = zoomFrameTo;
         zoomImage.alpha = 1;
         backButton.alpha = 1;
         shareButton.alpha = 1;
     } completion:nil];
    
    //Save the begin frame of the zoom for later zoom-out purposes
    self.zoomFrame = zoomFrameFrom;
}

//Zoom out to grid view upon user pressing "Back" button from a selected cell.
- (IBAction)dismissCell:(UIButton *)sender {
    NSLog(@"Button pressed target action: dismiss selected cell");
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
        UIButton *backButton =  (UIButton*)[self.view viewWithTag:304];
        [backButton removeFromSuperview];
        UIButton *shareButton =  (UIButton*)[self.view viewWithTag:305];
        [shareButton removeFromSuperview];
        self.zoomImage = nil;
    }];
}

//Display a Facebook sheet to allow user to post moment to Facebook.
- (IBAction)configureSocial:(UIBarButtonItem *)sender {

    SLComposeViewController *socialController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [socialController setInitialText:@"Check out my daily moment!"];
    [socialController addImage:self.zoomImage];
    [self presentViewController:socialController animated:YES completion:nil];
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
