from typing import List
import argparse


class CliArg:
    def __init__(self, prefix, name, default = argparse.SUPPRESS, required = False, dest = None, metavar = ''):
        self.prefix = prefix
        self.name = name
        self.full_name = prefix + name
        self.default = default
        self.dest = dest or name
        self.required = required
        self.metavar = metavar

add_argument_args = frozenset(['default', 'dest', 'required', 'metavar'])

def parse(args: List[CliArg]):
    parser = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    for arg in args:
        print(vars(arg))
        parser.add_argument(arg.full_name, **{key:value for key, value in vars(arg).items() if key in add_argument_args})
    args, _ = parser.parse_known_args()
    return vars(args)

def reparse(args: List[CliArg], tvars: List[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(allow_abbrev=False)
    for arg in args:
        print(f"arg.full_name = {arg.full_name}")
        parser.add_argument(arg.full_name, **{key:value for key, value in vars(arg).items() if key in add_argument_args})
    for var in tvars:
        print(f"var = {var}")
        parser.add_argument('--' + var, default=argparse.SUPPRESS,  dest=var, metavar='')
    return parser.parse_args()
