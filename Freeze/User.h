//
//  User.h
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AWSDynamoDB/AWSDynamoDB.h>

@interface User : AWSDynamoDBObjectModel <AWSDynamoDBModeling>
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_email;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString* device_token;
@property (nonatomic, strong) NSString* status;
@property double update_time;
@end
