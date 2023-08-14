import logging
import os


class CustomFormatter(logging.Formatter):
    ESC = "\x1b"
    CSI = f"{ESC}["
    dark_grey = f"{CSI}38;5;240m"
    light_grey = f"{CSI}38;5;247m"
    green = f"{CSI}38;5;34m"
    yellow = f"{CSI}38;5;208m"
    red = f"{CSI}38;5;196m"
    pink = f"{CSI}38;5;201m"
    white = f"{CSI}38;5;255m"
    reset = f"{CSI}0m"
    log_fmt = '[[%(asctime)s::%(levelname)s::%(pathname)s::%(lineno)s::%(funcName)s]] %(message)s'

    FORMATS = {
        logging.DEBUG: dark_grey + log_fmt + reset,
        logging.INFO: white + log_fmt + reset,
        logging.WARNING: yellow + log_fmt + reset,
        logging.ERROR: red + log_fmt + reset,
        logging.CRITICAL: pink + log_fmt + reset
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)

class Panic(Exception):
    pass

def panic(msg=""):
    LOG.critical(msg)
    raise Panic(msg)


severity = os.environ.get("SEVERITY", None) or 'info'
severity = getattr(logging, severity.upper())

custom_fmt = logging.StreamHandler()
custom_fmt.setLevel(severity)
custom_fmt.setFormatter(CustomFormatter())

LOG = logging.getLogger(__name__)
LOG.propagate=False
LOG.addHandler(custom_fmt)
LOG.setLevel(severity)
