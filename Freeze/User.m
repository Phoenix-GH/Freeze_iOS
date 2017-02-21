//
//  User.m
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import "User.h"

@implementation User

+ (NSString *)dynamoDBTableName {
    return @"Users";
}

+ (NSString *)hashKeyAttribute {
    return @"user_id";
}

@end