//
//  LoginVC.m
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "LoginVC.h"

@implementation LoginVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (IBAction)back:(id)sender {
    [self dismissVC];
}

- (IBAction)loginTapped:(id)sender {
    NSString * email = _lblEmail.text;
    NSString * password = _lblPassword.text;
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    
    scanExpression.filterExpression = @"user_id = :val";
    scanExpression.expressionAttributeValues = @{@":val":email};
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center=self.view.center;
    
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [[dynamoDBObjectMapper scan:[User class] expression:scanExpression]
     continueWithBlock:^id(AWSTask *task) {
         
         if (task.result) {
             [activityIndicator stopAnimating];
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             if([paginatedOutput.items count]>0)
             {
                 User *user = [paginatedOutput.items objectAtIndex:0];
                 if([user.password isEqualToString:password])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                     [self.defaults setObject:user.user_id forKey:@"currentUser"];
                     [self performSegueWithIdentifier:@"mainFromLogin" sender:self];
                     });
                 }
                 else
                 {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self displayAlert:@"Error" message:@"Login is invalid"];
                    });
                 }
             }
             else
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self displayAlert:@"Error" message:@"Login is invalid"];
                 });
             }
             
         }
         return nil;
     }];
    
}
@end
