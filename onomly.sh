#!/usr/bin/env bash
# Product-name availability check: package registries, GitHub, domains.
# Usage: onomly.sh <name> [name2 ...]
set -u

check() { curl -sL -o /dev/null -w "%{http_code}" -A "onomly-skill" --max-time 10 "$1"; }

# 404 = nobody owns it, 200 = taken
registry() {
  case "$(check "$1")" in
    404) echo "AVAILABLE";;
    200) echo "taken";;
    *)   echo "unknown";;
  esac
}

domain_check() {
  local d="$1" code w
  code=$(check "https://rdap.org/domain/$d")
  if [ "$code" = "200" ]; then
    echo "registered (RDAP)"
    return
  fi
  # RDAP said available (404) or failed: some ccTLD RDAP servers (.io, .ai)
  # give false negatives, so confirm the dangerous direction with whois.
  w=$(whois "$d" 2>/dev/null)
  if echo "$w" | grep -qiE "registrar:|creation date:"; then
    echo "registered (whois)"
  elif echo "$w" | grep -qiE "no match|not found|no object found|is available"; then
    echo "AVAILABLE (whois)"
  elif [ "$code" = "404" ]; then
    echo "AVAILABLE (RDAP; whois unclear)"
  else
    echo "unknown (rdap=$code)"
  fi
}

for raw in "$@"; do
  name=$(echo "$raw" | tr '[:upper:]' '[:lower:]')
  echo "=== $raw (lookup key: $name) ==="
  printf "npm          %s\n" "$(registry "https://registry.npmjs.org/$name")"
  printf "crates.io    %s\n" "$(registry "https://crates.io/api/v1/crates/$name")"
  printf "PyPI         %s\n" "$(registry "https://pypi.org/pypi/$name/json")"
  printf "RubyGems     %s\n" "$(registry "https://rubygems.org/api/v1/gems/$name.json")"
  printf "Homebrew     %s\n" "$(registry "https://formulae.brew.sh/api/formula/$name.json")"
  printf "GitHub       %s\n" "$(registry "https://api.github.com/users/$name")"
  for tld in com ai io dev org; do
    printf "%-12s %s\n" ".$tld" "$(domain_check "$name.$tld")"
  done
  echo
done
