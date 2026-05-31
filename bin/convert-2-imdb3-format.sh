#!/usr/bin/env bash
#
# Convert an IMDb CSV export (Watchlist/Favorites/Ratings) to the
# TMDb-compatible IMDb v3 format, overwriting the file in place.
#
# Usage: convert-2-imdb3-format.sh <file.csv>

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") <file.csv>" >&2
  exit 127
fi

if [ ! -f "$1" ]; then
  echo "Error: file not found: $1" >&2
  exit 1
fi

exec python3 - "$1" <<'PY'
import csv, os, sys, tempfile

V3 = ["Position","Const","Created","Modified","Description","Title","URL",
      "Title Type","IMDb Rating","Runtime (mins)","Year","Genres","Num Votes",
      "Release Date","Directors","Your Rating","Date Rated"]

path = sys.argv[1]
with open(path, newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    header = list(reader.fieldnames or [])
    rows = list(reader)

if header == V3:
    print(f"{path}: already v3, no change")
    sys.exit(0)

if "Position" in header and "Original Title" in header:
    variant = "watchlist"
    def to_v3(r, i):
        return {k: r.get(k, "") for k in V3}
elif header[:3] == ["Const","Your Rating","Date Rated"]:
    variant = "ratings"
    def to_v3(r, i):
        out = {k: r.get(k, "") for k in V3}
        out["Position"]    = str(i)
        out["Created"]     = r.get("Date Rated", "")
        out["Modified"]    = r.get("Date Rated", "")
        out["Description"] = ""
        return out
else:
    print(f"Unknown IMDb CSV schema.", file=sys.stderr)
    print(f"  got: {header}", file=sys.stderr)
    print(f"  v3 : {V3}", file=sys.stderr)
    sys.exit(2)

out_rows = [to_v3(r, i) for i, r in enumerate(rows, 1)]

fd, tmp = tempfile.mkstemp(dir=os.path.dirname(os.path.abspath(path)), prefix=".imdb3.")
try:
    with os.fdopen(fd, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=V3, quoting=csv.QUOTE_MINIMAL,
                           lineterminator="\n")
        w.writeheader()
        w.writerows(out_rows)
    os.replace(tmp, path)
except Exception:
    try:
        os.unlink(tmp)
    except OSError:
        pass
    raise

print(f"{path}: converted {len(out_rows)} rows (variant={variant})")
PY
