import json


def to_camelcase(name):
    all_parts = []
    for part in name.split('-'):
        caps = [0] + [i for i, e in enumerate(part) if e.isupper()] + [len(part)]
        spl = [(lambda s: s[0].upper() + s[1:])(part[x:y]) for x, y in zip(caps, caps[1:]) if x != y]
        all_parts.extend(spl)

    return ''.join(all_parts)


def to_apple_token(token):
    return f'CHSemanticToken{token}'


def get_theme_name(theme_file):
    with open(theme_file, 'r') as in_file:
        theme_json = json.loads(in_file.read())
        if 'name' not in theme_json:
            raise ValueError(f'The theme file {theme_file} is missing the name property!')

        return theme_json['name']   # TODO - to upper


def gen_setters(token: 'Token'):
    def add_setter(s, n):
        return f'.set{n}(color("{s}"))' if s != token.normal else ''

    setters = ''

    for state, name in [
        (token.pressed, 'Pressed'),
        (token.hovered, 'Hovered'),
        (token.checked, 'Checked'),
        (token.focused, 'Focused'),
        (token.disabled, 'Disabled')
    ]:
        setters += add_setter(state, name)

    return setters


def namespace():
    return 'SemanticVisuals'


def default_theme():
    return 'Default'
