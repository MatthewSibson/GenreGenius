//
//  ViewController.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/9/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "ViewController.h"
#import "FeedDataProvider.h"
#import "FeedData.h"
#import "FeedEntry.h"

@interface ViewController ()

@property (nonatomic, strong) FeedDataProvider *feedDataProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self fetchDataFeed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Feed

- (FeedDataProvider *)feedDataProvider
{
    if (nil == _feedDataProvider) {
        _feedDataProvider = [[FeedDataProvider alloc] init];
    }

    return _feedDataProvider;
}

- (void)fetchDataFeed
{
    [self.feedDataProvider fetchTopAlbumsFromGenre:GenreGermanFolk limit:15 onCompletion:^(FeedData *feedData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != error) {
                NSLog(@"ERROR: %@", error.localizedDescription);
            } else {
                for (FeedEntry *feedEntry in feedData.entries) {
                    [self fetchAndDisplayImageForFeedEntry:feedEntry];
                }
            }
        });
    }];
}

- (void)fetchAndDisplayImageForFeedEntry:(FeedEntry *)feedEntry
{
    [self.feedDataProvider fetchImageForFeedEntry:feedEntry size:FeedEntryImageSizeMedium onCompletion:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != error) {
                NSLog(@"ERROR: %@", error.localizedDescription);
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

                imageView.center = CGPointMake(
                        arc4random_uniform((u_int32_t)CGRectGetWidth(self.view.bounds)),
                        arc4random_uniform((u_int32_t)CGRectGetHeight(self.view.bounds))
                );

                [self.view addSubview:imageView];
            }
        });
    }];
}

@end
