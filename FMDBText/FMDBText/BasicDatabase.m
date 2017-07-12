//
//  BasicDatabase.m
//  FMDBText
//
//  Created by IVT502 on 2017/6/21.
//  Copyright © 2017年 IVT. All rights reserved.
//

#import "BasicDatabase.h"
#import <objc/runtime.h>
#import "FMDB.h"

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


- (void)creatTableWithName:(NSString *)tableName model:(Class)model{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            
            NSDictionary *dict = [self getProperties_apsWithModel:[model new]];
            NSLog(@"%@",dict);
            
            
//            BOOL flag = [db executeUpdate:@"create table if not exists t_chatmessagelist (\
//                         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,\
//                         holder         INTEGER,\
//                         messageid      INTEGER,\
//                         seqno          INTEGER,\
//                         userid         INTEGER,\
//                         icon           TEXT,\
//                         name           TEXT,\
//                         time           TEXT,\
//                         type           INTEGER,\
//                         text           TEXT,\
//                         datadevice     TEXT,\
//                         sosid          INTEGER,\
//                         pictureModel   BLOB,\
//                         recordModel    BLOB,\
//                         videoModel     BLOB,\
//                         messageMonitor BLOB,\
//                         doclst         BLOB,\
//                         state          INTEGER,\
//                         specialMessage INTEGER,\
//                         specialContent TEXT);"];
        }else{
            NSLog(@"数据库打开失败");
        }
    }];
}

@end
