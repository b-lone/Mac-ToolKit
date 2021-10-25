from pathlib import Path
import os
import argparse

import generators
import general_utils
from semantic_token import read_tokens
from semantic_token import Token
from verification import verification


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--themes_gen_files", type=str, required=True, nargs='*',
                        help="A path to the files for themes to generate.")
    parser.add_argument("--momentum_themes_gen_files", type=str, required=True, nargs='*',
                        help="A path to the files for momentum themes to generate.")
    parser.add_argument("--themes_val_files", type=str, required=True, nargs='*',
                        help="A path to the files for themes to validate (but not generate).")
    parser.add_argument("--colors_file", type=str, required=True,
                        help="A path to the colors file, needed for verification")
    parser.add_argument("--output_folder", type=str, default="",
                        help="A path to the folder to output the files to")
    parser.add_argument("--templates_folder", type=str, required=True,
                        help="A path to the folder with templates")
    parser.add_argument("--list_only", action="store_true",
                        help="Invoke this to see all files that will be generated")
    parser.add_argument("--verbose", action="store_true",
                        help="This will run all the verification steps and show all output")

    # platform-specific arguments for extra generation
    parser.add_argument("--apple", action="store_true", help="This is needed on Apple platforms to generate proxies")

    args = parser.parse_args()

    # verification stage
    theme_files = args.themes_gen_files + args.momentum_themes_gen_files + args.themes_val_files
    if not args.list_only and not verification.validate_input(theme_files, args.colors_file, args.verbose):
        exit(1)

    if args.list_only:
        gen = generators.PrintingGenerator(args.output_folder)
    else:
        Path(args.output_folder).mkdir(parents=True, exist_ok=True)
        gen = generators.Generator('Common', args.output_folder, [args.templates_folder])

    # business logic

    # this assumes that all theme files will have the same layout
    # if it changes, we would need a superset of all possible themes
    all_tokens = read_tokens(args.themes_gen_files[0])

    # filer out duplicate momentum tokens
    for momentum_file in args.momentum_themes_gen_files:
        for momentum_token in read_tokens(momentum_file):
            if not any(token.cc_name == momentum_token.cc_name for token in all_tokens):
                all_tokens.append(momentum_token)

    gen.generate('Tokens.h', 'tokens.j2', tokens=all_tokens)

    for theme_file in args.themes_gen_files:
        theme_name = general_utils.get_theme_name(theme_file)
        gen.generate(theme_name + 'Theme.h', 'theme_header.j2', theme_name=theme_name)
        gen.generate(theme_name + 'Theme.cpp', 'theme_impl.j2', theme_name=theme_name, tokens=read_tokens(theme_file))

    all_themes = [general_utils.get_theme_name(name) for name in args.themes_gen_files]

    # platform-specific stuff
    if args.apple:
        if args.list_only:
            apple_gen = generators.PrintingGenerator(os.path.join(args.output_folder, 'apple'))
        else:
            apple_dir = os.path.join(args.output_folder, 'apple')
            Path(apple_dir).mkdir(parents=True, exist_ok=True)
            apple_gen = generators.Generator('Apple', apple_dir, [os.path.join(args.templates_folder, 'apple'),
                                                                  args.templates_folder])

        apple_gen.generate('CHSemanticToken.h', 'tokens_header.j2', tokens=all_tokens)
        apple_gen.generate('CHSemanticToken.mm', 'tokens_impl.j2', tokens=all_tokens)

        print(apple_gen.get_state())

    print(gen.get_state())
