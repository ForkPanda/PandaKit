//
//  NSString+PandaKit.m
//  PandaKitDemo
//
//  Created by Ricky on 16/1/28.
//  Copyright © 2016年 panda. All rights reserved.
//

#import "NSString+PandaKit.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (PandaKit)

// 这里有依赖了
@dynamic pd_SHA1String;
@dynamic pd_SHA1Data;
- (NSString*)pd_MD5String
{
    NSData* data = [NSData dataWithBytes:self.UTF8String length:self.length];
    uint8_t digest[CC_MD5_DIGEST_LENGTH + 1] = { 0 };

    CC_MD5(data.bytes, (CC_LONG)data.length, digest);

    char tmp[16] = { 0 };
    char hex[256] = { 0 };

    for (CC_LONG i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        sprintf(tmp, "%02X", digest[i]);
        strcat((char*)hex, tmp);
    }

    return [NSString stringWithUTF8String:(const char*)hex];
}
- (NSData*)pd_MD5Data
{
    NSData* data = [NSData dataWithBytes:self.UTF8String length:self.length];
    uint8_t digest[CC_MD5_DIGEST_LENGTH + 1] = { 0 };

    CC_MD5(data.bytes, (CC_LONG)data.length, digest);

    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

@dynamic pd_MD5String;
@dynamic pd_MD5Data;
- (NSString*)pd_SHA1String
{
    NSData* data = [NSData dataWithBytes:self.UTF8String length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    char tmp[16] = { 0 };
    char hex[256] = { 0 };

    for (CC_LONG i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i) {
        sprintf(tmp, "%02X", digest[i]);
        strcat((char*)hex, tmp);
    }

    return [NSString stringWithUTF8String:(const char*)hex];
}
- (NSData*)pd_SHA1Data
{
    NSData* data = [NSData dataWithBytes:self.UTF8String length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

@dynamic pd_BASE64Decrypted;
- (NSData*)pd_BASE64Decrypted
{
    static char* __base64EncodingTable = (char*)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    static char* __base64DecodingTable = nil;

    // copy from THREE20

    if (0 == [self length]) {
        return [NSData data];
    }

    if (NULL == __base64DecodingTable) {
        __base64DecodingTable = (char*)malloc(256);
        if (NULL == __base64DecodingTable) {
            return nil;
        }

        memset(__base64DecodingTable, CHAR_MAX, 256);

        for (int i = 0; i < 64; i++) {
            __base64DecodingTable[(short)__base64EncodingTable[i]] = (char)i;
        }
    }

    const char* characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
    if (NULL == characters) //  Not an ASCII string!
    {
        return nil;
    }

    char* bytes = (char*)malloc(([self length] + 3) * 3 / 4);
    if (NULL == bytes) {
        return nil;
    }

    NSUInteger length = 0;
    NSUInteger i = 0;

    while (1) {
        char buffer[4] = { 0 };
        short bufferLength = 0;

        for (bufferLength = 0; bufferLength < 4; i++) {
            if (characters[i] == '\0') {
                break;
            }

            if (isspace(characters[i]) || characters[i] == '=') {
                continue;
            }

            buffer[bufferLength] = __base64DecodingTable[(short)characters[i]];
            if (CHAR_MAX == buffer[bufferLength++]) {
                free(bytes);
                return nil;
            }
        }

        if (0 == bufferLength) {
            break;
        }

        if (1 == bufferLength) {
            // At least two characters are needed to produce one byte!

            free(bytes);
            return nil;
        }

        //  Decode the characters in the buffer to bytes.

        bytes[length++] = (char)((buffer[0] << 2) | (buffer[1] >> 4));

        if (bufferLength > 2) {
            bytes[length++] = (char)((buffer[1] << 4) | (buffer[2] >> 2));
        }

        if (bufferLength > 3) {
            bytes[length++] = (char)((buffer[2] << 6) | buffer[3]);
        }
    }

    realloc(bytes, length);

    return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSArray*)pd_allURLs
{
    NSMutableArray* array = [NSMutableArray array];

    NSInteger stringIndex = 0;
    while (stringIndex < self.length) {
        NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
        NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
        NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];

        NSRange startRange;
        if (httpRange.location == NSNotFound) {
            startRange = httpsRange;
        }
        else if (httpsRange.location == NSNotFound) {
            startRange = httpRange;
        }
        else {
            startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
        }

        if (startRange.location == NSNotFound) {
            break;
        }
        else {
            NSRange beforeRange = NSMakeRange(searchRange.location, startRange.location - searchRange.location);
            if (beforeRange.length) {
                //				NSString * text = [string substringWithRange:beforeRange];
                //				[array addObject:text];
            }

            NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
            NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
            if (endRange.location == NSNotFound) {
                NSString* url = [self substringWithRange:subSearchRange];
                [array addObject:url];
                break;
            }
            else {
                NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
                NSString* url = [self substringWithRange:URLRange];
                [array addObject:url];

                stringIndex = endRange.location;
            }
        }
    }

    return array;
}

+ (NSString*)pd_queryStringFromDictionary:(NSDictionary*)dict
{
    return [self pd_queryStringFromDictionary:dict encoding:YES];
}

+ (NSString*)pd_queryStringFromDictionary:(NSDictionary*)dict encoding:(BOOL)encoding
{
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in dict.allKeys) {
        NSString* value = dict[key];
        NSString* urlEncoding = encoding ? [value pd_URLEncoding] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }

    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString*)pd_queryStringFromArray:(NSArray*)array
{
    return [self pd_queryStringFromArray:array encoding:YES];
}

+ (NSString*)pd_queryStringFromArray:(NSArray*)array encoding:(BOOL)encoding
{
    NSMutableArray* pairs = [NSMutableArray array];

    for (NSUInteger i = 0; i < [array count]; i += 2) {
        NSObject* obj1 = [array objectAtIndex:i];
        NSObject* obj2 = [array objectAtIndex:i + 1];

        NSString* key = nil;
        NSString* value = nil;

        if ([obj1 isKindOfClass:[NSNumber class]]) {
            key = [(NSNumber*)obj1 stringValue];
        }
        else if ([obj1 isKindOfClass:[NSString class]]) {
            key = (NSString*)obj1;
        }
        else {
            continue;
        }

        if ([obj2 isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber*)obj2 stringValue];
        }
        else if ([obj1 isKindOfClass:[NSString class]]) {
            value = (NSString*)obj2;
        }
        else {
            continue;
        }

        NSString* urlEncoding = encoding ? [value pd_URLEncoding] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }

    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString*)pd_queryStringFromKeyValues:(id)first, ...
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];

    va_list args;
    va_start(args, first);

    for (;;) {
        NSObject<NSCopying>* key = [dict count] ? va_arg(args, NSObject*) : first;
        if (nil == key)
            break;

        NSObject* value = va_arg(args, NSObject*);
        if (nil == value)
            break;

        [dict setObject:value forKey:key];
    }
    va_end(args);
    return [NSString pd_queryStringFromDictionary:dict];
}

