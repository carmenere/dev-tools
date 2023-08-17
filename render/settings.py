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


essential = [
    CliArg(
        prefix = '--',
        name = 'tmpl_dir',
        default = os.environ.get('TMPL_DIR', os.getcwd()),
        required = False
    ),
    CliArg(
        prefix = '--',
        name = 'in',
        dest = 'tmpl',
        required = True
    )
]

args = essential + [
    CliArg(
        prefix = '--',
        name = 'out',
        required = True
    ),
    CliArg(
        prefix = '--',
        name = 'out_dir',
        default = os.environ.get('OUT_DIR', os.path.join(os.getcwd(), '.output')),
        required = False
    )
]
