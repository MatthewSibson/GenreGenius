//
// Created by Matthew Sibson on 12/9/14.
// Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const FeedEntryImageSizeSmall;
FOUNDATION_EXPORT NSString * const FeedEntryImageSizeMedium;
FOUNDATION_EXPORT NSString * const FeedEntryImageSizeLarge;

@interface FeedEntry : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *artist;

@property (nonatomic, strong) NSDictionary *images;

+ (instancetype)feedEntryWithDictionary:(NSDictionary *)dictionary;

/**
* Find URL for the image associated with the entry of a particular size.
*
* @param size One of `FeedEntryImageSizeSmall`, `FeedEntryImageSizeMediuml` or `FeedEntryImageSizeLarge`.
* @return `NSURL` URL to resource.
*/
- (NSURL *)URLForImageWithSize:(NSString *)size;

@end