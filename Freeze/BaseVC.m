//
//  BaseVC.m
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//
#import "Constants.h"
#import "BaseVC.h"

@implementation BaseVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
}
- (void) displayAlert:(NSString*)title message:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)dismissVC{
    NSLog(@"%@",self.navigationController.viewControllers);
    if (self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) send_notification:(User*)user message:(NSString*)message
{
    
//    NSString * device_id = user.device_token;
//    
//    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
//                                                          initWithRegionType:AWSRegionAPNortheast1
//                                                          identityPoolId:CognitoIdentityPoolId];
//    
//    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:CognitoRegionType credentialsProvider:credentialsProvider];
//    
//    AWSSNS *snsClient = [[AWSSNS alloc]configuration:configuration];
//    AWSSNSPublishInput *pr = [[AWSSNSPublishInput alloc] init];
//    pr.targetArn= device_id;
//    
//    pr.message = message;
//    
//    [[snsClient publish:pr] continueWithBlock:^id(AWSTask *task) {
//        if (task.error) {
//            NSLog(@"Error publishing message: %@", task.error);
//            return nil;
//        }
//        
//        NSLog(@"Published: %@", task.result);
//        return task;
//    }];
    
}

@end
