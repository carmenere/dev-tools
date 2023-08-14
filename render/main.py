import argparse

from .settings import Settings, args, essential
from .cli import reparse, parse
from .render import Render

essential_settings = parse(essential)

render = Render(essential_settings.get('tmpl_dir'))

vlist = render.extract_vars(essential_settings.get('tin'))

parsed: argparse.Namespace = reparse(args, vlist)

settings = Settings(tmpl=parsed.tin, tmpl_dir=parsed.tmpl_dir, out_dir=parsed.out_dir, out=parsed.out,
                    tvars={k:v for k,v in vars(parsed).items() if k in vlist})

render.render(settings.out, settings.tmpl, settings.tvars)
