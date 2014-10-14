//
//  DetailStopViewController.m
//  GetOnThatBus
//
//  Created by Eduardo Alvarado Díaz on 10/14/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "DetailStopViewController.h"

@interface DetailStopViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *routesLabel;
@property (strong, nonatomic) IBOutlet UILabel *intermodalLabel;

@end

@implementation DetailStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.busStop objectForKey:@"cta_stop_name"];
    self.addressLabel.text = [self.busStop objectForKey:@"_address"];
    self.routesLabel.text = [self.busStop objectForKey:@"routes"];

    NSString *inter = [self.busStop objectForKey:@"inter_modal"];
    if (inter != nil) {
        if ([inter isEqualToString:@"Metra"]) {
            self.intermodalLabel.text = @"Metra commuter rail line";
        }else{
            self.intermodalLabel.text = @"Suburban Pace bus system";
        }
    }else{
        self.intermodalLabel.text = @"";
    }
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

@end
