from typing import List, Dict
import binascii
import json


class Color:
    def __init__(self, name, hex_val=None, rgba_json=None, alias=None):
        self.name = name
        self.hex_val = hex_val
        self.rgba_json = rgba_json
        self.alias = alias

        self.alias_and_no_nums = alias is not None and hex_val is None and rgba_json is None
        self.no_alias_and_nums = alias is None and not rgba_json is None

        self.verify_data()

    def verify_data(self):
        if not self.name:
            raise Exception(f'A color without a name detected, info: {self}')

        if not (self.alias_and_no_nums or self.no_alias_and_nums):
            raise Exception(f'A color needs either an alias or hex and rgba values, but not both {self}')

    def has_alias(self):
        return self.alias_and_no_nums

    def check_alias(self, all_colors):
        if self.alias_and_no_nums:
            if self.alias not in [c.name for c in all_colors]:
                raise Exception(f'No aliased color found for color {self}')

    def verify_hex(self):
        if self.hex_val[0] != '#' or (len(self.hex_val) != 7 and len(self.hex_val) != 9):
            raise Exception(f'Ill-formatted hex value for color {self}')

    def verify_numeric_types(self):
        if any([not isinstance(comp, int) for comp in get_rgb(self.rgba_json)[0:2]]) \
                or not isinstance(self.rgba_json.get('a'), (int, float)):
            raise Exception(f'Invalid numerical values detected for color {self}')

    def verify_numeric_values(self):
        try:
            rgba = binascii.unhexlify(self.hex_val[1:])
            for component in list(zip(rgba, get_rgb(self.rgba_json)))[:3]:
                if not 0 <= component[1] <= 255:
                    raise Exception(f'Invalid value for rgb found for color {self}')
                if component[0] != component[1]:
                    raise Exception(f'Mismatch between hex and rgb found for color {self}')
        except binascii.Error:
            raise Exception(f'Incorrect hex value for color {self}')

        alpha = float(self.rgba_json.get('a'))
        if not 0 <= alpha <= 1:
            raise Exception(f'Invalid value for alpha found for color {self}')

    def verify_rbga(self):
        rgb = get_rgb(self.rgba_json)
        for component in rgb[:3]:
            if not 0 <= component <= 255:
                raise Exception(f'Invalid value for rgb found for color {self}')

        if not 0 <= float(self.rgba_json.get('a')) <= 1:
            raise Exception(f'Invalid value for alpha found for color {self}')

    def __repr__(self):
        return f'(name: {self.name}, hex: {self.hex_val}, rgba: {self.rgba_json}, alias: {self.alias})'


def read_colors(colors_file: str) -> List[Color]:
    with open(colors_file, 'r') as in_file:
        full_json = json.loads(in_file.read())

        all_colors = []
        for color_json in full_json['colors']:
            for cvar_json in color_json['variations']:
                all_colors.append(
                    Color(cvar_json.get('name'), cvar_json.get('hex'), cvar_json.get('rgba'), cvar_json.get('alias')))

        return all_colors


def get_rgb(rgba_json: Dict[str, str]) -> List[int]:
    return [int(rgba_json.get('r')),
            int(rgba_json.get('g')),
            int(rgba_json.get('b'))]


def validate_color(c: Color, all_colors: List[Color]) -> bool:
    if c.has_alias():
        c.check_alias(all_colors)
    else:
        c.verify_hex()
        c.verify_numeric_types()
        c.verify_numeric_values()

    return True
