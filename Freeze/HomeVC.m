//
//  HomeVC.m
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "HomeVC.h"

@implementation HomeVC
- (IBAction)signupTapped:(id)sender {
    [self performSegueWithIdentifier:@"signup" sender:self];
}
- (IBAction)loginTapped:(id)sender {
    [self performSegueWithIdentifier:@"login" sender:self];
}

@end
