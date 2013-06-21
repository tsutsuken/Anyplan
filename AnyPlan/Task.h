//
//  Task.h
//  AnyPlan
//
//  Created by Ken Tsutsumi on 2013/06/19.
//  Copyright (c) 2013年 Ken Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Repeat;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSDate * completedDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) Repeat *repeat;

@end
