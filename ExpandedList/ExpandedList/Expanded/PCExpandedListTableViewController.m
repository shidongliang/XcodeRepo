//
//  PCExpandedListTableViewController.m
//  ExpandedList
//
//  Created by MacBook Pro on 14-8-25.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import "PCExpandedListTableViewController.h"

@interface PCExpandedListTableViewController ()
@property (nonatomic,strong) NSDictionary *info;
@property (nonatomic,strong) NSMutableArray *headerViews;
@property (nonatomic,strong) NSArray *keys;
@end

@implementation PCExpandedListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _info = @{@"财政": @[@{@"name": @"大锤",@"duty":@"一把手"},@{@"name": @"二锤",@"duty":@"二把手"},@{@"name": @"大锤",@"duty":@"一把手"},@{@"name": @"大锤",@"duty":@"一把手"}],@"税务":@[@{@"name": @"木桩",@"duty":@"缴费"},@{@"name": @"大锤",@"duty":@"一把手"},@{@"name": @"大锤",@"duty":@"一把手"}]};
    _keys = [NSArray arrayWithArray:[_info allKeys]];
    _headerViews = [NSMutableArray new] ;
    for (int i = 0 ; i<[_keys count]; i++) {
        PCHeaderView *header = [[PCHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [header headerTitle:[_keys objectAtIndex:i] section:i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)];
        [header addGestureRecognizer:tap];
        [_headerViews addObject:header];
    }
    NSLog(@"%@",_headerViews);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapHeaderView:(UIGestureRecognizer*) tap
{
    PCHeaderView *header = (PCHeaderView *) [tap view];
    NSInteger index = [self.headerViews indexOfObject:header];
    header.isTapped = !header.isTapped;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"tap tap");
    NSLog(@"%@",[tap view]);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.headerViews count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *key = [self.keys objectAtIndex:section];
    PCHeaderView *header = [self.headerViews objectAtIndex:section];
    if (header.isTapped) {
        NSArray *values = [self.info objectForKey:key];
        return [values count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headerViews objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"PCTableViewCell";
    PCExpandedListTableViewCell *cell = [[PCExpandedListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    PCHeaderView *header = [self.headerViews objectAtIndex:indexPath.section];
    if (header.isTapped) {
        NSArray *values = [self.info objectForKey:key];
        [cell setUpCell:[values objectAtIndex:indexPath.row]];
    }
//    NSArray *values = [self.info objectForKey:key];
//    [cell setUpCell:[values objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
