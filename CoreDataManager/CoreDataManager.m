//
//  CoreDataManager.m
//  CoreDataDemo
//
//  Created by MengLong Wu on 16/10/13.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

//上下文对象 类似于FMDB对象
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//对象模型
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//数据存储的协调器
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

static CoreDataManager *__manager = nil;

@implementation CoreDataManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[CoreDataManager alloc]init];
    });
    return __manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        
        //    创建NSManagedObjectContext对象
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //    为NSManagedObjectContext对象设置存储协调器
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    //    xcdataModeld文件编译后为momd文件，从资源文件加载NSManagedObjectModel
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    //    通过NSManagedObjectModel对象创建NSPersistentStoreCoordinator对象
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //    获取Documents文件夹下的sqlite文件
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyCoreData.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:dbPath];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    //    加载sqlite数据库文件
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        加载出错就退出程序
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (BOOL)synchornize
{
    if (_managedObjectContext && [_managedObjectContext hasChanges]) {
        
        NSError *error = nil;
        BOOL ret = [_managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"存储失败 === %@",error);
        }
        return ret;
    }
    
    return NO;
}

- (BOOL)insertObjectWithEntity:(NSString *)entity parameter:(NSDictionary *)param
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:_managedObjectContext];
    
    for (NSString *key in param.allKeys) {
        [object setValue:param[key] forKey:key];
    }
    
    return YES;
}

- (BOOL)insertObjectWithEntity:(NSString *)entity completion:(ZYInsertBlock)completionHandle
{
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:_managedObjectContext];
    
    completionHandle(obj);
    
    if (obj) {
        return YES;
    }
    return NO;
}

- (NSArray *)queryWithEntity:(NSString *)entity
{
    return [self queryWithEntity:entity predicate:nil];
}
- (NSArray *)queryWithEntity:(NSString *)entity predicate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"查询失败 === %@",error);
        return nil;
    }
    return array;
}

- (BOOL)deleteObject:(NSManagedObject *)obj
{
    if (obj && [obj isKindOfClass:[NSManagedObject class]]) {
        [_managedObjectContext deleteObject:obj];
        return YES;
    }
    return NO;
}












@end
