//
//  ViewController.m
//  TableTest
//
//  Created by Steve Riggins on 10/31/14.
//  Copyright (c) 2014 Walmart. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSUInteger, ViewControllerSection)
{
    ViewControllerSectionSearch = 0,
    ViewControllerSectionInStore,
    ViewControllerSectionMerchandise,
    ViewControllerSectionShop,
    ViewControllerSectionSaver,
    ViewControllerSectionPharmacy,
    ViewControllerSectionCount
};

static NSString *ViewControllerCellIdentifier = @"ViewControllerCellIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) NSTimer *reloadDataTimer;
@property (nonatomic, strong) NSMutableDictionary *colors;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ViewControllerCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(refreshTick) userInfo:nil repeats:YES];
    self.reloadDataTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadTick) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath
{
    if (!self.colors)
    {
        self.colors = [NSMutableDictionary dictionary];
    }
    
    UIColor *color;
    NSString *key = [NSString stringWithFormat:@"Section %td Row %td", indexPath.section, indexPath.row];
    color = self.colors[key];
    if (!color)
    {
        NSUInteger red = arc4random() % 256;
        NSUInteger green = arc4random() % 256;
        NSUInteger blue = arc4random() % 256;
        color = [UIColor colorWithRed:red / 256.0 green:green / 256.0 blue: blue / 256.0 alpha:1.0];
        self.colors[key] = color;
    }
    return color;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section)
    {
        case ViewControllerSectionInStore:
            rows = 1 + (arc4random() % 4);
            break;
        default:
            rows = 1;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ViewControllerCellIdentifier];

    NSString *text = [NSString stringWithFormat:@"Section %td Row %td", indexPath.section, indexPath.row];
    cell.textLabel.text = text;
    
    UIColor *color = [self colorForIndexPath:indexPath];
    cell.backgroundColor = color;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    switch (indexPath.section)
    {
        case ViewControllerSectionMerchandise:
            height = 170;
            break;
        case ViewControllerSectionInStore:
        {
            switch (indexPath.row)
            {
                case 0:
                    height = 44;
                    break;
                default:
                    height = 80;
                    break;
            }
            break;
        }
        default:
            height = 80;
            break;
    }
    return height;
  
}

- (void)refreshTick
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)reloadTick
{
    [self.tableView reloadData];
}


@end
