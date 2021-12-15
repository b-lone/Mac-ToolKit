
#import "SemanticThemeManagerProxy.h"
#import "CommonHeadFrameworkProxy.h"

#import "SwiftInterfaceHeader.h"
#import "ServiceProxyBase.h"

#include "common-head/visuals/ITheme.h"
#include "common-head/visuals/IThemeManager.h"
#include "common-head/Services/ICommonHeadFramework.h"

#include "spark-client-framework/Services/CommonStrings/ThemesFlat.h"
#include "Tokens.h"
#import <UIToolkit/UIToolkit-Swift.h>
#import <TargetConditionals.h>


@implementation SemanticThemeManagerProxy
{
    std::shared_ptr<SemanticVisuals::IThemeManager> mThemeManager;
}

-(id) initWithCommonHeadFrameworkProxy:(CommonHeadFrameworkProxy*)commonHeadFrameworkProxy
{
    mThemeManager = commonHeadFrameworkProxy.commonHeadFramework->getSemanticThemeManager();
    return self;
}

-(nonnull UTColorStates*) getColorStates:(enum CHSemanticToken)token
{
    SemanticVisuals::Token cppToken = CHSemanticTokenToCPP(token);
    
    const auto wColorSet = mThemeManager->getActiveTheme()->getColorSet(cppToken);
    return [self fromColorSet:wColorSet];
}

-(nonnull UTColorStates*) getColorSetForTokenName:(nonnull NSString*)name;
{
    std::string cppStr = [name UTF8String];
    
    const auto wColorSet = mThemeManager->getActiveTheme()->getColorSet(cppStr);
    return [self fromColorSet: wColorSet];
}

//MARK: - Conversion functions
-(nonnull CCColor*) fromColor:(SemanticVisuals::Color)color
{
    CGFloat r = color.r / 255.0;
    CGFloat g = color.g / 255.0;
    CGFloat b = color.b / 255.0;
    CGFloat a = color.a / 255.0;
    
#if TARGET_OS_OSX
    return [CCColor colorWithSRGBRed:r green:g blue:b alpha:a];
#else
    return [CCColor colorWithRed:r green:g blue:b alpha:a];
#endif
}

-(nonnull UTColorStates*) fromColorSet:(SemanticVisuals::ColorSet)colorSet
{
    UTColorStates* colorStates = [[UTColorStates alloc] initWithNormal:[self fromColor:colorSet.normal]
                                                           hover:[self fromColor:colorSet.hovered]
                                                           pressed:[self fromColor:colorSet.pressed]
                                                           on:[self fromColor:colorSet.checked]
                                                           focused:[self fromColor:colorSet.focused]
                                                           disabled:[self fromColor:colorSet.disabled]];
    
    return colorStates;
}

-(enum UTTeamStyle) getTeamStyle:(nonnull NSString*) hex
{
    std::string hexString = [hex UTF8String];
    auto teamColorStyle = commonHead::TeamColorMapping::getColorStyle(hexString, mThemeManager);
    return [SemanticThemeManagerProxy convertTeamColorStyleToUTTeamStyle:teamColorStyle];
}

+(enum UTTeamStyle) convertTeamColorStyleToUTTeamStyle:(commonHead::viewModels::TeamColorStyle) style
{
    switch(style)
    {
        case commonHead::viewModels::TeamColorStyle::Unknown: return UTTeamStyleUnknown;
        case commonHead::viewModels::TeamColorStyle::Custom: return UTTeamStyleCustom;
        case commonHead::viewModels::TeamColorStyle::Default: return UTTeamStyleDefaultStyle;
        case commonHead::viewModels::TeamColorStyle::Gold: return UTTeamStyleGold;
        case commonHead::viewModels::TeamColorStyle::Orange: return UTTeamStyleOrange;
        case commonHead::viewModels::TeamColorStyle::Lime: return UTTeamStyleLime;
        case commonHead::viewModels::TeamColorStyle::Mint: return UTTeamStyleMint;
        case commonHead::viewModels::TeamColorStyle::Cyan: return UTTeamStyleCyan;
        case commonHead::viewModels::TeamColorStyle::Cobalt: return UTTeamStyleCobalt;
        case commonHead::viewModels::TeamColorStyle::Slate: return UTTeamStyleSlate;
        case commonHead::viewModels::TeamColorStyle::Violet: return UTTeamStyleViolet;
        case commonHead::viewModels::TeamColorStyle::Purple: return UTTeamStylePurple;
        case commonHead::viewModels::TeamColorStyle::Pink: return UTTeamStylePink;
    }
}

@end
