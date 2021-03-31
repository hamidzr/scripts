#!/usr/bin/env python3

"""record from a pulseaudio sink. this creates a new sink with
module-combine-sink, records the output with ffmpeg. does not overwrite
if output file already exits, except --force is set.
"""

# Copyright (c) 2011 Waschtl https://askubuntu.com/a/60856/123761
# Copyright (c) 2016 KrisWebDev https://askubuntu.com/a/724964/123761
# Copyright (c) 2019 ramast https://gist.github.com/ramast/c47bd5e57586e9c2deb74975e27089f0
# Copyright (c) 2020 Antoine Beaupré <anarcat@debian.org>
# Copyright (c) 2021 René Kschamer <https://github.com/rkschamer>
#
# This work is licensed under the Creative Commons
# Attribution-ShareAlike 4.0 International License. To view a copy of
# this license, visit http://creativecommons.org/licenses/by-sa/4.0/
# or send a letter to Creative Commons, PO Box 1866, Mountain View, CA
# 94042, USA.

import argparse
import logging
import re
import subprocess
import sys
import shlex
import signal
from os import path
from time import sleep

DEFAULT_OUTPUT_RE = re.compile(r"^\s*name: <([^ >]+)>")
MONITOR_SINK_NAME = "record-n-play"


def load_record_module(sink):
    return int(subprocess.run(
        [
            "pactl",
            "load-module",
            "module-combine-sink",
            f"sink_name={MONITOR_SINK_NAME}",
            f"slaves={sink}",
            "sink_properties=device.description=Record-and-Play",
        ],
        stdout=subprocess.PIPE,
        check=True,
    ).stdout.strip())


SINK_INPUTS = re.compile(r"""
\s*index:\s+(?P<index>\d+)\s+
.*
^\s+sink:\s+(?P<sink>\d+)\s+<[^>]+>\s*$
.*
^\s+client:\s+\d+\s+<(?P<client>[^>]*)>$
.*""", re.VERBOSE | re.MULTILINE | re.DOTALL)


def list_sink_inputs():
    output = subprocess.run(
        ["pacmd", "list-sink-inputs"], stdout=subprocess.PIPE, check=True
    ).stdout.decode("utf-8")
    clients = {}
    sinks = {}
    for match in SINK_INPUTS.finditer(output):
        clients[int(match.group('index'))] = match.group('client')
        sinks[int(match.group('index'))] = match.group('sink')
    return clients, sinks


