//
//  NSString+PandaKit.h
//  PandaKitDemo
//
//  Created by Ricky on 16/1/28.
//  Copyright © 2016年 panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (PandaKit)

@property (nonatomic, readonly, strong) NSData* pd_MD5Data;
@property (nonatomic, readonly, copy) NSString* pd_MD5String;

@property (nonatomic, readonly, strong) NSData* pd_SHA1Data;
@property (nonatomic, readonly, copy) NSString* pd_SHA1String;

/// base64解码
@property (nonatomic, readonly, copy) NSString* pd_BASE64Decrypted;

// URL相关
- (NSArray*)pd_allURLs;

- (NSString*)pd_URLByAppendingDict:(NSDictionary*)params;
- (NSString*)pd_URLByAppendingDict:(NSDictionary*)params encoding:(BOOL)encoding;
- (NSString*)pd_URLByAppendingArray:(NSArray*)params;
- (NSString*)pd_URLByAppendingArray:(NSArray*)params encoding:(BOOL)encoding;
- (NSString*)pd_URLByAppendingKeyValues:(id)first, ...;

+ (NSString*)pd_queryStringFromDictionary:(NSDictionary*)dict;
+ (NSString*)pd_queryStringFromDictionary:(NSDictionary*)dict encoding:(BOOL)encoding;

+ (NSString*)pd_queryStringFromArray:(NSArray*)array;
+ (NSString*)pd_queryStringFromArray:(NSArray*)array encoding:(BOOL)encoding;
+ (NSString*)pd_queryStringFromKeyValues:(id)first, ...;

/// URL编码
- (NSString*)pd_URLEncoding;
/// URL解码
- (NSString*)pd_URLDecoding;

/// 从URL的query里返回字典, like "a=a&b=b".
- (NSMutableDictionary*)pd_dictionaryFromQueryComponents;

/// 去掉首尾的空格和换行
- (NSString*)pd_trim;
/// 去掉首尾的引号 " '
- (NSString*)pd_unwrap;
/// 拼接重复的self
- (NSString*)pd_repeat:(NSUInteger)count;
- (NSString*)pd_normalize;

- (BOOL)pd_match:(NSString*)expression;
- (BOOL)pd_matchAnyOf:(NSArray*)array;

- (BOOL)pd_empty;
- (BOOL)pd_notEmpty;

- (BOOL)pd_eq:(NSString*)other;
- (BOOL)pd_equal:(NSString*)other;

- (BOOL)pd_is:(NSString*)other;
- (BOOL)pd_isNot:(NSString*)other;

// 是否在array里, caseInsens 区分大小写
- (BOOL)pd_isValueOf:(NSArray*)array;
- (BOOL)pd_isValueOf:(NSArray*)array caseInsens:(BOOL)caseInsens;

#pragma mark - bee里的检测
- (BOOL)pd_isNormal;
- (BOOL)pd_isTelephone; 
- (BOOL)pd_isUserName;
- (BOOL)pd_isChineseUserName;
- (BOOL)pd_isPassword;
- (BOOL)pd_isEmail;
- (BOOL)pd_isURL;
- (BOOL)pd_isIPAddress;

#pragma mark - 额外的检测
// 包含一个字符和数字
- (BOOL)pd_isHasCharacterAndNumber;
// 昵称
- (BOOL)pd_isNickname;

- (NSString*)pd_substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet*)charset;
- (NSString*)pd_substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet*)charset endOffset:(NSUInteger*)endOffset;

+ (NSString*)pd_fromResource:(NSString*)resName;

// 中英文混排，获取字符串长度
- (NSInteger)pd_getLength;
- (NSInteger)pd_getLength2;

// Unicode格式的字符串编码转成中文的方法(如\u7E8C)转换成中文,unicode编码以\u开头
- (NSString*)pd_replaceUnicode;

/**
 * 擦除保存的值, 建议敏感信息在不用的是调用此方法擦除.
 * 如果是这样 _text = @"information"的 被分配到data区的无法擦除
 */
- (void)pd_erasure;

/// 返回单词缩写 (International Business Machines 变成 IBM)
- (NSString*)pd_stringByInitials;

/// 返回显示字串所需要的尺寸
- (CGSize)pd_calculateSize:(CGSize)size font:(UIFont*)font;

/// 返回阅读字串需要的时间 (length * 0.1 + 2, 2)
- (NSTimeInterval)pd_displayTime;

@end
