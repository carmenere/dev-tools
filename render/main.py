import argparse
from pathlib import Path

from .log import LOG
from .settings import args
from .cli import reparse, parse
from .render import Template


settings = parse(args)
tmpl = Template(settings.get('tmpl_dir'), settings.get('tmpl'))

LOG.debug(f"tmpl={tmpl.path}, tvars = {tmpl.vars}")

parsed: argparse.Namespace = reparse(args, tmpl.vars)

LOG.debug(f"cli_args = { {k:v for k,v in vars(parsed).items()} }")

tmpl.render(out=Path(parsed.out_dir).joinpath(parsed.out), tvars={k:v for k,v in vars(parsed).items() if k in tmpl.vars})
