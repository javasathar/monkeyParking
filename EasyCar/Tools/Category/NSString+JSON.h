//
//  NSString+JSON.h
//  Microteam
//
//  Created by Sandy on 15/3/4.
//  Copyright (c) 2015年 vsteam. All rights reserved.
//

@interface NSString (JSON)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonBracketWithString:(NSString *) string;
+(NSString *) jsonSemicolonWithString:(NSString *) string;
+(NSString *) jsonEqualWithString:(NSString *) string;
+(NSString *) jsonEqualWithStringByRed:(NSString *) string;
+(NSString *) jsonStringWithObject:(id) object;

@end
