//
//  TextEffectsViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/14/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "TextEffectsViewController.h"

@interface TextEffectsViewController ()

@end

@implementation TextEffectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImage:self.moment.image];
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

@end
