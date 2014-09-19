//
//  UMBSettingsViewController.m
//  Umbrella
//
//  Created by Joe Sexton on 9/16/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBSettingsViewController.h"
#import "UMBWeatherManager.h"
#import "UMBSettingsManager.h"

@interface UMBSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UISegmentedControl *celsiusSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *fetchButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UMBWeatherManager *weatherManager;
@property (strong, nonatomic) UMBSettingsManager *settingsManager;

@end

@implementation UMBSettingsViewController

static NSInteger const kSettingsViewControllerFahrenheit = 0;
static NSInteger const kSettingsViewControllerCelsius    = 1;

#pragma mark - Getters/Setters

- (UMBWeatherManager *)weatherManager {
    
    if (!_weatherManager) {
        _weatherManager = [UMBWeatherManager sharedManager];
    }
    
    return _weatherManager;
}

- (UMBSettingsManager *)settingsManager {
    
    if (!_settingsManager) {
        _settingsManager = [[UMBSettingsManager alloc] init];
    }
    
    return _settingsManager;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setup];
}

// Set labels and reset values to defaults.
- (void)setup {
    
    self.searchBar.placeholder = NSLocalizedString(@"Enter Zip Code", @"Enter Zip Code");
    self.searchBar.barTintColor = [UIColor lightGrayColor];
    self.searchBar.text = @"";
    self.searchBar.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.celsiusSegmentedControl setTitle:NSLocalizedString(@"Fahrenheit", @"Fahrenheit") forSegmentAtIndex:kSettingsViewControllerFahrenheit];
    [self.celsiusSegmentedControl setTitle:NSLocalizedString(@"Celsius", @"Celsius") forSegmentAtIndex:kSettingsViewControllerCelsius];
    self.celsiusSegmentedControl.selectedSegmentIndex = (self.settingsManager.celsius) ? kSettingsViewControllerCelsius : kSettingsViewControllerFahrenheit;
    
    [self.fetchButton setTitle:NSLocalizedString(@"Get the Weather", @"Get the Weather") forState:UIControlStateNormal];
    
    // If a tint color has been set then use it to highlight controls
    if (self.tintColor) {
        
        NSDictionary *attributes = @{NSForegroundColorAttributeName: self.tintColor};
        
        [self.celsiusSegmentedControl setTintColor:self.tintColor];
        [self.celsiusSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        self.fetchButton.tintColor = self.tintColor;
    }
    
}

#pragma mark - Actions

- (IBAction)fetchButtonPressed:(id)sender {
    
    // Basic search input validation
    if ([self.searchBar.text isEqualToString:@""]) {
        
        self.searchBar.barTintColor = [UIColor redColor];
        
        return;
        
    } else {
        
        self.searchBar.barTintColor = [UIColor lightGrayColor];
    }
    
    // Update settings
    self.settingsManager.zipCode = self.searchBar.text;
    self.settingsManager.celsius = self.celsiusSegmentedControl.selectedSegmentIndex == kSettingsViewControllerCelsius;
    
    // Perform a fetch
    [self.weatherManager fetchForecastForZipCode:self.searchBar.text];
    
    // Hide
    if ([self.parentViewController respondsToSelector:@selector(hideSettings)]) {
        [self.parentViewController performSelector:@selector(hideSettings)];
    }
}

@end
