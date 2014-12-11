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

@property (nonatomic, weak) IBOutlet UIView *emitterContainer;
@property (nonatomic, weak) CAEmitterLayer *emitterLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create emitter layer for album star field.
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];

    // Position emitter layer in middle of container as a point source set back from the viewer in Z.
    emitterLayer.position = CGPointMake(CGRectGetMidX(self.emitterContainer.bounds), CGRectGetMidY(self.emitterContainer.bounds));
    emitterLayer.emitterMode = kCAEmitterLayerPoint;
    emitterLayer.emitterShape = kCAEmitterLayerPoint;
    emitterLayer.emitterZPosition = -100.0f;

    // Add emitter layer to the container. The container ensures that the emitter will
    // stay centered on the screen by taking advantage of autolayout.
    [self.emitterContainer.layer addSublayer:emitterLayer];
    self.emitterLayer = emitterLayer;

    // Set the perspective of the top layer so moving in Z affects the apparent scale of the sublayers.
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0f / 200.0f;
    self.view.layer.sublayerTransform = perspective;

    // Kick off fetch of data feed.
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
    [self.feedDataProvider fetchTopAlbumsFromGenre:GenreAll limit:15 onCompletion:^(FeedData *feedData, NSError *error) {
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
                CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
                emitterCell.contents = (__bridge id)image.CGImage;

                emitterCell.emissionRange = (CGFloat)(2.0 * M_PI);
                emitterCell.birthRate = 1.0f;
                emitterCell.lifetime = 3.0f;
                emitterCell.lifetimeRange = 0.5f;

                emitterCell.velocity = 100.0f;

                // Cells should accelerate towards the viewer.
                emitterCell.zAcceleration = 1.0f;

                // Cells should gradually fade to black while moving nearer.
                emitterCell.blueSpeed = -0.3f;
                emitterCell.redSpeed = -0.3f;
                emitterCell.greenSpeed = -0.3f;

                // If this is the first cell create new array otherwise append to existing cells.
                if (nil == self.emitterLayer.emitterCells) {
                    self.emitterLayer.emitterCells = @[ emitterCell ];
                } else {
                    NSArray *emitterCells = self.emitterLayer.emitterCells;
                    self.emitterLayer.emitterCells = [emitterCells arrayByAddingObject:emitterCell];
                }
            }
        });
    }];
}

@end
