//
//  BasicDatabase.h
//  FMDBText
//
//  Created by IVT502 on 2017/6/21.
//  Copyright © 2017年 IVT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicDatabase : NSObject


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
 创建数据库
 
 @param model 数据模型
 */
- (void)creatTableWithModel:(Class)model;

- (void)insetModelData:(id)model;

@end
