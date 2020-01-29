#!/usr/env python3

import datetime
import os

# Getting the current work directory (cwd)
thisdir = "/tmp/uscis"

ENTRY_START_SYMBOL = '==='


class InfoObj:
    def __init__(self, tracking_number, date, day_and_month, year, current_status):
        self.tracking_number = tracking_number
        self.date = date
        self.day_and_month = day_and_month
        self.year = year
        self.current_status = current_status

    def __str__(self):
        return (infoObj.tracking_number + ", " +
                infoObj.date + ", " +
                infoObj.day_and_month + ", " +
                infoObj.year + ", " +
                infoObj.current_status + "\n")

def peek_line(f):
    pos = f.tell()
    line = f.readline()
    f.seek(pos)
    return line

def seek_to_next_entry(f):
    # OPT we can optimize this for speed.
    next_line = peek_line(f)
    while (ENTRY_START_SYMBOL not in next_line) and (next_line != ""):
        f.readline()
        next_line = peek_line(f)

def parse_info_line(line):
    comma_separated_list = line.split(",")
    if comma_separated_list[0].startswith("On"):
        day_and_month = comma_separated_list[0].replace("On ", "").strip()
    elif comma_separated_list[0].startswith("As of"):
        day_and_month = comma_separated_list[0].replace("As of ", "").strip()
    elif comma_separated_list[0].startswith("At this time"):
        return ("", "", comma_separated_list[0])
    else:
        raise AssertionError

    year = comma_separated_list[1].strip()
    # status_tokens = comma_separated_list[2].split(" ")
    current_status = comma_separated_list[2]
    # for status_token in status_tokens:
    #     if status_token == "denied" or status_token == "approved" \
    #             or "received" == status_token or "rejected" == status_token \
    #             or "evidence" == status_token:
    #         current_status = status_token

    # if current_status is None:
    #     return None
    return (day_and_month, year, current_status)

def processSingleEntry(f):
    checking_line = f.readline()  # checking case status for LIN1990550000 at Tue 28 Jan 2020 09:55:09 PM PST
    checking_tokens = checking_line.split(" ")
    tracking_number = None
    date = checking_line.split(" at ")[-1].strip()
    for token in checking_tokens:
        if token.startswith("LIN"):
            tracking_number = token

    assert "===" in f.readline()  # ======

    info_line = f.readline()

    day_and_month, year, current_status = parse_info_line(info_line)
    seek_to_next_entry(f)

    return InfoObj(tracking_number, date, day_and_month, year, current_status)

def parse_file(file_path):
    with open(file_path) as f:
        while True:
            line = f.readline()
            if line == "": return # end of the file
            if not "===" in line: return # pointer is not at the proper location
            try:
                yield processSingleEntry(f)
            except AssertionError:
                print(f"something went wrong at {file_path}")
                continue



with open("output" + str(datetime.datetime.now().timestamp()) + ".csv", 'w') as fw:
    # r=root, d=directories, f = files
    for r, d, f in os.walk(thisdir):
        for file in f:
            if ".log" in file:
                print('parsing file', file)
                for infoObj in parse_file(os.path.join(r, file)):
                    fw.write(str(infoObj))
    fw.close()
