//
//  Database.m
//  EasyCar
//
//  Created by 易停科技－18 on 16/3/16.
//  Copyright © 2016年 深圳腾华兄弟互联技术有限公司. All rights reserved.
//

#import "Database.h"
#import "OftenAddressModel.h"
@implementation Database
{
    FMDatabase *database;
}
- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"MonkeyParking.db"];
        NSLog(@"%@",path);
        database = [[FMDatabase alloc] initWithPath:path];
        [database open];
        NSString *create = @"create table if not exists oftenAddress(id integer primary key,parkName text ,parkAddress text,type text)";
        [database executeUpdate:create];
        [database close];
    }
    return self;
}
+(Database*)shareDatabase
{
    static Database *myDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myDatabase = [[Database alloc] init];
    });
    return myDatabase;
}

-(void)insertIntoData:(NSArray*)arr
{
    [self editArrWith:arr];
    
    [database open];
    [database executeUpdate:@"delete from oftenAddress"];
    for (OftenAddressModel *model in arr) {
        [database executeUpdate:@"insert into oftenAddress (parkName,parkAddress,type) values (?,?,?)",model.parkName,model.parkAddress,model.addressType];
    }
    [database close];
}
//把前两个数据改为家庭和公司
-(void)editArrWith:(NSArray *)arr
{
    
}
-(BOOL)isExistsOfData
{
    BOOL boo = NO;
    [database open];
    if ([database intForQuery:@"select count(*) from oftenAddress"]) {
        boo = YES;
    }
    [database close];
    return boo;
}
-(NSMutableArray *)getAllData
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [database open];
    FMResultSet *result = [database executeQuery:@"select * from oftenAddress"];
    while ([result next]) {
        OftenAddressModel *model = [[OftenAddressModel alloc] init];
        model.parkName = [result stringForColumn:@"parkName"];
        model.parkAddress = [result stringForColumn:@"parkAddress"];
        model.addressType = [result stringForColumn:@"type"];
        [arr addObject:model];
    }
    [database close];
    return arr;
}


@end
