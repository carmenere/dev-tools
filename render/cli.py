from typing import List
import argparse
import os

from .log import LOG


class CliArg:
    def __init__(self, name, aliases = None, default = argparse.SUPPRESS, required = False, dest = None, metavar = ''):
        self.name = name
        self.aliases = aliases or []
        self.default = default
        self.dest = dest or name
        self.required = required
        self.metavar = metavar


args = [
    CliArg(
        name = '--in',
        dest = 'tmpl',
        required = True,
    ),
    CliArg(
        name = '--out',
        required = True,
        dest = 'out',
    ),
]


add_argument_args = frozenset(['default', 'dest', 'required', 'metavar'])

def parse(args: List[CliArg]):
    parser = argparse.ArgumentParser(allow_abbrev=False)
    for arg in args:
        parser.add_argument(arg.name, *arg.aliases, **{key:value for key, value in vars(arg).items() if key in add_argument_args})
    args, _ = parser.parse_known_args()
    LOG.debug(args)
    return vars(args)

def get_tvars(tvars: List[str]) -> argparse.Namespace:
    d = {}
    for var in tvars:
        # it is special var used in template: env[item]
        if var == 'env':
            continue
        val = os.environ.get(var)
        if val is not None:
            d[var] = os.environ.get(var)
    return d
