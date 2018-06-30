//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Rucha Patki on 6/28/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar.heightAnchor constraintEqualToConstant:44].active = YES;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    self.searchBar.delegate = self;
    self.filteredData = self.movies;
    
    //set refresh control at the top of the screen
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
    //collection view layout, spacing
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing*(postersPerLine - 1))/postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //change back arrow and title to white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/15359/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //this part runs when network call is finished
        if (error != nil) {
            //creating alert if networking error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create try again action
            UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle tryAgain response here. Doing nothing will dismiss the view.
                [self fetchMovies];
            }];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            // add the tryAgain action to the alertController
            [alert addAction:tryAgainAction];
            
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
            [self.collectionView reloadData];
            // Stop the activity indicator
            // Hides automatically since "Hides When Stopped" is enabled
            [self.activityIndicator stopAnimating];
        }
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    //passing over movie that was tapped to the destination view controller
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *url = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //images fade in as they are loading
    __weak MovieCollectionCell *weakSelf = cell;
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        if (imageResponse) {
                                            //image not cached: fade in
                                            weakSelf.posterView.alpha = 0.0;
                                            weakSelf.posterView.image = image;
                                            
                                            //Animate UIImageView back to alpha 1 over 0.3sec
                                            [UIView animateWithDuration:0.3 animations:^{
                                                weakSelf.posterView.alpha = 1.0;
                                            }];
                                        }
                                        else {
                                            //image cached: just update
                                            weakSelf.posterView.image = image;
                                        }
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0) {
        //predicate function returns true if the movie title contains the text in the searchbar
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            return [item[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.collectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //if cancel clicked, then acts as if all text deleted
    self.filteredData = self.movies;
    [self.collectionView reloadData];
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


@end
