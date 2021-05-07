#!/usr/bin/env prun

import pychromecast
import sys
import itertools
from typing import List, Dict

services, browser = pychromecast.discovery.discover_chromecasts()

def discover_audio_devices():
    devices: Dict[str, List[str]] = {}
    for s in services:
        devices.setdefault(s.model_name, [])
        devices[s.model_name].append(s.friendly_name)
    groups: List[str] = devices.pop('Google Cast Group')
    devices.pop('Chromecast')
    single_devs = itertools.chain.from_iterable(devices.values())
    return list(single_devs), groups


def set_volume(casts: List[pychromecast.Chromecast], volume: float = 0.3):
    for c in casts:
        print(f'setting "{c.device.friendly_name}"\'s volume to {volume}')
        c.wait()
        c.set_volume(volume)


if __name__ == '__main__':
    devs, groups = discover_audio_devices()
    casts, browser = pychromecast.get_listed_chromecasts(friendly_names=devs)
    set_volume(casts, float(sys.argv[1]) if len(sys.argv) > 1 else 0.3)
    browser.stop_discovery()
