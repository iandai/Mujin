//
//  ViewController.m
//  Mujin
//
//  Created by Ian on 2014/06/07.
//  Copyright (c) 2014年 com.yumemi.ian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSMutableDictionary *dict;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readDict];
}

- (void)viewWillAppear:(BOOL)animated {
    /*
	 Hide navagation bar in first view.
	 */
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)readDict
{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"KanjiDict" ofType:@"plist"];
    NSArray *dictArray =[[NSArray alloc] initWithContentsOfFile:plistPath];
    
    self.dict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *d in dictArray) {
        NSString *hanzi = [d objectForKey:@"hanzi"];
        NSString *kanji = [d objectForKey:@"kanji"];
        if (hanzi && kanji) {
            [self.dict setObject:kanji forKey:hanzi];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.searchResults count];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
	else {
        cell.textLabel.text = NULL;
    }
    
    return cell;
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSInteger strLength = [searchString length];
    NSString *searchResult = @"";
    
    for (int i = 0; i < strLength; i++) {
        
        unichar s = [searchString characterAtIndex:(NSUInteger)i];
        NSString *singleCharacter = [NSString stringWithCharacters:&s length:1];
        NSString *kanji = [self.dict objectForKey:singleCharacter];
        searchResult = [NSString stringWithFormat:@"%@%@", searchResult, kanji];
    }
    
    self.searchResults = [[NSArray alloc] initWithObjects:searchResult, nil];

    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.kanji = [self.searchResults objectAtIndex:indexPath.row];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
