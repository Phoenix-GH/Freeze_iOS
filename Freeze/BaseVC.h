//
//  BaseVC.h
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseVC.h"
#import <AWSCore/AWSCore.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import <AWSSNS/AWSSNS.h>

#import <AWSCognito/AWSCognito.h>

#import "User.h"
@interface BaseVC : UIViewController
@property(strong,nonatomic) NSUserDefaults *defaults;
- (void) displayAlert:(NSString*)title message:(NSString*)message;
- (void)dismissVC;
@end