def main(args, custom_ffmpeg_args):
    record_module_id = None

    def cleanup(sig=None, frame=None):
        if record_module_id is None:
            logging.debug("recorder not enabled, nothing to do in cleanup")
            sys.exit(0)

        cmd = [
            "pactl",
            "move-sink-input",
            str(client_index),
            str(sinks[client_index]),
        ]
        logging.debug("restoring sink input with %s", cmd)
        subprocess.run(cmd)
        if record_module_id:
            cmd = ["pactl", "unload-module", str(record_module_id)]
            logging.debug("unloading recording module with %s", cmd)
            subprocess.run(cmd)

        if sig:
            logging.warning("Terminated by signal %d", sig)
            if sig not in (signal.SIGTERM, signal.SIGINT):
                sys.exit(sig)
        logging.warning("Completed")
        sys.exit(0)

    signal.signal(signal.SIGTERM, cleanup)
    signal.signal(signal.SIGINT, cleanup)

    clients, sinks = list_sink_inputs()

    if len(clients) <= 0:
        logging.warning("no clients found, aborting")
    logging.debug("running clients %r, sinks %r", clients, sinks)

    if args.interactive:
        print("running clients:")
        for index, client in clients.items():
            print(index, '-', client)
        while True:
            try:
                client_index = int(input("Please enter a number: "))
            except ValueError:
                print("Only numbers are allowed")
                continue

            if client_index not in clients.keys():
                print("Number out of range")
                continue

            break

        app_name = clients[client_index]
        input(f"Press enter to record from {app_name}... ")
    else:
        client_index = list(clients.keys())[0]
        app_name = clients[client_index]

    while True:
        clients, sinks = list_sink_inputs()

        # client_index might have changed since we started, so try to find it again if missing
        if app_name not in clients.values():
            # note that we match on the client name here, which might
            # match the wrong channel, but it's the best we can do if
            # the index changed.
            for client_index, possible_name in clients.items():
                if app_name == possible_name:
                    break
            else:
                logging.warning("Couldn't find selected audio channel (%s), retrying", app_name)
                logging.debug("running clients %r, sinks %r", clients, sinks)
                sleep(1)
                continue
        break

    if args.output != '-' and path.exists(args.output) and not args.force:
        print(f"Output file {args.output} already exists. Use --force to overwrite or choose a different file.")
        return

    logging.info("Recording from client %d (%s)", client_index, app_name)
    record_module_id = load_record_module(sinks[client_index])
    logging.debug("record module id is %r", record_module_id)
    cmd = ["pactl", "move-sink-input", str(client_index), MONITOR_SINK_NAME]
    logging.debug("moving sink input to recorder with: %s", cmd)
    subprocess.check_call(cmd)

    ffmpeg_command = ["ffmpeg", "-f", "pulse", "-i", f"{MONITOR_SINK_NAME}.monitor", "-y" if args.force else "-n",
                      *(custom_ffmpeg_args if args.use_custom_args else []), shlex.quote(args.output)]
    logging.debug("running recorder command: %s", ffmpeg_command)
    subprocess.check_call(ffmpeg_command)
    cleanup()


__epilog__ = """The default output encoder is libopus. To choose a different encoder just use the appropriate extension 
                for output file (e.g. -o [recording.wav | recording.flac | recording.mp3]).  To tweak encoder settings 
                use --use-custom-args, e.g. -b:a 128k for a different OPUS bit rate. 
                See https://ffmpeg.org/ffmpeg-codecs.html#Audio-Encoders for details about available encoders and 
                their parameters.
            """


class LoggingAction(argparse.Action):
    """change log level on the fly

    The logging system should be initialized before this, using
    `basicConfig`.
    """

    def __init__(self, *args, **kwargs):
        """setup the action parameters

        This enforces a selection of logging levels. It also checks if
        const is provided, in which case we assume it's an argument
        like `--verbose` or `--debug` without an argument.
        """
        kwargs["choices"] = logging._nameToLevel.keys()
        if "const" in kwargs:
            kwargs["nargs"] = 0
        super().__init__(*args, **kwargs)

    def __call__(self, parser, ns, values, option):
        """if const was specified it means argument-less parameters"""
        if self.const:
            logging.getLogger("").setLevel(self.const)
        else:
            logging.getLogger("").setLevel(values)


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__, epilog=__epilog__)
    parser.add_argument(
        "--output",
        "-o",
        default="recording.opus",
        help="output file, default: %(default)s",
    )
    parser.add_argument(
        "--interactive",
        "-i",
        action="store_true",
        help="interactively select sink instead of guessing",
    )
    parser.add_argument(
        "--use-custom-args",
        action="store_true",
        default=False,
        help="if set you can specify custom arguments for ffmpeg (e.g., different bit rate)",
    )
    parser.add_argument(
        "--force",
        "-f",
        action="store_true",
        default=False,
        help="overwrites the output file if it exists otherwise script exits (also in interactive mode)"
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action=LoggingAction,
        const="INFO",
        help="enable verbose messages",
    )
    parser.add_argument(
        "--debug",
        action=LoggingAction,
        const="DEBUG",
        help="enable debugging messages",
    )
    return parser.parse_known_args()


if __name__ == "__main__":
    logging.basicConfig(format="%(levelname)s: %(message)s", level="WARNING")
    main(*parse_args())
