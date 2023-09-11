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

tmpl.render(out=Path(settings.get('out')), tvars=tvars, all_envs=dict(os.environ))
