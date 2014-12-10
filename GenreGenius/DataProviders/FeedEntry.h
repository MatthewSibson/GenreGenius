//
// Created by Matthew Sibson on 12/9/14.
// Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedEntry : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *artist;

@property (nonatomic, strong) NSDictionary *images;

+ (instancetype)feedEntryWithDictionary:(NSDictionary *)dictionary;

@end