//
//  UMBMainViewController.m
//  Umbrella
//
//  Created by {{YOUR_NAME_HERE}} on 9/12/12.
//  Copyright (c) 2013 {{YOUR_NAME_HERE}}. All rights reserved.
//

#import "NSDate+Extension.h"
#import "UIImage+ImageEffects.h"
#import "UMBMainViewController.h"
#import "UMBWeatherManager.h"
#import "UMBGradientView.h"
#import "UMBNoResultsView.h"
#import "UMBCurrentConditionsView.h"
#import "UMBForecastCollectionViewCell.h"
#import "UMBSettingsManager.h"
#import "UMBSettingsViewController.h"

@interface UMBMainViewController ()

@property (strong, nonatomic) UMBWeatherManager *weatherManager;
@property (weak, nonatomic) IBOutlet UMBCurrentConditionsView *currentConditionsView;
@property (strong, nonatomic) UMBNoResultsView *noResultsView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *daySegmentedControlContainerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daySegmentedControl;
@property (strong, nonatomic) UMBSettingsManager *settingsManager;
@property (strong, nonatomic) UIImageView *blurView;
@property (strong, nonatomic) UMBSettingsViewController *settingsViewController;
@property BOOL viewLoaded;

@end

@implementation UMBMainViewController

static NSInteger const kMainViewControllerTemperatureCutoff = 60;
static NSInteger const kMainViewControllerToday             = 0;
static NSInteger const kMainViewControllerTomorrow          = 1;

#pragma mark - Getters/Setters

- (UMBWeatherManager *)weatherManager {
    
    if (!_weatherManager) {
        _weatherManager = [UMBWeatherManager sharedManager];
        _weatherManager.delegate = self;
    }
    
    return _weatherManager;
}

- (UMBSettingsManager *)settingsManager {
    
    if (!_settingsManager) {
        _settingsManager = [[UMBSettingsManager alloc] init];
    }
    
    return _settingsManager;
}

- (UMBSettingsViewController *)settingsViewController {
    
    if (!_settingsViewController) {
        _settingsViewController = [UMBSettingsViewController new];
    }
    
    return _settingsViewController;
}

- (UMBNoResultsView *)noResultsView {
    
    if (!_noResultsView) {
        
        CGFloat top = self.currentConditionsView.frame.origin.y + self.currentConditionsView.frame.size.height;
        CGFloat height = self.view.bounds.size.height - top;
        _noResultsView = [[UMBNoResultsView alloc] initWithFrame:CGRectMake(0, top, self.view.bounds.size.width, height)];
    }
    
    return _noResultsView;
}

- (UIImageView *)blurView {
    
    if (!_blurView) {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(c, 0, 0);
        [self.view.layer renderInContext:c];
        
        UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
        viewImage = [viewImage applyLightEffect];
        
        UIGraphicsEndImageContext();
        
        _blurView = [[UIImageView alloc] initWithImage:viewImage highlightedImage:nil];
    }
    
    return _blurView;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Fetch forecasts if no fetch started
    if (!self.weatherManager.lastFetch) {
        [self.weatherManager fetchForecastForZipCode:self.settingsManager.zipCode];
    }
    
    // Init collection view
    [self.collectionView registerNib:[UINib nibWithNibName:@"UMBForecastCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UMBForecastCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flow =  (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    
    // Init segmented control
    [self.daySegmentedControl setTitle:NSLocalizedString(@"Today", @"Today") forSegmentAtIndex:kMainViewControllerToday];
    [self.daySegmentedControl setTitle:NSLocalizedString(@"Tomorrow", @"Tomorrow") forSegmentAtIndex:kMainViewControllerTomorrow];
    
    self.viewLoaded = YES;
    
    [self updateUI];
}

#pragma mark - Segmented Control

- (IBAction)daySegmentedControlChanged:(UISegmentedControl *)sender {
    
    NSString *day;
    
    day = ((UISegmentedControl *)sender).selectedSegmentIndex == kMainViewControllerToday ? @"Today" : @"Tomorrow";
    
    [self updateUI];
}

#pragma mark - UMBWeatherManagerDelegate

- (void)forecastsUpdated:(NSArray *)forecasts {
    
    if (self.viewLoaded) {
        [self updateUI];
    }
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 80);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *forecasts = [self getForecasts];
    
    return [forecasts count];
}

- (UMBForecastCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UMBForecastCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UMBForecastCollectionViewCell" forIndexPath:indexPath];
    
    UMBForecast *forecast = [[self getForecasts] objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h a"];
    
    cell.topText    = [formatter stringFromDate:forecast.date];
    cell.bottomText = [self getTemperatureForForecast:forecast];
    cell.icon       = forecast.icon;
    
    // Highest temp for day is warm gradient, lowest is cool gradient
    // all others have no gradient
    if ([self forecastIsHighTemp:forecast]) {
        cell.gradient = GradientViewWarmGradient;
    } else if ([self forecastIsLowTemp:forecast]) {
        cell.gradient = GradientViewCoolGradient;
    } else {
        cell.gradient = GradientViewNoGradient;
    }
    
    return cell;
}

#pragma mark - Settings

- (IBAction)settingButtonPressed:(UIButton *)sender {
    
    [self showSettings];
}

- (void)handleBlurTap:(UITapGestureRecognizer *)recognizer {
    
    [self hideSettings];
}


- (UITapGestureRecognizer *)getBlurTapGestureRecognizer {
    
    return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBlurTap:)];
}

