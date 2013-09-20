//
//  ExpendDateViewController.h
//  iACT
//
//  Created by hongyang on 13-2-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetExpendRecordViewController.h"

@interface ExpendDateViewController : UIViewController


@property (strong, nonatomic) id delegate;

- (IBAction)dismissDateChooser:(id)sender;
- (IBAction)setDate:(id)sender;

@end
