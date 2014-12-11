//
//  FeedData.h
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedData : NSObject

@property (nonatomic, strong) NSArray *entries;

+ (instancetype)feedDataWithDictionary:(NSDictionary *)dictionary;

@end
