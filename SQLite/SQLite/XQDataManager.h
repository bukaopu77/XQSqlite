//
//  XQDataManager.h
//  SQLite
//
//  Created by 周剑 on 15/12/18.
//  Copyright © 2015年 bukaopu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQDataManager : NSObject

+ (instancetype) sharedManager;

#pragma mark - 创建并打开数据库
- (void)openDataBase;

#pragma mark - 关闭数据库
- (void)closeDataBase;

#pragma mark - 创建表
- (void)createTable;

#pragma mark - 插入一条数据
- (void)insertDataToTableWithUserName:(NSString *)name withPwd:(NSString *)pwd withUserInfo:(NSData *)info;

#pragma mark - 查询数据库数据
- (void)selectAllDataFromDataBase;

#pragma mark - 根据姓名删除一条数据
- (void)deleteDataWithName:(NSString *)name;

#pragma mark - 根据姓名更新密码
- (void)updatePwd:(NSString *)pwd withName:(NSString *)name;

@end
