

#import "SectionsViewController.h"
#import "NSDictionary-DeepMutableCopy.h"

//#import <SMS_SDK/SMS_SDK.h>

@interface SectionsViewController ()
{
    NSMutableData*_data;
    int _state;
    NSString* _duid;
    NSString* _token;
    NSString* _appKey;
    NSString* _appSecret;
    NSMutableArray* _areaArray;
}

@end


@implementation SectionsViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;

#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array) {
            if ([name rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

- (void)setNav

{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    //设置显示的颜色
    
    bar.barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
    
    //设置字体颜色
    
    bar.tintColor = [UIColor whiteColor];
    
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //或者用这个都行
    
    //    [bar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    
}
- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
     navigationBar.tintColor = [UIColor blackColor];
     [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:MtkLocalizedString(@"alera_back")
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
//    navigationItem.tintColor = [UIColor whiteColor];
    [navigationItem setTitle:MtkLocalizedString(@"register_choose_cou")];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    search=[[UISearchBar alloc] init];
    search.frame=CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44);
    [self.view addSubview:search];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 88+statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(88+statusBarHeight)) style:UITableViewStylePlain];
    [self.view addSubview:table];
    
    table.dataSource=self;
    table.delegate=self;
    search.delegate=self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"country"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    self.allNames = dict;
    
    [self resetSearch];
    [table reloadData];
    [table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
}

-(void)setAreaArray:(NSMutableArray*)array
{
    _areaArray=[NSMutableArray arrayWithArray:array];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keys count];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return 0;
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier: SectionsTableIdentifier ];
    }
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range=[str1 rangeOfString:@"+"];
    NSString* str2=[str1 substringFromIndex:range.location];
    NSString* areaCode=[str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* countryName=[str1 substringToIndex:range.location];
    
    cell.textLabel.text=countryName;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"+%@",areaCode];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;
    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching)
        return nil;
    return keys;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    search.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}
- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range=[str1 rangeOfString:@"+"];
    NSString* str2=[str1 substringFromIndex:range.location];
    NSString* areaCode=[str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* countryName=[str1 substringToIndex:range.location];
    NSLog(@"%@ %@",countryName,areaCode);
    [self.view endEditing:YES];
    //传递数据
    if ([self.delegate respondsToSelector:@selector(setSecondData:areaCode:)]) {
        [self.delegate setSecondData:countryName areaCode:areaCode];
    }
    
    //关闭当前
    [self clickLeftButton];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    search.text = @"";
    
    [self resetSearch];
    [table reloadData];
    
    [searchBar resignFirstResponder];
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end