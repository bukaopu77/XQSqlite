//
//  ViewController.m
//  SQLite
//
//  Created by 周剑 on 15/12/18.
//  Copyright © 2015年 bukaopu. All rights reserved.
//

#import "ViewController.h"
#import "XQDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 创建并打开数据库
- (IBAction)openAndCreate:(id)sender {
    [[XQDataManager sharedManager] openDataBase];
}
#pragma mark - 关闭数据库
- (IBAction)closeBtnAction:(id)sender {
    [[XQDataManager sharedManager] closeDataBase];
}
#pragma mark - 创建表
- (IBAction)createTable:(id)sender {
    [[XQDataManager sharedManager] createTable];
}
#pragma mark - 插入一条数据
- (IBAction)insertData:(id)sender {
    NSString *infoString = @"呵呵";
    NSData *data = [infoString dataUsingEncoding:NSUTF8StringEncoding];
    [[XQDataManager sharedManager] insertDataToTableWithUserName:@"bukaopu" withPwd:@"111" withUserInfo:data];
    [[XQDataManager sharedManager] insertDataToTableWithUserName:@"bukaopu77" withPwd:@"222" withUserInfo:data];
    [[XQDataManager sharedManager] insertDataToTableWithUserName:@"bukaopu777" withPwd:@"333" withUserInfo:data];
}
#pragma mark - 查询所有
- (IBAction)selectAllData:(id)sender {
    [[XQDataManager sharedManager] selectAllDataFromDataBase];
}
#pragma mark - 根据姓名删除一条数据
- (IBAction)deleteDataByName:(id)sender {
    [[XQDataManager sharedManager] deleteDataWithName:@"bukaopu"];
}
#pragma mark - 根据姓名更新数据
- (IBAction)updateDataByName:(id)sender {
    [[XQDataManager sharedManager] updatePwd:@"555" withName:@"bukaopu77"];
}



@end
