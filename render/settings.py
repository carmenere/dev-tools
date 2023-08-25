import os
from .cli import CliArg
from pathlib import Path


class Settings:
    def __init__(self, tmpl_dir: str, tmpl: str, out_dir:str, out: str, tvars: dict):
        self.tmpl_dir = Path(tmpl_dir)
        self.tmpl = self.tmpl_dir.joinpath(tmpl)
        self.out_dir = Path(out_dir)
        self.out = self.out_dir.joinpath(out)
        self.tvars = tvars

args = [
    CliArg(
        name = '--tmpl_dir',
        aliases = ['--TMPL_DIR'],
        default = os.environ.get('TMPL_DIR', os.getcwd()),
        required = False,
        dest = 'tmpl_dir',
    ),
    CliArg(
        name = '--in',
        aliases = ['--IN'],
        dest = 'tmpl',
        required = True,
    ),
    CliArg(
        name = '--out_dir',
        aliases = ['--OUT_DIR'],
        default = os.environ.get('OUT_DIR', os.path.join(os.getcwd(), '.output')),
        required = False,
        dest = 'out_dir',
    ),
    CliArg(
        name = '--out',
        aliases = ['--OUT'],
        required = True,
        dest = 'out',
    )
]
