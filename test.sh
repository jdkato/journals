#!/bin/sh
#
# Three checks. Each rule carries its cases in a `tests:` block, run in
# isolation by `vale test`. Then one manuscript per format is checked under
# the config the README gives for it and compared to a golden file, and its
# rewrite in fixtures/clean/ is required to produce nothing at all.
#
# The rewrite is the load-bearing half. A Vale rule that matches nothing
# loads, runs, and reports success, so "no alerts" only means something when
# a paired fixture proves the rules fire. The last check makes that explicit:
# every rule has a case that expects an alert.
#
# `./test.sh -u` rewrites the golden files instead of comparing.
set -eu

update=0
[ "${1:-}" = "-u" ] && update=1
status=0

root=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Journals.Acronyms extends Std.Abbreviations.Acronyms, so Std has to be
# present on the StylesPath -- present, not enabled, as sync leaves it. CI
# checks it out beside this repository; locally the sibling clone serves.
vale=${VALE:-vale}
std=${STD:-$root/../Std/Std}
if [ ! -d "$std" ]; then
	echo "FAIL: Std not found at '$std'; set STD to a checkout's style directory" >&2
	exit 1
fi

# Typst goes through typst2vast, which Vale calls but does not ship.
if ! command -v typst2vast >/dev/null 2>&1; then
	echo "FAIL: typst2vast not found; cargo install --locked typst2vast" >&2
	exit 1
fi

cp -R "$root/Journals/styles" "$work/styles"
cp -R "$std" "$work/styles/Std"
sed "s|^StylesPath = .*|StylesPath = $work/styles|" "$root/.vale.ini" > "$work/.vale.ini"
mkdir -p "$root/testdata"

# The in-source cases. An isolated case resolves a parent through the
# configuration's StylesPath, which is why the assembled copy runs them.
(cd "$work" && "$vale" test styles) || status=1

# Alerts that share a line and column come back in whatever order the checks
# ran, and that order is not part of the contract. Sorting compares the set.
run() { # <fixture path, relative to root> -> alerts on stdout, sorted
	(cd "$root" && "$vale" --config "$work/.vale.ini" --output=line --no-global "$1" 2>&1 || true) |
		sort -t: -k2,2n -k3,3n -k4,4
}

for f in trial.md review.qmd article.Rmd notebook.ipynb trial.typ; do
	golden=$root/testdata/$f.txt
	got=$(run "fixtures/$f")
	if [ "$update" -eq 1 ]; then
		printf '%s\n' "$got" > "$golden"
	elif [ ! -f "$golden" ]; then
		echo "FAIL $f: no golden file; run ./test.sh -u"
		status=1
	elif [ "$got" != "$(cat "$golden")" ]; then
		echo "FAIL $f"
		printf '%s\n' "$got" | diff -u "$golden" - || true
		status=1
	else
		echo "ok   $f ($(printf '%s' "$got" | grep -c . || true) alerts)"
	fi

	clean=$(run "fixtures/clean/$f")
	if [ -n "$clean" ]; then
		echo "FAIL clean/$f: the rewrite still violates the style"
		printf '%s\n' "$clean"
		status=1
	else
		echo "ok   clean/$f (clean)"
	fi
done

# Every rule has a case that expects an alert. A case that wants nothing
# proves nothing on its own.
missing=$(cd "$root/Journals/styles" && for f in $(find . -name '*.yml' ! -path './config/*' | sort); do
	if ! grep -q '^tests:' "$f" || ! sed -n '/^tests:/,$p' "$f" | grep -qE '^    (want: \|$|contains:)'; then
		echo "$f" | sed 's|^\./||; s|/|.|; s|\.yml$||'
	fi
done)
if [ -n "$missing" ]; then
	echo "FAIL coverage: no case expects an alert from these rules"
	printf '%s\n' "$missing" | sed 's/^/       /'
	status=1
else
	n=$(cd "$root/Journals/styles" && find . -name '*.yml' ! -path './config/*' | wc -l | tr -d ' ')
	echo "ok   coverage ($n rules, every one exercised)"
fi

[ "$update" -eq 1 ] && echo "golden files rewritten"
exit $status
