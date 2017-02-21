//
//  SignUpVC.m
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "SignUpVC.h"


@implementation SignUpVC
-(void) viewDidLoad
{
    [super viewDidLoad];
    
}
- (IBAction)back:(id)sender {
    [self dismissVC];
}

- (IBAction)signupTapped:(UIButton *)sender {
    NSString * username = _lblUserName.text;
    NSString * email = _lblEmail.text;
    NSString * password = _lblPassword.text;
    NSString * confirmPassword = _lblConfirm.text;
    
    if([password isEqualToString:confirmPassword])
    {
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center=self.view.center;
        User * user_info = [User new];
        user_info.user_id = email;
        user_info.user_name = username;
        //user_info.device_token = [loginInfo objectForKey:@"devicetoken"];
        user_info.user_email= email;
        user_info.password = password;
        
        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
        
        scanExpression.filterExpression = @"user_id = :val";
        scanExpression.expressionAttributeValues = @{@":val":email};
        [activityIndicator startAnimating];
        [[dynamoDBObjectMapper scan:[User class] expression:scanExpression]
         continueWithBlock:^id(AWSTask *task) {
             
             if (task.result) {
                 [activityIndicator stopAnimating];
                 AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
                 if([paginatedOutput.items count]>0)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self displayAlert:@"Error" message:@"Invalid email"];
                     });
                 }
                 else
                 {
                     
                     AWSDynamoDBObjectMapperConfiguration *updateMapperConfig = [AWSDynamoDBObjectMapperConfiguration new];
                     updateMapperConfig.saveBehavior = AWSDynamoDBObjectMapperSaveBehaviorAppendSet;
                     AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
                     [[dynamoDBObjectMapper save:user_info configuration:updateMapperConfig]
                      continueWithBlock:^id(AWSTask *task) {
                          if (task.error) {
                              NSLog(@"The request failed. Error: [%@]", task.error);
                          }
                          if (task.exception) {
                              NSLog(@"The request failed. Exception: [%@]", task.exception);
                          }
                          if (task.result) {
                              NSLog(@"new user is registered");
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.defaults setObject:user_info.user_id forKey:@"currentUser"];
                                  [self.defaults synchronize];
                                  [self performSegueWithIdentifier:@"mainFromSignup" sender:self];
                              });
                          }
                          return nil;
                      }];
                 }
                 
             }
             return nil;
         }];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Passwords do not match" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
@end
