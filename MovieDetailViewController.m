//
//  MovieDetailViewController.m
//  RottenTomatoes
//
//  Created by Miles Spielberg on 2/3/15.
//  Copyright (c) 2015 OrionNet. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AnimationUtils.h"
#import "UIImage+SVG.h"
#import "UIImage+Crop.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *largePosterView;

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIView *backdropView;
@property (nonatomic) CGFloat originalBackdropAlpha;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *freshnessImage;
@property (weak, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *runtimeImage;
@property (weak, nonatomic) IBOutlet UILabel *mpaaRatingLabel;

@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.originalBackdropAlpha = self.backdropView.alpha;
    
    self.title = self.movie[@"title"];
    self.titleLabel.text = self.title;
    
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.movie[@"year"] longValue]];
    self.criticScoreLabel.text = [NSString stringWithFormat:@"%ld%%", (long)[[self.movie valueForKeyPath:@"ratings.critics_score"] longValue]];
    NSLog(@"criticsScore = %@", self.criticScoreLabel.text);
    self.freshnessImage.image = [MovieDetailViewController freshnessImageFor:self.movie];
    
    [self.runtimeImage setImage:[UIImage imageWithSVGNamed:@"clock" targetSize:CGSizeMake(16.0, 16.0) fillColor:[UIColor whiteColor]]];
    self.runtimeLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.movie[@"runtime"] integerValue]];
    
    self.mpaaRatingLabel.text = [NSString stringWithFormat:@"%@", self.movie[@"mpaa_rating"]];
    
//    [self.mpaaRatingLabel sizeToFit];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    [self.synopsisLabel sizeToFit];
    
    long infoHeight = self.synopsisLabel.frame.size.height + self.synopsisLabel.frame.origin.y + 10;
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, self.infoView.frame.origin.y, self.infoView.frame.size.width, infoHeight);
//    self.backdropView.frame = self.infoView.frame;
    long totalHeight = self.infoView.frame.origin.y + infoHeight;
    self.detailScrollView.contentSize = CGSizeMake(self.detailScrollView.contentSize.width, totalHeight);
    
    NSString *rawUrl = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSURL *posterUrl = [NSURL URLWithString:[rawUrl stringByReplacingOccurrencesOfString:@"_tmb" withString:@"_ori"]];
    
    [self.largePosterView setImageWithURL:posterUrl placeholderImage:self.thumbnail duration:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)posterWasTapped:(id)sender {
    if (self.infoView.alpha > 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.infoView.alpha = 0.0;
            self.backdropView.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.infoView.alpha = 1.0;
            self.backdropView.alpha = self.originalBackdropAlpha;
        }];
    }
}

+ (UIImage *)freshnessImageFor:(NSDictionary *)movie {
    UIImage *iconSheet = [UIImage imageNamed:@"icons-v2.png"];
    UIImage *freshIcon = [iconSheet crop:CGRectMake(288.0, 48.0, 24.0, 24.0)];
    UIImage *certifiedIcon = [iconSheet crop:CGRectMake(288.0, 72.0, 24.0, 24.0)];
    UIImage *rottenIcon = [iconSheet crop:CGRectMake(288.0, 96.0, 24.0, 24.0)];
    NSDictionary *mapping = @{
                              @"Certified Fresh": certifiedIcon,
                              @"Fresh": freshIcon,
                              @"Rotten": rottenIcon
                              };
    return mapping[[movie valueForKeyPath:@"ratings.critics_rating"]];
}

@end
