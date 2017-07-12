//
//  BasicDatabase.m
//  FMDBText
//
//  Created by IVT502 on 2017/6/21.
//  Copyright © 2017年 IVT. All rights reserved.
//

#import "BasicDatabase.h"
#import "FMDB.h"
#import "FMDatabaseQueue.h"
#import <objc/runtime.h>

@interface BasicDatabase ()

@property (nonatomic, strong, readonly) FMDatabaseQueue *dbQueue;

@end

@implementation BasicDatabase

static BasicDatabase *_instance;

+ (instancetype)shareDatabase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BasicDatabase alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self dbPath]];
    }
    return self;
}

- (NSString *)dbPath{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [filePath stringByAppendingPathComponent:@"fmdb.sqlite"];
}

/**
 获取模型的属性

 @param model 数据模型
 @return 返回数据模型的所有属性
 */
- (NSArray *)getAllPropertiesWithModel:(Class)model
{
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

/**
 获取对象的所有属性 以及属性值

 @param model 数据模型
 @return 属性和属性值
 */
- (NSDictionary *)getProperties_apsWithModel:(id)model
{
    unsigned int count, i;
 
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    for (i = 0; i<count; i++)
    {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}


/**
 创建数据库

 @param model 数据模型
 */
- (void)creatTableWithModel:(Class)model{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            NSMutableString *tempStr = [NSMutableString string];
            for (NSString *propertyStr in [self getAllPropertiesWithModel:model]) {
                [tempStr appendFormat:@"%@ TEXT,",propertyStr];
            }
            if (tempStr.length) {
                tempStr = [[tempStr substringToIndex:tempStr.length-1] mutableCopy];
            }
            NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,%@)", NSStringFromClass(model),tempStr];
            
            BOOL flag = [db executeUpdate:sqlStr];
            if (flag) {
                NSLog(@"创建t_%@表成功",NSStringFromClass(model));
            }else{
                NSLog(@"创建t_%@表失败",NSStringFromClass(model));
            }
        }else{
            NSLog(@"数据库打开失败");
        }
    }];
}

- (void)insetModelData:(id)model{
    [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableString *tempStr1 = [NSMutableString string];
        NSMutableString *tempStr2 = [NSMutableString string];
        for (NSString *propertyStr in [self getAllPropertiesWithModel:[model class]]) {
            [tempStr1 appendFormat:@"%@,",propertyStr];
            [tempStr2 appendString:@"?,"];
        }
        if (tempStr1.length) {
            tempStr1 = [[tempStr1 substringToIndex:tempStr1.length - 1] mutableCopy];
        }
        if (tempStr2.length) {
            tempStr2 = [[tempStr2 substringToIndex:tempStr2.length - 1] mutableCopy];
        }
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO t_%@ (%@) VALUES (%@);",NSStringFromClass([model class]),tempStr1,tempStr2];
        NSLog(@"%@",sqlStr);
        
        
        BOOL success =  [db executeUpdate:sqlStr];
        if (success) {
            NSLog(@"保存数据成功");
        }else{
            NSLog(@"保存数据失败");
        }

    }];
}

@end
