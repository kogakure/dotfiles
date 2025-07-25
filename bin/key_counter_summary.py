#!/usr/bin/env python3
import signal
import sys
from collections import Counter

from pynput import keyboard

SUMMARY_FILE = "key_summary.txt"
key_counter = Counter()


def on_press(key):
    try:
        k = key.char
    except AttributeError:
        k = str(key)
    key_counter[k] += 1


def write_summary():
    with open(SUMMARY_FILE, "w") as f:
        for key, count in key_counter.most_common():
            f.write(f"{key}: {count}\n")
    print(f"Summary saved to {SUMMARY_FILE}")


def signal_handler(sig, frame):
    write_summary()
    sys.exit(0)


if __name__ == "__main__":
    # Handle Ctrl+C gracefully
    signal.signal(signal.SIGINT, signal_handler)
    print("Logging keys... Press Ctrl+C to stop and save summary.")
    with keyboard.Listener(on_press=on_press) as listener:
        listener.join()
