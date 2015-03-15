//
//  FilterImageViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/13/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "FilterImageViewController.h"
#import "TextEffectsViewController.h"
#import "MomentsTableViewController.h"

@interface FilterImageViewController ()

@property NSArray *filters;
@property NSArray *filterLabels;
@property int prevChosenFilterIndex;
@property BOOL doubleTapped;

@end

@implementation FilterImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //navigation bar should not cover top of view
    self.navigationController.navigationBar.translucent = NO;
    
    self.imageFullSize = [self imageWithImage:self.moment.image scaledToSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)]; //resize the image that was passed from the segue to the bounds of the imageView
    self.imageThumbnail = [self imageWithImage:self.imageFullSize scaledToSize:CGSizeMake(100, 100)]; //create the filter preview thumbnail version of the image
    
    self.prevChosenFilterIndex = -1;
    self.doubleTapped = NO;
    
    self.filterScrollView.contentSize = CGSizeMake(832, 120);
    self.filters = [NSArray arrayWithObjects:@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectNoir", @"CIPhotoEffectMono", @"CIPhotoEffectProcess", @"CIPhotoEffectTransfer", @"CIVignetteEffect", nil];
    self.filterLabels = [NSArray arrayWithObjects:@"Chrome", @"Fade", @"Instant", @"Noir", @"Mono", @"Process", @"Transfer", @"Vignette", nil];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor whiteColor];
    
    //initially display the original, un-filtered image
    [self.imageView setImage:self.imageFullSize];
    
    for (int i = 0; i < [self.filters count]; i++) {
        NSLog(@"Creating thumbnail for %@ filter", [self.filters objectAtIndex:i]);
        
        //create raw CIImage
        CIImage *rawThumbnailData = [[CIImage alloc] initWithImage:self.imageThumbnail];
        
        CIFilter *filter = [CIFilter filterWithName:[self.filters objectAtIndex:i]];
        [filter setDefaults];
        
        //set raw CIImage as input image
        [filter setValue:rawThumbnailData forKey:@"inputImage"];
        //store filtered CIImage
        CIImage *filterThumbnailData = [filter valueForKey:@"outputImage"];
        //create filtered UIImage with filtered CIImage
        UIImage *filterThumbnail = [UIImage imageWithCIImage:filterThumbnailData];
  
        //create a button to overlay over the frame of the image
        UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(i*100 + i*4, 0, 100, 100)];
        filterButton.tag = i + 100;
        filterButton.backgroundColor = [UIColor whiteColor];
        [filterButton addTarget:self action:@selector(chooseFilter:) forControlEvents:UIControlEventTouchUpInside];
        [filterButton setBackgroundImage:filterThumbnail forState:UIControlStateNormal];
        [self.filterScrollView addSubview:filterButton];
        
        UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*100 + i*4, 102, 100, 13)];
        filterLabel.text = [self.filterLabels objectAtIndex:i];
        filterLabel.font = [filterLabel.font fontWithSize:12];
        filterLabel.textAlignment = NSTextAlignmentCenter;
        filterLabel.backgroundColor = [UIColor clearColor];
        filterLabel.textColor = [UIColor lightGrayColor];
        
        [self.filterScrollView addSubview:filterLabel];
        
        NSLog (@"Adding UIButton and UILabel to scroll view");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Filter Actions

//http://ajourneywithios.blogspot.com/2012/03/resizing-uiimage-in-ios.html
- (UIImage*)imageWithImage:(UIImage*)image
scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)chooseFilter:(UIButton *)sender {
    
    //i've got a tag to refer to each button and to know which button was pressed.  can map to index of my
    //filter name array and apply that filter to the full image.
    
    int chosenFilterIndex = (int)sender.tag-100;
    NSLog(@"Chose %@ filter", [self.filters objectAtIndex:chosenFilterIndex]);
    
    //If a user double taps a filter preview, then remove that filter
    if (self.prevChosenFilterIndex == chosenFilterIndex && !self.doubleTapped) {
        self.doubleTapped = YES;
        
        //remove the border around chosen thumbnail
        [[sender layer] setBorderWidth:0.0f];
        
        [self.imageView setImage:self.imageFullSize]; //un-filter the image
    }
    else { //filter the image
        
        //remove border around previously chosen thumbnail
        UIButton *prevSender = (UIButton *)[self.view viewWithTag:(NSInteger)(self.prevChosenFilterIndex + 100)];
        [[prevSender layer] setBorderWidth:0.0f];
        
        //draw border around chosen thumbnail
        [[sender layer] setBorderWidth:3.0f];
        [[sender layer] setBorderColor:[UIColor blueColor].CGColor];
        
        CIImage *rawImageData = [[CIImage alloc] initWithImage:self.imageFullSize];
        CIFilter *filter = [CIFilter filterWithName:[self.filters objectAtIndex:chosenFilterIndex]];
        [filter setDefaults];
        [filter setValue:rawImageData forKey:@"inputImage"];
        
        CIImage *filterImgData = [filter valueForKey:@"outputImage"];
        UIImage *filterImg = [UIImage imageWithCIImage:filterImgData];
        
        [self.imageView setImage:filterImg];
        
        //reset these variables
        self.prevChosenFilterIndex = chosenFilterIndex;
        self.doubleTapped = NO;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addText"])
    {
        NSLog(@"Performing addText segue");
        
        //replace image with filtered image in Moment object
        self.moment.image = self.imageView.image;
        
        //pass updated Moment object with filtered image to Text Effects View Controller
        TextEffectsViewController *tvc = (TextEffectsViewController*) [segue destinationViewController];
        tvc.moment = self.moment;
    }
}

@end
