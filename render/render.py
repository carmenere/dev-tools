import os
from pathlib import Path
from jinja2 import Environment, StrictUndefined, meta, FileSystemLoader, nodes
from .log import LOG, panic


def get_tvars(env: Environment, filename: str):
    tvars = set()
    tsource = env.loader.get_source(env, filename)[0]
    parsed = env.parse(tsource)
    tvars.update(list(meta.find_undeclared_variables(parsed)))
    for item in parsed.body:
        if type(item) is nodes.Include:
            tvars.update(get_tvars(env, item.template.value))
    return set(tvars)

def create_dir(dir):
    if os.path.exists(dir) and not os.path.isdir(dir):
        panic(f"Path '{dir}' exists, but it is not directory.")

    if not os.path.exists(dir):
        LOG.info(f"Creating directory: '{dir}'.")
        os.makedirs(dir)


class Template:
    def __init__(self, tmpl_dir: str, tmpl: str):
        self.tmpl_dir: Path = Path(tmpl_dir)
        self.path: Path = self.tmpl_dir.joinpath(tmpl)
        self.jenv = Environment(loader=FileSystemLoader(searchpath=self.path.parent), undefined=StrictUndefined, extensions=['jinja2.ext.do'])
        self.tmpl  = self.jenv.get_template(self.path.name)
        self.vars: list = get_tvars(self.jenv, self.path.name)
        LOG.debug(f"self.vars: {self.vars}")

    def render(self, out: Path, tvars: dict):
        LOG.debug(f"out = {out}")
        LOG.debug("TVARS:\n{}".format("\n".join(f"{k} = {tvars[k]}" for k in sorted(tvars.keys()))))
        LOG.debug("os.environ:\n{}".format("\n".join(f"{k} = {dict(os.environ)[k]}" for k in sorted(dict(os.environ).keys()))))
        content = self.tmpl.render(**{k.upper():v for k,v in tvars.items()}, env=dict(os.environ))

        create_dir(out.parent)
        
        with open(out, mode="w", encoding="utf-8") as message:
            message.write(content)
            LOG.info(f"Rendered file: '{out.absolute()}'.")