- (NSString*)pd_URLByAppendingDict:(NSDictionary*)params
{
    return [self pd_URLByAppendingDict:params encoding:YES];
}

- (NSString*)pd_URLByAppendingDict:(NSDictionary*)params encoding:(BOOL)encoding
{
    NSURL* parsedURL = [NSURL URLWithString:self];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString* query = [NSString pd_queryStringFromDictionary:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString*)pd_URLByAppendingArray:(NSArray*)params
{
    return [self pd_URLByAppendingArray:params encoding:YES];
}

- (NSString*)pd_URLByAppendingArray:(NSArray*)params encoding:(BOOL)encoding
{
    NSURL* parsedURL = [NSURL URLWithString:self];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString* query = [NSString pd_queryStringFromArray:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString*)pd_URLByAppendingKeyValues:(id)first, ...
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];

    va_list args;
    va_start(args, first);

    for (;;) {
        NSObject<NSCopying>* key = [dict count] ? va_arg(args, NSObject*) : first;
        if (nil == key)
            break;

        NSObject* value = va_arg(args, NSObject*);
        if (nil == value)
            break;

        [dict setObject:value forKey:key];
    }
    va_end(args);
    return [self pd_URLByAppendingDict:dict];
}

- (BOOL)pd_empty
{
    return [self length] > 0 ? NO : YES;
}

