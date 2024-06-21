#!/bin/python3

# This script generates a buildlist for catkin config
# Input: List of top-level packages to build
# Output: List of packages to build

import argparse
import re
from subprocess import check_output
from typing import Set

def generate_dependencies(package_name: str) -> Set[str]:
    deps_raw = check_output(["catkin", "list", "--rdeps", "-u", package_name])
    dependencies = re.findall(r'(?<=- ).*?(?=\n|$)', deps_raw.decode())
    dependencies = set(dependencies)
    return dependencies

def main():
    parser = argparse.ArgumentParser(description="Generate a buildlist for catkin config")
    parser.add_argument("packages", nargs="+", help="List of top-level packages to build")
    parser.add_argument("--workspace", default=".", help="Path to the catkin workspace")
    args = parser.parse_args()
    top_level_packages = args.packages
    
    all_build_packages = set()
    for pkg in top_level_packages:
        all_build_packages |= generate_dependencies(pkg)
    all_build_packages = sorted(all_build_packages)    
    print(" ".join(all_build_packages).lstrip())

if __name__ == "__main__":
    main()