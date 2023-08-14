import os
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, StrictUndefined, meta

from .log import LOG, panic


def create_dir(dir):
    if os.path.exists(dir) and not os.path.isdir(dir):
        panic(f"Path '{dir}' exists, but it is not directory.")

    if not os.path.exists(dir):
        LOG.info(f"Creating directory: '{dir}'.")
        os.makedirs(dir)


class Render:
    def __init__(self, tmpl_dir):
        self.jenv = Environment(loader=FileSystemLoader(tmpl_dir), undefined=StrictUndefined)
    
    def render(self, out: Path, tmpl, tvars: dict):
        t = self.jenv.get_template(tmpl.name)
        content = t.render(**{k.upper():v for k,v in tvars.items()})

        create_dir(out.parent)

        LOG.info(f"Template: '{tmpl.absolute()}'.")
        with open(out, mode="w", encoding="utf-8") as message:
            message.write(content)
            LOG.info(f"Rendered file: '{out.absolute()}'.")

    def extract_vars(self, template: str):
        src = self.jenv.loader.get_source(self.jenv, template)
        parsed_content = self.jenv.parse(src)
        return list(meta.find_undeclared_variables(parsed_content))