- (BOOL)pd_notEmpty
{
    return [self length] > 0 ? YES : NO;
}

- (BOOL)pd_eq:(NSString*)other
{
    return [self isEqualToString:other];
}

- (BOOL)pd_equal:(NSString*)other
{
    return [self isEqualToString:other];
}

- (BOOL)pd_is:(NSString*)other
{
    return [self isEqualToString:other];
}

- (BOOL)pd_isNot:(NSString*)other
{
    return NO == [self isEqualToString:other];
}

- (BOOL)pd_isValueOf:(NSArray*)array
{
    return [self pd_isValueOf:array caseInsens:NO];
}

- (BOOL)pd_isValueOf:(NSArray*)array caseInsens:(BOOL)caseInsens
{
    NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;

    for (NSObject* obj in array) {
        if (NO == [obj isKindOfClass:[NSString class]])
            continue;

        if ([(NSString*)obj compare:self options:option])
            return YES;
    }

    return NO;
}

- (NSString*)pd_URLEncoding
{
    //    CFStringRef aCFString = CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
    //                                                                    (CFStringRef)self,
    //                                                                    NULL,
    //                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
    //                                                                    kCFStringEncodingUTF8 );
    //    NSString * result = (NSString *)CFBridgingRelease(aCFString);
    //
    //    return result;
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (NSString*)pd_URLDecoding
{
    NSMutableString* string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return string.stringByRemovingPercentEncoding;
}

- (NSMutableDictionary*)pd_dictionaryFromQueryComponents
{
    NSMutableDictionary* queryComponents = [NSMutableDictionary dictionary];
    for (NSString* keyValuePairString in [self componentsSeparatedByString:@"&"]) {
        NSArray* keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2)
            continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString* key = [[keyValuePairArray objectAtIndex:0] pd_URLDecoding];
        NSString* value = [[keyValuePairArray objectAtIndex:1] pd_URLDecoding];
        NSMutableArray* results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
        if (!results) // First object
        {
            results = [NSMutableArray arrayWithCapacity:1];
            [queryComponents setObject:results forKey:key];
        }
        [results addObject:value];
    }
    return queryComponents;
}

