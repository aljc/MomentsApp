//
//  MomentsTableViewCell.h
//  GratitudeJournal
//
//  Created by ajchang on 3/8/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *momentText;
@property (weak, nonatomic) IBOutlet UILabel *momentDate;

@end
