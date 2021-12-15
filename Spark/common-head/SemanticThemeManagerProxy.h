#import <Foundation/Foundation.h>
#import "visuals/autogen/apple/CHSemanticToken.h"

@class CommonHeadFrameworkProxy;
@class UTColorStates;
enum UTTeamStyle: NSInteger;

@interface SemanticThemeManagerProxy : NSObject

-(nonnull UTColorStates*) getColorStates:(enum CHSemanticToken)token;
-(nonnull UTColorStates*) getColorSetForTokenName:(nonnull NSString*)name;
-(enum UTTeamStyle) getTeamStyle:(nonnull NSString*) hex;

-(nonnull id) initWithCommonHeadFrameworkProxy:(nonnull CommonHeadFrameworkProxy*)commonHeadFrameworkProxy;

@end