- (NSString*)pd_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)pd_unwrap
{
    if (self.length >= 2) {
        if ([self hasPrefix:@"\""] && [self hasSuffix:@"\""]) {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }

        if ([self hasPrefix:@"'"] && [self hasSuffix:@"'"]) {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }

    return self;
}

- (NSString*)pd_repeat:(NSUInteger)count
{
    if (0 == count)
        return @"";

    NSMutableString* text = [NSMutableString string];

    for (NSUInteger i = 0; i < count; ++i) {
        [text appendString:self];
    }

    return text;
}

- (NSString*)pd_normalize
{
    return [self stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (BOOL)pd_isNormal
{
    NSString* regex = @"([^%&',;=!~?$]+)";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)pd_isUserName
{
    NSString* regex = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)pd_isChineseUserName
{
    NSString* regex = @"(^[A-Za-z0-9\u4e00-\u9fa5]{3,20}$)";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)pd_isPassword
{
    NSString* regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)pd_isEmail
{
    NSString* regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)pd_isURL
{
    NSString* regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:self];
}

- (BOOL)pd_isIPAddress
{
    NSArray* components = [self componentsSeparatedByString:@"."];
    NSCharacterSet* invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];

    if ([components count] == 4) {
        NSString* part1 = [components objectAtIndex:0];
        NSString* part2 = [components objectAtIndex:1];
        NSString* part3 = [components objectAtIndex:2];
        NSString* part4 = [components objectAtIndex:3];

        if ([part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound) {
            if ([part1 intValue] < 255 &&
                [part2 intValue] < 255 &&
                [part3 intValue] < 255 &&
                [part4 intValue] < 255) {
                return YES;
            }
        }
    }

    return NO;
}

- (BOOL)pd_isTelephone
{
    NSString* MOBILE = @"^1\\d{10}$";
    NSPredicate* regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    return [regex evaluateWithObject:self];
}

- (BOOL)pd_isHasCharacterAndNumber
{
    BOOL isExistDigit = [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
    BOOL isExistLetter = [self rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound;

    return isExistDigit && isExistLetter;
}
- (BOOL)pd_isNickname
{
    if (self == nil)
        return NO;

    NSString* regex = @"^[a-zA-Z0-9_\u4E00-\u9FFF-]{1,12}+$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];

    return isMatch;
}

- (NSString*)pd_substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet*)charset
{
    return [self pd_substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString*)pd_substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet*)charset endOffset:(NSUInteger*)endOffset
{
    if (0 == self.length)
        return nil;

    if (from >= self.length)
        return nil;

    NSRange range = NSMakeRange(from, self.length - from);
    NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];

    if (NSNotFound == range2.location) {
        if (endOffset) {
            *endOffset = range.location + range.length;
        }

        return [self substringWithRange:range];
    }
    else {
        if (endOffset) {
            *endOffset = range2.location + range2.length;
        }

        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

+ (NSString*)pd_fromResource:(NSString*)resName
{
    NSString* extension = [resName pathExtension];
    NSString* fullName = [resName substringToIndex:(resName.length - extension.length - 1)];

    NSString* path = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (BOOL)pd_match:(NSString*)expression
{
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    if (nil == regex)
        return NO;

    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, self.length)];
    if (0 == numberOfMatches)
        return NO;

    return YES;
}

- (BOOL)pd_matchAnyOf:(NSArray*)array
{
    for (NSString* str in array) {
        if (NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch]) {
            return YES;
        }
    }

    return NO;
}

- (NSInteger)pd_getLength
{
    NSInteger strLength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSInteger i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strLength++;
        }
        else {
            p++;
        }
    }
    return strLength;
}
- (NSInteger)pd_getLength2
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [self dataUsingEncoding:enc];
    return [data length];
}

- (NSString*)pd_replaceUnicode
{
    NSString* tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString* tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString* tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData* tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    //    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
    //                                                           mutabilityOption:NSPropertyListImmutable
    //                                                                     format:NULL
    //                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (void)pd_erasure
{
    char* string = (char*)CFStringGetCStringPtr((CFStringRef)self, CFStringGetSystemEncoding());
    memset(string, 0, [self length]);
}

- (NSString*)pd_stringByInitials
{
    NSMutableString* result = [NSMutableString string];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords | NSStringEnumerationLocalized usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingWordRange, BOOL* stop1) {
        __block NSString* firstLetter = nil;
        [self enumerateSubstringsInRange:NSMakeRange(0, word.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString* letter, NSRange letterRange, NSRange enclosingLetterRange, BOOL* stop2) {
            firstLetter = letter;
            *stop2 = YES;
        }];
        if (firstLetter != nil) {
            [result appendString:firstLetter];
        };
    }];
    return result;
}

- (CGSize)pd_calculateSize:(CGSize)size font:(UIFont*)font
{
    CGSize expectedLabelSize = CGSizeZero;

    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle.copy };

    expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

- (NSTimeInterval)pd_displayTime
{
    return MAX((float)self.length * 0.1 + 2, 2);
}

@end