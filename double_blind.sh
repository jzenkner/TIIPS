#!/bin/bash

echo "🔍 Searching for identifying info..."

grep -rEi "(author|name|email|university|clausthal|gmail|tu-|lab|group)" .
grep -rEi "(github|gitlab|http|https|www\.)" .
grep -rE "(/home/|C:\\\\Users\\\\)" .
grep -rE "^#.*(author|email|university)" .
grep -rE "print\(.*(user|author|path|email)" .

echo "✅ Done. Review flagged lines manually to ensure double-blind compliance."
