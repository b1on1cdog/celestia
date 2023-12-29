#import <Foundation/Foundation.h>
#import "CLARootListController.h"
#import <spawn.h>

@implementation CLARootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)ApplySettings{
	pid_t pid;
	const char* args[] = {"killall", "-9", "vot","backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

-(void)donate{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.buymeacoffee.com/b1on1cdog"] options:@{} completionHandler:nil];
}

@end
