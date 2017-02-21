//
//  LoginVC.h
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "BaseVC.h"

@interface LoginVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *lblEmail;
- (IBAction)loginTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;

@end
