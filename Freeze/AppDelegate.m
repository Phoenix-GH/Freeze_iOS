//
//  AppDelegate.m
//  Freeze
//
//  Created by SamuelCardo on 24/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSSNS/AWSSNS.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSWest2
                                                          identityPoolId:@"us-west-2:c327b0fa-3d44-4901-ab0d-31f4f5fe115c"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    AWSCognito *syncClient = [AWSCognito defaultCognito];
    
    // Create a record in a dataset and synchronize with the server
    AWSCognitoDataset *dataset = [syncClient openOrCreateDataset:@"myDataset"];
    [dataset setString:@"myValue" forKey:@"myKey"];
    [[dataset synchronize] continueWithBlock:^id(AWSTask *task) {
        // Your handler code here
        return nil;
    }];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    NSLog(@"%@",userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotification" object:nil];
    }
    
    else if([UIApplication sharedApplication].applicationState==UIApplicationStateActive){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotification" object:nil];
    }
    
    //When the app is in the background
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotification" object:nil];
        
    }//End background
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"deviceToken: %@", token);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    AWSSNS *sns = [AWSSNS defaultSNS];
    AWSSNSCreatePlatformEndpointInput *request = [AWSSNSCreatePlatformEndpointInput new];
//    request.token = token;
//    request.platformApplicationArn = SNSPlatformApplicationArn;
//    [[sns createPlatformEndpoint:request] continueWithBlock:^id(AWSTask *task) {
//        if (task.error != nil) {
//            NSLog(@"Error: %@",task.error);
//        } else {
//            AWSSNSCreateEndpointResponse *createEndPointResponse = task.result;
//            NSLog(@"endpointArn: %@",createEndPointResponse);
//            [[NSUserDefaults standardUserDefaults] setObject:createEndPointResponse.endpointArn forKey:@"endpointArn"];
//            [defaults setObject:createEndPointResponse.endpointArn forKey:@"devicetoken"];
//            [defaults synchronize];
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSString *user_id = [defaults objectForKey:@"user_id"];
//            if(user_id)
//            {
//                User * user_info = [User new];
//                user_info.user_id = user_id;
//                user_info.user_name = [defaults objectForKey:@"user_name"];
//                user_info.device_token=createEndPointResponse.endpointArn;
//                AWSDynamoDBObjectMapperConfiguration *updateMapperConfig = [AWSDynamoDBObjectMapperConfiguration new];
//                updateMapperConfig.saveBehavior = AWSDynamoDBObjectMapperSaveBehaviorAppendSet;
//                AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//                [[dynamoDBObjectMapper save:user_info configuration:updateMapperConfig]
//                 continueWithBlock:^id(AWSTask *task) {
//                     
//                     if (task.result) {
//                         NSLog(@"Push notification registered");
//                     }
//                     return nil;
//                 }];
//            }
//        }
//        
//        return nil;
   // }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
