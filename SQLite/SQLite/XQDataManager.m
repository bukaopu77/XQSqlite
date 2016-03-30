//
//  XQDataManager.m
//  SQLite
//
//  Created by 周剑 on 15/12/18.
//  Copyright © 2015年 bukaopu. All rights reserved.
//

#import "XQDataManager.h"
#import <sqlite3.h>

static XQDataManager *shared = nil;
@implementation XQDataManager

+ (instancetype)sharedManager {
    return  [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shared) {
            shared = [super allocWithZone:zone];
        }
    });
    return shared;
}

#pragma mark - 创建并打开数据库
static sqlite3 *db = nil;
- (void)openDataBase {
    if (db) {
        return;
    }
    // 创建这个数据库
    // 定义数据保存的路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"data.sqlite"];
    // 根据路径打开或者创建数据库
    int result = sqlite3_open([path UTF8String], &db);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else {
        NSLog(@"打开数据库失败");
    }
}
#pragma mark - 关闭数据库
- (void)closeDataBase {
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        NSLog(@"关闭数据库成功");
        db = nil;
    }else {
        NSLog(@"关闭数据库失败");
    }
}
#pragma mark - 创建表
- (void)createTable {
    // 1.sql语句
    NSString *sql = @"CREATE TABLE bukaopu(user_name TEXT PRIMARY KEY,user_pwd TEXT, user_info BLOB)";
    // 2.执行sql语句
    int result = sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"创建表格成功");
    }else {
        NSLog(@"创建表格失败");
    }
}
#pragma mark - 插入一条数据
- (void)insertDataToTableWithUserName:(NSString *)name withPwd:(NSString *)pwd withUserInfo:(NSData *)info {
    // 1.创建sql语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO bukaopu(user_name,user_pwd,user_info)VALUES(?,?,?)"];
    // 2.数据库准备状态
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        // 把要插入的数据绑定到结果集stmt里面
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [pwd UTF8String], -1, NULL);
        // 二进制数据第三个参数:需要把nsdata对象转化为const void *类型的C语言二进制数据
        // 第四个参数:数据的长度
        sqlite3_bind_blob(stmt, 3, [info bytes], (int)[info length], NULL);
        // 把结果集存入数据库
        sqlite3_step(stmt);
    }
    // 结果集完成(如果不结束,结果集会一直等待数据的输入,造成数据库无法关闭)
    sqlite3_finalize(stmt);
}
#pragma mark - 查询数据库数据
- (void)selectAllDataFromDataBase {
    NSString *sql = @"SELECT * FROM bukaopu";
    // 2.定义结果集对象
    sqlite3_stmt *stmt = nil;
    // 3.数据库准备完成
    int result = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 取出name
            const char *nameChar = (const char *)sqlite3_column_text(stmt, 0);
            NSString *name = [NSString stringWithCString:nameChar encoding:NSUTF8StringEncoding];
            // 取出pwd
            const char *pwdChar = (const char *)sqlite3_column_text(stmt, 1);
            NSString *pwd = [NSString stringWithCString:pwdChar encoding:NSUTF8StringEncoding];
            // 取出blob
            const void *infoC = sqlite3_column_blob(stmt, 2);
            int length = sqlite3_column_bytes(stmt, 2);
            NSData *info = [NSData dataWithBytes:infoC length:length];
            NSLog(@"%@ %@ %@", name, pwd, info);
        }
    }
    // 结束结果集
    sqlite3_finalize(stmt);
}
#pragma mark - 根据姓名删除一条数据
- (void)deleteDataWithName:(NSString *)name {
    NSString *sqlString = [NSString stringWithFormat:@"delete from bukaopu where user_name = '%@'", name];
    int result = sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    }else {
        NSLog(@"删除数据失败");
    }
}
#pragma mark - 根据姓名更新密码
- (void)updatePwd:(NSString *)pwd withName:(NSString *)name {
    NSString *sqlString = [NSString stringWithFormat:@"update bukaopu set user_pwd = '%@' where user_name = '%@'", pwd, name];
    int result = sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"更新成功");
    }else {
        NSLog(@"更新失败");
    }
}




@end
