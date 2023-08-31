from pathlib import Path
import os

from .log import LOG
from .cli import args, get_tvars, parse
from .render import Template


settings = parse(args)
LOG.debug(f"cli_args = { {k:v for k,v in settings.items()} }")

tmpl = Template(settings.get('tmpl'))

LOG.info(f"Template: '{tmpl.path.absolute()}'.")

tvars = get_tvars(tmpl.vars)

LOG.debug(f"tvars = {tvars}")

DEFAULTS = os.environ.get('DEFAULTS', [])
if DEFAULTS:
    DEFAULTS = DEFAULTS.split(' ')

LOG.debug(f"DEFAULTS = {DEFAULTS}")

defaults = {}
for k in DEFAULTS:
    val = os.environ.get(k)
    if val is not None:
        defaults[k] = val

LOG.debug(f"defaults = {defaults}")

tmpl.render(out=Path(settings.get('out')), tvars=tvars, defaults=defaults, all_envs=dict(os.environ))
