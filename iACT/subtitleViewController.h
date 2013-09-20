//
//  subtitleViewController.h
//  iACT
//
//  Created by yyj on 1/27/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subtitleViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView_;

@property (weak, nonatomic) IBOutlet UITextField *outputLabel;

@property(nonatomic) Boolean dateChooserVisible;
@property(nonatomic) Boolean dateStatus;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;



- (IBAction)sendSubtitle:(id)sender;

- (IBAction)showDateChooser:(id)sender;
-(void)showChosenDate:(NSDate *)chosenDate;
-(IBAction)dismissKeyBoard;

@end
