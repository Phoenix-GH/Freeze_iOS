//
//  MainVC.m
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "MainVC.h"
#import "StatusCell.h"
@implementation MainVC

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    
}

-(void) loadData
{
    self.userArray = [[NSMutableArray alloc]init];
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    
    [[dynamoDBObjectMapper scan:[User class] expression:scanExpression]
     continueWithBlock:^id(AWSTask *task) {
         
         if (task.result) {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             if([paginatedOutput.items count]>0)
             {
                 for(User *item in paginatedOutput.items)
                     [self.userArray addObject:item];
             }
              dispatch_async(dispatch_get_main_queue(), ^{
             [self.table reloadData];
              });
         
         }
         return nil;
     }];

}

- (IBAction)statusChanged:(UISwitch *)sender {
    User * currentUser = [User new];
    currentUser.user_id = [self.defaults objectForKey:@"currentUser"];
    
    NSString * status=@"Unknown";
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        status=@"Available";
    } else {
        status=@"Away";
    }
    
    currentUser.status = status;
    currentUser.update_time=[[NSDate date] timeIntervalSince1970];
    AWSDynamoDBObjectMapperConfiguration *updateMapperConfig = [AWSDynamoDBObjectMapperConfiguration new];
    updateMapperConfig.saveBehavior = AWSDynamoDBObjectMapperSaveBehaviorAppendSet;
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    [[dynamoDBObjectMapper save:currentUser configuration:updateMapperConfig]
     continueWithBlock:^id(AWSTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
         }
         if (task.exception) {
             NSLog(@"The request failed. Exception: [%@]", task.exception);
         }
         if (task.result) {
             NSLog(@"User status updated");
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self loadData];
             });
         }
         return nil;
     }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.userArray)
        return [self.userArray count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusCell * cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    User * user = [_userArray objectAtIndex:indexPath.row];
    [cell.userName setText:user.user_name];
    NSString * status;
    status = user.status;
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:user.update_time];
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
    int numberOfHours = secondsBetween/3600;
    if(numberOfHours>=2)
        status = @"Unknown";

    [cell.status setText:status];
    
    return cell;
}
- (IBAction)refreshTapped:(id)sender {
    [self loadData];
}
@end
