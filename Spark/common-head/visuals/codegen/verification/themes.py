from typing import List, Dict, Set, Tuple
from semantic_token import Token
from verification import colors


def validate_theme_files_matching(tokens_by_set: Dict[str, List[Token]]):
    token_names_by_theme = [(theme_name, sorted([token.name for token in tokens_by_set[theme_name]]))
                            for theme_name in tokens_by_set]

    def all_same(x):
        return x.count(x[0]) == len(x)

    lengths_by_theme = [(theme_name, len(token_names)) for theme_name, token_names in token_names_by_theme]
    if not all_same([length for _, length in lengths_by_theme]):
        raise Exception(f'Not all theme files have the same number of tokens! {lengths_by_theme}')

    for tokens_group in zip(*[[(theme, token) for token in tokens] for theme, tokens in token_names_by_theme]):
        if not all_same([token for _, token in tokens_group]):
            raise Exception(f'Mismatch detected in: {tokens_group}')


def get_color(name, all_colors):
    return next((c for c in all_colors if c.name == name), None)


def validate_theme_color(color_name: str, all_colors: List[colors.Color]) -> bool:
    color = get_color(color_name, all_colors)
    if color is None:
        print(f'No color with name "{color_name}" found!')
        return False

    if color.hex_val is None and color.alias is not None:
        return validate_theme_color(color.alias, all_colors)

    return True


def validate_theme_colors(name: str, tokens: List[Token], all_colors: List[colors.Color]):
    for token in tokens:
        token_colors = [(v, vars(token)[v]) for v in vars(token) if 'name' not in v]

        for state, color_name in token_colors:
            if not validate_theme_color(color_name, all_colors):
                raise Exception(f'Unresolved color for token "{token.name}" {state} state - "{color_name}" given! In theme {name}.')


def get_token(token: Token, tokens: Set[Token]) -> Token:
    return next((t for t in tokens if t == token), None)


def check_for_duplicates(tokens: List[Token]) -> Set[Tuple[str, str]]:
    unique_tokens = set()
    dupes = set()

    for token in tokens:
        if token in unique_tokens:
            matched_token = get_token(token, unique_tokens)
            dupes.add((token.name, matched_token.name))
        else:
            unique_tokens.add(token)

    return dupes
