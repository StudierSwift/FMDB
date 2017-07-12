//
//  ViewController.m
//  FMDBText
//
//  Created by IVT502 on 2017/6/21.
//  Copyright © 2017年 IVT. All rights reserved.
//

#import "ViewController.h"
#import "BasicDatabase.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BasicDatabase shareDatabase] creatTableWithModel:[Student class]];
}


/**
 增
 */
- (IBAction)addDatas{
    Student *stu = [[Student alloc] init];
    stu.name = @"zhangsan";
    stu.friends = @[@"lisi",@"wangwu"];
    [[BasicDatabase shareDatabase] insetModelData:stu];
}

/**
 删
 */
- (IBAction)deleteDatas{
    NSLog(@"删");
}

/**
 改
 */
- (IBAction)changeDatas{
    NSLog(@"改");
}

/**
 查
 */
- (IBAction)searchDatas{
    NSLog(@"查");
}

@end
