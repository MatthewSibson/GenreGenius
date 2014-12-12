//
//  SearchService.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/10/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "SearchService.h"

@interface SearchService ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SearchService

- (instancetype)init
{
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }

    return self;
}

- (void)searchGenreForTerm:(NSString *)term onCompletion:(void (^)(Genre genre, NSError *error))block
{
    NSParameterAssert(block);

    // Build URL with only one result to return, we're depending on the search API to give back the most
    // relevant result for the search term. Better results could be sought later by analysing more results.
    NSURL *URL = [self URLForSearchTerm:term limit:1];

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *sessionError) {
        if (nil == sessionError) {
            NSError *serializationError;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];

            if (nil == serializationError) {
                // As there is only one result, pull last object from the array which would be the one and only
                // result. If there are no results, last object will be nil and sending objectForKey: to nil will
                // still be nil.
                NSNumber *genreId = [dictionary[@"results"] lastObject][@"primaryGenreId"];

                if (nil == genreId) {
                    // If the genreId was nil, either there were no results or a primaryGenreId was not specified
                    // for the result. Either way we'll treat this as an unknown or invalid genre.
                    block(GenreInvalid, nil);
                } else {
                    // Otherwise a genre was found, unpack the value from the NSNumber and cast to the Genre type.
                    block((Genre)[genreId integerValue], nil);
                }
            } else {
                // Deserialization failed, so pass the error back together with an invalid genre.
                block(GenreInvalid, serializationError);
            }
        } else {
            // Some error occurred fetching the data, so pass the error back together with an invalid genre.
            block(GenreInvalid, sessionError);
        }
    }];

    [task resume];
}

#pragma mark - Helpers

/**
* Build URL for searching iTunes for a particular term.
*
* @param term `NSString` search term.
* @param limit `NSUInteger` maximum number of results to request.
*
* @return `NSURL` for specified feed.
*/
- (NSURL *)URLForSearchTerm:(NSString *)term limit:(NSUInteger)limit
{
    // Hard code to iTunes search for now.
    NSMutableString *path = [@"/search?media=music&entity=musicArtist" mutableCopy];

    // Add search term parameter.
    [path appendFormat:@"&term=%@", [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    // Limit the results given back to a fixed number.
    [path appendFormat:@"&limit=%lu", (unsigned long)limit];

    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
}

@end
