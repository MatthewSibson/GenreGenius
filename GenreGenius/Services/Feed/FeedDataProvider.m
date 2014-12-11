//
//  FeedDataProvider.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "FeedDataProvider.h"
#import "FeedData.h"
#import "FeedEntry.h"

@interface FeedDataProvider ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation FeedDataProvider

- (instancetype)init
{
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }

    return self;
}

#pragma mark - Fetches

- (void)fetchTopAlbumsLimit:(NSUInteger)limit onCompletion:(FeedDataProviderResult)block
{
    [self fetchTopAlbumsFromGenre:GenreAll limit:limit onCompletion:block];
}

- (void)fetchTopAlbumsFromGenre:(Genre)genre limit:(NSUInteger)limit onCompletion:(FeedDataProviderResult)block
{
    NSParameterAssert(block);

    NSURL *URL = [self URLForTopAlbumsInGenre:genre limit:limit];

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *sessionError) {
        if (nil == sessionError) {
            NSError *serializationError;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];

            if (nil == serializationError) {
                FeedData *feedData = [FeedData feedDataWithDictionary:dictionary];

                block(feedData, nil);
            } else {
                block(nil, serializationError);
            }
        } else {
            block(nil, sessionError);
        }
    }];

    [task resume];
}

- (void)fetchImageForFeedEntry:(FeedEntry *)feedEntry size:(NSString *)size onCompletion:(void (^)(UIImage *image, NSError *error))block
{
    NSParameterAssert(block);

    NSURL *URL = [feedEntry URLForImageWithSize:size];

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (nil == error) {
            UIImage *image = [UIImage imageWithData:data];

            block(image, nil);
        } else {
            block(nil, error);
        }
    }];

    [task resume];
}

#pragma mark - Helpers

/**
* Build URL for top albums in a given genre with a limit on returned results.
*
* @param genre A genre specified by the `Genre` enumeration.
* @param limit `NSUInteger` maximum number of results to request.
*
* @return `NSURL` for specified feed.
*/
- (NSURL *)URLForTopAlbumsInGenre:(Genre)genre limit:(NSUInteger)limit
{
    // Hard code to US top albums for now.
    NSMutableString *path = [@"/us/rss/topalbums" mutableCopy];

    // Limit the results given back to a fixed number.
    [path appendFormat:@"/limit=%lu", (unsigned long)limit];

    // Leaving out the genre predicate returns overall summary for all genres.
    if (genre != GenreAll) {
        [path appendFormat:@"/genre=%lu", (unsigned long)genre];
    }

    // JSON format please.
    [path appendFormat:@"/json"];

    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
}

@end
