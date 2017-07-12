//
//  BasicDatabase.h
//  FMDBText
//
//  Created by IVT502 on 2017/6/21.
//  Copyright © 2017年 IVT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface BasicDatabase : NSObject

@property (nonatomic, strong, readonly) FMDatabaseQueue *dbQueue;

/**
 单例方法
 */
+ (instancetype)shareDatabase;

/**
 数据库地址

 @return 返回数据库地址
 */
- (NSString *)dbPath;


/**
 创建表

 @param tableName 表名称
 @param model 数据模型
 */
- (void)creatTableWithName:(NSString *)tableName model:(Class)model;

@end
