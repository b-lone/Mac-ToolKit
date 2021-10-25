from typing import List, Tuple, Dict, Hashable, Any
import json

import general_utils


class Token:
    def __init__(self, name: str, normal: str):
        self.name = name
        self.cc_name = general_utils.to_camelcase(name)

        self.normal = normal
        self.pressed = normal
        self.hovered = normal
        self.disabled = normal
        self.focused = normal
        self.checked = normal

    # name is not counted as a member in this context, since a Token should be uniquely determined by it's color states
    @staticmethod
    def __members(token):
        return token.normal, token.pressed, token.hovered, token.disabled, token.focused, token.checked

    def __eq__(self, other):
        return Token.__members(self) == Token.__members(other)

    def __hash__(self):
        return hash(Token.__members(self)) if isinstance(self.normal, str) else hash(frozenset(self.normal))

    @staticmethod
    def allowed_states():
        return ['normal', 'pressed', 'hovered', 'disabled', 'focused', 'checked']

    def non_normal_states(self):
        return filter(lambda x: x != 'normal' and getattr(self, x) != getattr(self, 'normal'), Token.allowed_states())

def check_for_duplicate_keys(ordered_pairs: List[Tuple[Hashable, Any]]) -> Dict:
    dict_out: Dict = {}
    for key, val in ordered_pairs:
        if key in dict_out:
            raise ValueError(f'Found token with same name (token names must be unique): {key}')
        else:
            dict_out[key] = val
    return dict_out


def read_tokens(in_filename: str) -> List[Token]:
    with open(in_filename, 'r') as in_file:
        all_tokens = []
        theme_json = json.loads(in_file.read(), object_pairs_hook=check_for_duplicate_keys)
        tokens_json = theme_json['tokens']
        for name in tokens_json:
            data = tokens_json[name]

            if 'normal' not in data:
                raise Exception(f'Token {name} is missing the \'normal\' property!')

            t = Token(name, data['normal'])
            for key in data:
                if key != 'normal':
                    if key in Token.allowed_states():
                        setattr(t, key, data[key])
                    else:
                        raise Exception(f'State \'{key}\' is not allowed for token {name}, has to be one of: '
                                        f'{Token.allowed_states()}, in file: {in_filename}')

            all_tokens.append(t)

    return all_tokens
