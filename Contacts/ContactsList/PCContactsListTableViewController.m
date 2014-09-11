//
//  PCContactsListTableViewController.m
//  Contacts
//
//  Created by MacBook Pro on 14-8-25.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import "PCContactsListTableViewController.h"

@interface PCContactsListTableViewController ()
@property (nonatomic,strong) NSDictionary * orderedDic;//汉子按拼音归类的字典
@property (nonatomic,strong) NSArray *orderedKeys;//字典里keys的排序后数组
//@property (nonatomic,strong) NSMutableArray *sections; //这个变量暂时无用
@property (nonatomic,strong) NSMutableArray *listContent;//按照字母表对应下标存储的数组
@end

@implementation PCContactsListTableViewController

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
    
    _contacts = @[@{@"name":@"阿迷",@"phoneNumber":@"1"},@{@"name": @"阿弥陀佛",@"phoneNumber":@"2"},@{@"name":@"观音菩萨",@"phoneNumber":@"3"},@{@"name":@"达摩",@"phoneNumber":@"4"},@{@"name":@"大",@"phoneNumber":@"4"},@{@"name":@"摩 ",@"phoneNumber":@"4"},@{@"name":@"观音",@"phoneNumber":@"3"},@{@"name":@"菩萨",@"phoneNumber":@"3"},@{@"name":@"观萨",@"phoneNumber":@"3"},@{@"name":@"音菩",@"phoneNumber":@"3"},@{@"name":@"音萨",@"phoneNumber":@"3"}];
    
    self.orderedDic = [self sortContacts:_contacts];
    //    NSLog(@"%@",self.orderedDic);
    self.orderedKeys = [[self.orderedDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    //    NSLog(@"%@",self.orderedKeys);
    
//    self.sections = [NSMutableArray new];
    self.listContent = [NSMutableArray new];
#pragma mark UILocalizedIndexedCollation 这是ios自带的排序工具，汉子排序不支持拼音排序
    UILocalizedIndexedCollation *theColation = [UILocalizedIndexedCollation currentCollation];
//    for (NSString *key in [self.orderedDic allKeys]) {
//        NSInteger section = [theColation sectionForObject:key collationStringSelector:@selector(uppercaseString)];
//        //        NSLog(@"theColation section %d",section);
////        [self.sections addObject:[NSString stringWithFormat:@"%d",section]];
//    }
    
    NSInteger highSection = [[theColation sectionTitles] count];
    
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (NSString *key in self.orderedKeys) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:[theColation sectionForObject:key collationStringSelector:@selector(uppercaseString)]] addObject:key];
    }
//    NSLog(@"sectionArrays %@",sectionArrays);
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theColation sortedArrayFromArray:sectionArray collationStringSelector:@selector(uppercaseString)];
//        NSLog(@"%@",sortedSection);
        [self.listContent addObject:sortedSection];
        //        [_listContent addObject:sortedSection];
    }
    
    NSLog(@"listContent = %@",self.listContent);
}

- (NSDictionary* )sortContacts:(NSArray *)contacts
{
#warning 汉子转拼音并且分组的方法
    NSMutableDictionary *sortedDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in contacts) {
        char c;
        c = [ChineseToPinyin sortSectionTitle:[dic objectForKey:@"name"]];
        NSString *alphabet = [NSString stringWithFormat:@"%c",c];
        if([[sortedDic allKeys] containsObject:alphabet])
        {
            [[sortedDic valueForKey:alphabet] addObject:dic];
        }else
        {
            NSMutableArray *sortedArray = [NSMutableArray array];
            [sortedArray addObject:dic];
            [sortedDic setObject:sortedArray forKey:alphabet];
        }
    }
    
    return (NSDictionary *) sortedDic;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger count = [[self.listContent objectAtIndex:section] count];
    if (1 == count) {
        return [[self.listContent objectAtIndex:section] objectAtIndex:0];
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = [[self.listContent objectAtIndex:index] count];
    if (1 == count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.listContent count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    NSLog(@"%d",[[self.listContent objectAtIndex:section] count]);
    NSInteger count = [[self.listContent objectAtIndex:section] count];
    if (1 == count) {
        NSString *key = [[self.listContent objectAtIndex:section] objectAtIndex:0];
        NSArray *values = [self.orderedDic objectForKey:key];
        return [values count];
    }else
    {
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"PCTableViewCell";
//    PCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    PCTableViewCell *cell = [[PCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    NSString *key = [[self.listContent objectAtIndex:indexPath.section] objectAtIndex:0];
//    NSString *key = [self.orderedKeys objectAtIndex:indexPath.section];
    NSArray *values = (NSArray *)[self.orderedDic objectForKey:key];
    [cell setUpCell:[values objectAtIndex:indexPath.row]];
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
