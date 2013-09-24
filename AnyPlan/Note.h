//
//  Note.h
//  Anyplan
//
//  Created by Ken Tsutsumi on 13/05/31.
//  Copyright (c) 2013年 Ken Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * editedDate;
@property (nonatomic, retain) Project *project;

@end
