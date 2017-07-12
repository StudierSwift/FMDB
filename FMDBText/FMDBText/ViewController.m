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
    [[BasicDatabase shareDatabase] creatTableWithName:@"student" model:[Student class]];
}


/**
 增
 */
- (IBAction)addDatas{
    
    NSLog(@"增");
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
