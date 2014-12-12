//
//  ResultsViewController.m
//  GenreGenius
//
//  Created by Matthew Sibson on 12/11/14.
//  Copyright (c) 2014 Matthew Sibson. All rights reserved.
//

#import "ResultsViewController.h"
#import "FeedDataProvider.h"
#import "ResultCollectionViewCell.h"
#import "FeedData.h"
#import "FeedEntry.h"

@interface ResultsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) FeedDataProvider *feedDataProvider;
@property (nonatomic, assign) Genre displayedGenre;
@property (nonatomic, strong) NSArray *feedEntries;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Tell collection view to use our custom cell subclass for creating cells.
    [self.collectionView registerClass:[ResultCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    // Start a fetch of albums related to the requested genre, that was set before we appeared.
    [self fetchAlbumsFromGenre:self.displayedGenre];
}

- (void)displayResultsForGenre:(Genre)genre
{
    // View will never be loaded in this app when this is set, so store it for pick up later.
    self.displayedGenre = genre;
}

#pragma mark - Data Feed

- (FeedDataProvider *)feedDataProvider
{
    if (nil == _feedDataProvider) {
        _feedDataProvider = [[FeedDataProvider alloc] init];
    }

    return _feedDataProvider;
}

- (void)fetchAlbumsFromGenre:(Genre)genre
{
    [self.feedDataProvider fetchTopAlbumsFromGenre:genre limit:15 onCompletion:^(FeedData *feedData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nil != error) {
                NSLog(@"ERROR: %@", error.localizedDescription);
            } else {
                self.feedEntries = feedData.entries;

                [self.collectionView reloadData];
            }
        });
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.feedEntries count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    [cell displayFeedEntry:self.feedEntries[(NSUInteger)indexPath.item] fromFeedDataProvider:self.feedDataProvider];

    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeedEntry *feedEntry = self.feedEntries[(NSUInteger)indexPath.item];



#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"iTunes Store is not supported on the iOS simulator." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
#else
    [[UIApplication sharedApplication] openURL:feedEntry.link];
#endif
}

@end