//
//  CoreDataManager.h
//  CoreDataDemo
//
//  Created by MengLong Wu on 16/10/13.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^ZYInsertBlock)(NSManagedObject *obj);

@interface CoreDataManager : NSObject

+ (instancetype)shareManager;

//存储
- (BOOL)synchornize;

//插入一条数据
- (BOOL)insertObjectWithEntity:(NSString *)entity parameter:(NSDictionary *)param;
//插入一条数据
- (BOOL)insertObjectWithEntity:(NSString *)entity completion:(ZYInsertBlock)completionHandle;

//删除
- (BOOL)deleteObject:(NSManagedObject *)obj;

//查询
- (NSArray *)queryWithEntity:(NSString *)entity;

- (NSArray *)queryWithEntity:(NSString *)entity predicate:(NSPredicate *)predicate;











@end
