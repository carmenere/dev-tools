import argparse
from pathlib import Path

from .log import LOG
from .settings import args, essential
from .cli import reparse, parse
from .render import Template


settings = parse(essential)
tmpl = Template(settings.get('tmpl_dir'), settings.get('tmpl'))

LOG.debug(f"tvars = {tmpl.vars}, tmpl={tmpl.path}")

parsed: argparse.Namespace = reparse(args, tmpl.vars)
out = Path(parsed.out_dir).joinpath(parsed.out) 

LOG.debug(f"out = {out}")

tmpl.render(out=Path(parsed.out_dir).joinpath(parsed.out),  tvars={k:v for k,v in vars(parsed).items() if k in tmpl.vars})
