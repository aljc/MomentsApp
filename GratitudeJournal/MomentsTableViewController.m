//
//  MomentsTableViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "MomentsTableViewCell.h"
#import "Moment.h"

@interface MomentsTableViewController ()

@end

@implementation MomentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _moments = [defaults objectForKey:@"moments"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1; //1 section for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_moments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCell" forIndexPath:indexPath];
    
    NSLog(@"populating table view cells");
    
    // Configure the cell...
    NSData *currentMoment = [_moments objectAtIndex:indexPath.row];
    
    //DECODE DATA: NSDATA -> MOMENT
    Moment *currentMomentRetrieved = (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:currentMoment];
    
    NSLog(@"RETRIEVE MOMENT: %@", cell.momentText.text = currentMomentRetrieved.text);
    cell.momentText.text = currentMomentRetrieved.text;
    cell.momentDate.text = currentMomentRetrieved.date;
    
    cell.imageView1.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView1.clipsToBounds =YES;
    [cell.imageView1 setImage:currentMomentRetrieved.image];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
