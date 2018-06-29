//
//  DetailsViewController.m
//  Flix
//
//  Created by Rucha Patki on 6/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    //backdrop label
    NSString *baseLowRes = @"https://image.tmdb.org/t/p/w45";
    NSString *baseHighRes = @"https://image.tmdb.org/t/p/original";
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    NSString *lowFull = [baseLowRes stringByAppendingString:backdropURLString];
    NSString *highFull = [baseHighRes stringByAppendingString:backdropURLString];
    
    NSURL *urlSmall = [NSURL URLWithString:lowFull];
    NSURL *urlLarge = [NSURL URLWithString:highFull];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    __weak DetailsViewController *weakSelf = self;
    
    [self.backdropView setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
        // smallImageResponse will be nil if the smallImage is already available
        // in cache (might want to do something smarter in that case).
        weakSelf.backdropView.alpha = 0.0;
        weakSelf.backdropView.image = smallImage;
                                       
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.backdropView.alpha = 1.0;
        } completion:^(BOOL finished) {
            // The AFNetworking ImageView Category only allows one request to be sent at a time
            // per ImageView. This code must be in the completion block.
            [weakSelf.backdropView setImageWithURLRequest:requestLarge
                                      placeholderImage:smallImage
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                        weakSelf.backdropView.image = largeImage;
                                      }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                                    }];
            }];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            // do something for the failure condition
            // possibly try to get the large image
    }];
    
    
    
    
    //title and synopsis labels
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    //scoll height
    CGFloat maxHeight = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height + 20;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    
    //gesture recognizer
    // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    
    // Optionally set the number of required taps, e.g., 2 for a double click
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
    [self.posterView setUserInteractionEnabled:YES];
    [self.posterView addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTap:(id)sender {
    // User tapped at the point above. Do something with that if you want.
    [self performSegueWithIdentifier:@"trailerSegue" sender:nil];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //passing over movie that was tapped to the destination view controller
    TrailerViewController *trailerVC = [segue destinationViewController];
    trailerVC.movie = self.movie;
}


@end