- (void)showSettings {
    
    self.blurView.alpha = 0.0;
    [self.view addSubview:self.blurView];
    
    [UIView animateWithDuration:1.0 delay:0 options:nil animations:^{
        self.blurView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSettingsViewController) userInfo:nil repeats:NO];
    }];
    
    [self.view addGestureRecognizer:[self getBlurTapGestureRecognizer]];
}

- (void)hideSettings {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self hideSettingsViewController];
    
    [UIView animateWithDuration:1.0 delay:0 options:nil animations:^{
        self.blurView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
        self.blurView = nil; // regenerate blur image next time it's needed
    }];
    
    [self.view removeGestureRecognizer:[self getBlurTapGestureRecognizer]];
}

- (void)showSettingsViewController {
    
    self.settingsViewController.view.frame = CGRectMake(0, 30, self.settingsViewController.view.frame.size.width, self.settingsViewController.view.frame.size.height);
    
    // Settings tint colors are opposite this view controllers.
    if (self.weatherManager.currentConditions && self.weatherManager.currentConditions.temperatureF < kMainViewControllerTemperatureCutoff) {
        self.settingsViewController.tintColor = self.currentConditionsView.warmGradientTopColor;
    } else {
        
        self.settingsViewController.tintColor = self.currentConditionsView.coolGradientTopColor;
    }
    
    [self addChildViewController:self.settingsViewController];
    [self.view addSubview:self.settingsViewController.view];
    [self.settingsViewController didMoveToParentViewController:self];
}

- (void)hideSettingsViewController {
    
    [self.settingsViewController willMoveToParentViewController:nil];
    [self.settingsViewController.view removeFromSuperview];
    [self.settingsViewController removeFromParentViewController];
}

#pragma mark - Update UI

- (void)updateUI {
    
    if (!self.viewLoaded) {
        return;
    }
    
    // Reload collection view
    if (self.collectionView) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:nil];
    }
    
    // Set UI elements and colors
    UIColor *tintColor = [self.currentConditionsView neutralGradientTopColor];

    if (self.weatherManager.currentConditions) {
        
        // Hide no results view
        [self showNoResultsView:NO];
        
        UMBForecast *currentConditions = [self.weatherManager currentConditions];
        
        if (currentConditions.city && currentConditions.state) {
            self.title = [NSString stringWithFormat:@"%@, %@", currentConditions.city, currentConditions.state];
        }
        
        self.currentConditionsView.temperature = [self getTemperatureForForecast:currentConditions];
        self.currentConditionsView.condition   = currentConditions.condition;
        self.currentConditionsView.gradient    = currentConditions.temperatureF < kMainViewControllerTemperatureCutoff ? GradientViewCoolGradient : GradientViewWarmGradient;
        
        tintColor = currentConditions.temperatureF < kMainViewControllerTemperatureCutoff ? [self.currentConditionsView coolGradientTopColor] : [self.currentConditionsView warmGradientTopColor];
        
    } else {
        
        // Init to no forecast defaults
        self.title = @"";
        self.currentConditionsView.temperature = @"";
        self.currentConditionsView.condition   = @"";
        self.currentConditionsView.gradient    = GradientViewWarmGradient;
        
         tintColor = [self.currentConditionsView warmGradientTopColor];
        
        [self showNoResultsView:YES];
    }
    

    NSDictionary *attributes = @{NSForegroundColorAttributeName: tintColor};

    [self.daySegmentedControl setTintColor:tintColor];
    [self.daySegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)showNoResultsView:(BOOL)showNoResults {
    
    self.collectionView.hidden                   = showNoResults;
    self.daySegmentedControlContainerView.hidden = showNoResults;
    
    if (showNoResults) {
        self.noResultsView.messageLabel.text = NSLocalizedString(@"No weather data found", @"No weather data found");
        [self.view addSubview:self.noResultsView ];
    } else {
        [self.noResultsView removeFromSuperview];
        self.noResultsView = nil;
    }
}

#pragma mark - Forecast Utility

- (BOOL)showTodayForecasts {
    
    return self.daySegmentedControl.selectedSegmentIndex == kMainViewControllerToday;
}

- (NSArray *)getForecasts {
    
    NSArray *forecasts;
    
    if ([self showTodayForecasts]) {
        
        forecasts = [self.weatherManager getForecastsForDate:[NSDate date]];
        
    } else {
        
        forecasts = [self.weatherManager getForecastsForDate:[NSDate tomorrow]];
    }
    
    return forecasts;
}

- (BOOL)forecastIsHighTemp:(UMBForecast *)forecast {
    
    UMBForecast *highForecast = [self getHighForecast];
    
    return forecast == highForecast;
}

- (UMBForecast *)getHighForecast {
    
    UMBForecast *highForecast;
    
    NSArray *forecasts = [self getForecasts];
    
    for (UMBForecast *forecast in forecasts) {
        if (!highForecast || forecast.temperatureF > highForecast.temperatureF) {
            highForecast = forecast;
        }
    }
    
    return highForecast;
}

- (BOOL)forecastIsLowTemp:(UMBForecast *)forecast {
    
    UMBForecast *lowForecast = [self getLowForecast];
    
    return forecast == lowForecast;
}

- (UMBForecast *)getLowForecast {
    
    UMBForecast *lowForecast;
    
    NSArray *forecasts = [self getForecasts];
    
    for (UMBForecast *forecast in forecasts) {
        if (!lowForecast || forecast.temperatureF < lowForecast.temperatureF) {
            lowForecast = forecast;
        }
    }
    
    return lowForecast;
}

- (NSString *)getTemperatureForForecast:(UMBForecast *)forecast {
    
    NSInteger temp = [self.settingsManager celsius] ? forecast.temperatureC : forecast.temperatureF;
    return [NSString stringWithFormat:@"%d°", temp];
}

@end
