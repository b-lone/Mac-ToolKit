from typing import List, Dict

from semantic_token import Token, read_tokens
import general_utils
from verification import colors, themes
from verification.colors import Color


def get_tokens_all_themes(theme_files: List[str]) -> Dict[str, List[Token]]:
    return {general_utils.get_theme_name(theme_file): read_tokens(theme_file) for theme_file in theme_files}

def validate_input(theme_files: List[str], colors_file: str, verbose: bool) -> bool:

    tokens_by_theme = get_tokens_all_themes(theme_files)

    all_colors = colors.read_colors(colors_file)
    for color in all_colors:
        if not colors.validate_color(color, all_colors):
            return False

    for (theme, tokens_for_theme) in tokens_by_theme.items():
        if "momentum" in theme.lower():
            verify_momentum_colours(tokens_for_theme)
        else:
            themes.validate_theme_colors(theme, tokens_for_theme, all_colors)

    if verbose:
        print_duplicate_tokens(tokens_by_theme)

    print('All themes and colors validation success!')
    return True

def verify_momentum_colours(tokens_for_theme: List[Token]):

    def verify_color(name: Token, rgba_json='normal'):
        c = Color(name, rgba_json=rgba_json)
        c.verify_numeric_types()
        c.verify_rbga()

    for token in tokens_for_theme:
        verify_color(token.name, rgba_json=token.normal)

        for state in token.non_normal_states():
            state_colours = getattr(token, state)
            verify_color(token.name, rgba_json=state_colours)

def print_duplicate_tokens(tokens_by_theme: Dict[str, List[Token]]):
    all_dupes = []
    for (theme, tokens_for_theme) in tokens_by_theme.items():
        dupes = themes.check_for_duplicates(tokens_for_theme)
        all_dupes.append(dupes)

    if not all_dupes:
        return

    common_dupes = all_dupes[0].intersection(*all_dupes[1:])
    print('Duplicated tokens:')
    print('-----')
    for cd in common_dupes:
        print(cd)
    print('-----')
    print()
