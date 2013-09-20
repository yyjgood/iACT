//
//  IACTViewController.h
//  iACT
//
//  Created by yyj on 1/9/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IACTViewController : UIViewController

@property (strong, nonatomic) NSString *UID;
@property (strong, nonatomic) NSString *userMobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UISwitch *switchStatus;


- (IBAction)login:(id)sender;

- (IBAction)hideKeyboard:(id)sender;



@end
