//
//  MainVC.h
//  Freeze
//
//  Created by SamuelCardo on 25/10/16.
//  Copyright © 2016 Silvergate. All rights reserved.
//

#import "BaseVC.h"

@interface MainVC : BaseVC<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISwitch *status;
- (IBAction)statusChanged:(UISwitch *)sender;
@property(strong, nonatomic)NSMutableArray * userArray;
- (IBAction)refreshTapped:(id)sender;

@end
