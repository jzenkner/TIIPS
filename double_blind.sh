#!/bin/bash

echo "🔍 Searching for identifying info (excluding notebooks and images)..."

# Search while excluding notebooks and common image formats
grep -rEi --exclude="*.ipynb" \
          --exclude="*.png" \
          --exclude="*.jpg" \
          --exclude="*.jpeg" \
          --exclude="*.gif" \
          --exclude="*.svg" \
          --exclude-dir=".git" \
          "(janis|jzenkner|tu-|clausthal|ceph)" .

echo "✅ Done. Review flagged lines manually to ensure double-blind compliance."