import os
from pathlib import Path
from jinja2 import Environment, BaseLoader, StrictUndefined, meta

from .log import LOG, panic


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
        with open(f"{self.path.absolute()}") as f:
            template_str = f.read()
        self.jenv: Environment = Environment(loader=BaseLoader, undefined=StrictUndefined)
        self.vars: list = list(meta.find_undeclared_variables(self.jenv.parse(template_str)))
        self.tmpl = self.jenv.from_string(template_str)
    
    def render(self, out: Path, tvars: dict):
        content = self.tmpl.render(**{k.upper():v for k,v in tvars.items()})

        create_dir(out.parent)

        LOG.info(f"Template: '{self.path.absolute()}'.")
        with open(out, mode="w", encoding="utf-8") as message:
            message.write(content)
            LOG.info(f"Rendered file: '{out.absolute()}'.")
