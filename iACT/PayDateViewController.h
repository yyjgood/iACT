//
//  PayDateViewController.h
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetPayRecordViewController.h"

@interface PayDateViewController : UIViewController

@property (strong, nonatomic) id delegate;

- (IBAction)dismissDateChooser:(id)sender;
- (IBAction)setDate:(id)sender;

@end
