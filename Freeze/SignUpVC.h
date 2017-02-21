//
//  SignUpVC.h
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface SignUpVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *lblUserName;
@property (weak, nonatomic) IBOutlet UITextField *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;
@property (weak, nonatomic) IBOutlet UITextField *lblConfirm;
- (IBAction)signupTapped:(UIButton *)sender;

@end
