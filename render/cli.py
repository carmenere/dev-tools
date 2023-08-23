from typing import List
import argparse

from .log import LOG


class CliArg:
    def __init__(self, name, aliases = None, default = argparse.SUPPRESS, required = False, dest = None, metavar = ''):
        self.name = name
        self.aliases = aliases or []
        self.default = default
        self.dest = dest or name
        self.required = required
        self.metavar = metavar

add_argument_args = frozenset(['default', 'dest', 'required', 'metavar'])

def parse(args: List[CliArg]):
    parser = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    for arg in args:
        parser.add_argument(arg.name, *arg.aliases, **{key:value for key, value in vars(arg).items() if key in add_argument_args})
    args, _ = parser.parse_known_args()
    LOG.debug(args)
    return vars(args)

def reparse(args: List[CliArg], tvars: List[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(allow_abbrev=False)
    for arg in args:
        parser.add_argument(arg.name, *arg.aliases, **{key:value for key, value in vars(arg).items() if key in add_argument_args})
    for var in tvars:
        parser.add_argument('--' + var, default=argparse.SUPPRESS,  dest=var, metavar='')
    return parser.parse_args()
