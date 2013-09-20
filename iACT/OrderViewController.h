//
//  OrderViewController.h
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel2;

- (IBAction)addUserOrder:(id)sender;
@end
