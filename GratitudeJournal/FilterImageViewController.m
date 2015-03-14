//
//  FilterImageViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/13/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "FilterImageViewController.h"

@interface FilterImageViewController ()

@property NSMutableArray *filterImgViews;
@property NSArray *filters;

@end

@implementation FilterImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.filterScrollView.contentSize = CGSizeMake(900, 100);
    self.filterImgViews = [[NSMutableArray alloc] initWithCapacity:8];
    self.filters = [NSArray arrayWithObjects:@"CILinearToSRGBToneCurve", @"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess", @"CIPhotoEffectTransfer", @"CISRGBToneCurveToLinear", @"CIVignetteEffect", nil];
    
    self.imageFullSize = [UIImage imageNamed:@"sample"];
    self.imageThumbnail = [self imageWithImage:[UIImage imageNamed:@"sample"] scaledToSize:CGSizeMake(100, 100)];
    
    //@@@why does this take so long to load?!!
    for (int i = 0; i < 9; i++) {
        NSLog(@"Applying filter: %@", [self.filters objectAtIndex:i]);
        
        //create raw CIImage
        CIImage *rawImageData = [[CIImage alloc] initWithImage:self.imageThumbnail];
        
        CIFilter *filter = [CIFilter filterWithName:[self.filters objectAtIndex:i]];
        [filter setDefaults];
        
        //set raw CIImage as input image
        [filter setValue:rawImageData forKey:@"inputImage"];
        //store filtered CIImage
        CIImage *filterImgData = [filter valueForKey:@"outputImage"];
        //create filtered UIImage with filtered CIImage
        UIImage *filterImg = [UIImage imageWithCIImage:filterImgData];
  
        //create a button to overlay over the frame of the image
        UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(i*100, 0, 100, 100)];
        filterButton.tag = i + 100;
        [filterButton addTarget:self action:@selector(chooseFilter:) forControlEvents:UIControlEventTouchUpInside];
        [filterButton setBackgroundImage:filterImg forState:UIControlStateNormal];
        [self.filterScrollView addSubview:filterButton];
        
        NSLog (@"Adding UIButton to scroll view");
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
    
    unsigned long filterIndex = sender.tag-100;
    NSLog(@"chose filter %lu", filterIndex);
    
    //CIImage *rawImageData = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    
    
    //[self.imageView setImage:
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
