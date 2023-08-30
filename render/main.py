import argparse
from pathlib import Path

from .log import LOG
from .settings import args
from .cli import get_tvars, parse
from .render import Template


settings = parse(args)
LOG.debug(f"cli_args = { {k:v for k,v in settings.items()} }")

tmpl = Template(settings.get('tmpl_dir'), settings.get('tmpl'))

LOG.info(f"Template: '{tmpl.path.absolute()}'.")

tvars = get_tvars(tmpl.vars)

LOG.debug(f"tvars = {tvars}")

tmpl.render(out=Path(settings.get('out_dir')).joinpath(settings.get('out')), tvars=tvars)
