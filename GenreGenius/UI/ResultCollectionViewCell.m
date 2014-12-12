//
//  ResultCollectionViewCell.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "ResultCollectionViewCell.h"
#import "FeedEntry.h"
#import "FeedDataProvider.h"

@interface ResultCollectionViewCell ()

@property (nonatomic, weak) NSURLSessionDataTask *task;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ResultCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;

    imageView.contentMode = UIViewContentModeScaleAspectFill;

    [self addSubview:imageView];
    self.imageView = imageView;

    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:views]];

    [self layoutIfNeeded];
}

- (void)prepareForReuse
{
    // If there is a task in progress and the cell will be reused, cancel it ready for the new feed entry.
    [self.task cancel];
}

- (void)dealloc
{
    // Before we're de-allocated, stop the fetch task if any since it is no longer needed.
    [self.task cancel];
}

- (void)displayFeedEntry:(FeedEntry *)feedEntry fromFeedDataProvider:(FeedDataProvider *)feedDataProvider
{
    // Pass a weak reference to self to the block so the cell is not retained by the pending `NSURLSessionDataTask`.
    __weak ResultCollectionViewCell *weakSelf = self;

    self.task = [feedDataProvider fetchImageForFeedEntry:feedEntry size:FeedEntryImageSizeLarge onCompletion:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong ResultCollectionViewCell *strongSelf = weakSelf;

            strongSelf.imageView.image = image;
        });
    }];
}

@end
