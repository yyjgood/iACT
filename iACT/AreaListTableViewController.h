//
//  AreaListTableViewController.h
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaListTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *areaName;
@property (strong, nonatomic)NSMutableArray *areaID;
@property (strong, nonatomic) NSString *uid;


@end
