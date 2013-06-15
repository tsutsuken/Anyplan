//
//  EditTaskViewController.h
//  AnyPlan
//
//  Created by Ken Tsutsumi on 13/04/25.
//  Copyright (c) 2013年 Ken Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectProjectViewController.h"
#import "EditMemoViewController.h"

@interface EditTaskViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) Task *task;
@property (assign, nonatomic) BOOL isNewTask;

- (IBAction)didPushDeleteButton;

@end
