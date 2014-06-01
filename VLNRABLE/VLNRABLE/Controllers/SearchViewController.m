//
//  SearchViewController.m
//  VLNRABLE
//
//  Created by Paris Pinkney on 5/31/14.
//  Copyright (c) 2014 VLNRABLE. All rights reserved.
//

#import "SearchViewController.h"
#import "TableView.h"
#import "StoryTableViewCell.h"
#import "StoryManager.h"
#import "Story.h"
#import "User.h"
#import "DateTools.h"

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *storyCellIdentifier = @"storyCellIdentifier";

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) UISearchBar *searchBar;
@property (nonatomic, readwrite, strong) TableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *searchResults;
@property (nonatomic, readwrite, strong) NSMutableArray *recentSearches;

@end

@implementation SearchViewController

- (void)loadView
{
	_tableView = [[TableView alloc] initWithSeparators:YES];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self setView:_tableView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.backgroundColor = [VLNRColor lightTealColor];

	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.tableView.separatorInset = UIEdgeInsetsZero;
	}

	[self.tableView registerClass:[UITableViewCell class]
		   forCellReuseIdentifier:cellIdentifier];

	[self.tableView registerClass:[StoryTableViewCell class]
		   forCellReuseIdentifier:storyCellIdentifier];

	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.titleView = self.searchBar;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self.searchBar becomeFirstResponder];

	self.tabBarController.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	self.tabBarController.navigationController.navigationBarHidden = NO;
}

#pragma mark - Lazy loading methods
- (UISearchBar *)searchBar
{
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc] init];
		_searchBar.delegate = self;
		_searchBar.showsCancelButton = YES;
		[_searchBar sizeToFit];
	}
	return _searchBar;
}

- (NSMutableArray *)recentSearches
{
	if (!_recentSearches) {
		_recentSearches = [NSMutableArray arrayWithCapacity:[[StoryManager sharedManager].stories allObjects].count];
		[_recentSearches addObject:@"Recent Searches"];
	}
	return _recentSearches;
}

- (void)setSearchResults:(NSMutableArray *)searchResults
{
	_searchResults = searchResults;
	[self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRows;
	if (self.searchResults) {
		numberOfRows = self.searchResults.count;
	} else {
		numberOfRows = self.recentSearches.count;
	}
	return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id cell;
	if (self.searchResults) {
		StoryTableViewCell *storyCell = [tableView dequeueReusableCellWithIdentifier:storyCellIdentifier
																   forIndexPath:indexPath];

		[self configureCell:storyCell forRowAtIndexPath:indexPath];
		cell = storyCell;
	} else {
		UITableViewCell *recentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
																	  forIndexPath:indexPath];

		recentCell.textLabel.text = [self.recentSearches objectAtIndex:indexPath.row];
		if (indexPath.row == 0) {
			recentCell.selectionStyle = UITableViewCellSelectionStyleNone;
		}

		cell = recentCell;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat heightForRow;
	if (self.searchResults) {
		heightForRow = [StoryTableViewCell height];
	} else {
		heightForRow = 40.0f;
	}
	return heightForRow;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!self.searchResults && indexPath.row == 0) {
		return;
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (self.searchResults) {
		Story *story = [self.searchResults objectAtIndex:indexPath.row];
		// TODO: Push to storyVC.
	} else {
		[self searchBar:self.searchBar textDidChange:[self.recentSearches objectAtIndex:indexPath.row]];
	}
}

#pragma mark - Search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (searchText.length > 2) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(category CONTAINS[cd] %@) OR (content CONTAINS[cd] %@) OR (mood CONTAINS[cd] %@) OR (title CONTAINS[cd] %@)", searchText, searchText, searchText, searchText];
		self.searchResults = [[[[StoryManager sharedManager].stories allObjects] filteredArrayUsingPredicate:predicate] mutableCopy];
		VLNRLogVerbose(@"Search Results: %@", [self.searchResults valueForKey:@"title"]);
	} else if (!searchText.length) {
		self.searchResults = nil;
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	self.searchResults = nil;
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.recentSearches insertObject:searchBar.text atIndex:1];
	[searchBar resignFirstResponder];
}

#pragma mark - Action methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	StoryTableViewCell *storyCell = (StoryTableViewCell *)cell;
	Story *story = [self.searchResults objectAtIndex:indexPath.row];
	storyCell.timeLabel.text = [[NSDate date] timeAgoSinceDate:story.updatedAt numericDates:YES];
	storyCell.storyLabel.text = story.content;

	NSString *storyTitle = [NSString stringWithFormat:@"%@ by %@", story.title, story.user.nickname];
	NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:storyTitle];
	NSRange titleRange = [[titleStr string] rangeOfString:story.title];
	[titleStr addAttributes:@{ NSForegroundColorAttributeName: [VLNRColor blueColor],
							   NSFontAttributeName: [VLNRAppManager boldSmallSystemFont] }
					  range:titleRange];
	storyCell.titleLabel.attributedText = titleStr;

	NSString *storyCategory = @"Trending in: Relationships";
	NSMutableAttributedString *categoryStr = [[NSMutableAttributedString alloc] initWithString:storyCategory];
	NSRange categoryRange = [[categoryStr string] rangeOfString:@"Trending in:"];
	[categoryStr addAttributes:@{ NSForegroundColorAttributeName: [VLNRColor grayTextColor],
								  NSFontAttributeName: [VLNRAppManager smallSystemFont] }
						 range:categoryRange];
	storyCell.categoryLabel.attributedText = categoryStr;
}

@end
