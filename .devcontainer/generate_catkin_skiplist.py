#!/bin/python3

# This script generates a skiplist for catkin config
# Input: List of packages to build
# Output: List of packages to skip

import argparse
import re
from subprocess import check_output

def gererate_dependencies(package_name: str):
    deps_raw = check_output(["catkin", "list", "--rdeps", "-u", package_name])
    dependencies = re.findall(r'(?<=- ).*?(?=\n|$)', deps_raw.decode())
    dependencies = set(dependencies)
    return list(dependencies)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a skiplist for catkin config")
    parser.add_argument("packages", nargs="+", help="List of packages to build")
    parser.add_argument("--workspace", default=".", help="Path to the catkin workspace")
    args = parser.parse_args()
    # Get the list of packages to build
    build_packages = args.packages

    all_packages = check_output(["catkin", "list", "--workspace", args.workspace, "--quiet", "--unformatted"]).decode().split("\n")
    all_packages = set(all_packages)
    
    build_dependencies = []
    for pkg in build_packages:
        build_dependencies += gererate_dependencies(pkg)
    
    all_build_packages = set(build_packages + build_dependencies)
    all_skip_packages = all_packages - all_build_packages
    
    all_skip_packages = sorted(all_skip_packages)

    print(" ".join(all_skip_packages).lstrip())