import os
import re
import subprocess
from packaging import version

def get_visual_studio_code_versions():
    tags = subprocess.check_output(["git", "ls-remote", "--tags", "git@github.com:microsoft/vscode"]).decode()
    tags = filter(len, tags.split("\n"))
    tags = map(lambda x: x.split("\t")[1], tags)
    tags = map(lambda x: re.search(r"^refs/tags/(([0-9]+.?)+)$", x), tags)
    tags = filter(lambda x: x is not None, tags)
    tags = map(lambda x: x.groups()[0], tags)
    tags = map(lambda x: version.parse(x), tags)
    tags = filter(lambda x: x >= version.parse("1.0.0") and x != version.parse("1.7.0"), tags)
    tags = sorted(tags)
    return [str(tag) for tag in tags]

def get_available_versions(package: str) -> [str]:
    """Return the avaible versions for the given package in the repository."""
    regex = re.compile(package.split("/")[-1] + "-(.*)\.ebuild$")
    files = filter(os.path.isfile, os.scandir(package))
    versions = map(lambda x: regex.search(x.name), files)
    versions = filter(lambda x: x is not None, versions)
    versions = list(map(lambda x: x.groups()[0], versions))
    return versions

def update(package: str):
    package_name = package.split("/")[-1].replace("-", "_")
    if "get_" + package_name + "_versions" not in globals():
        return
    available_versions = get_available_versions(package)
    upstream_version = globals()["get_" + package_name + "_versions"]()
    to_add_versions = list(filter(lambda x: x not in available_versions, upstream_version))
    print("New versions to be added to {}:\n\t{}".format(package_name, "\n\t".join(to_add_versions)))
    for version in to_add_versions:
        os.system("cp {0}/ebuild.sample {0}/{1}-{2}.ebuild".format(package, package.split("/")[-1], version))
        os.system("cd {0} && sudo ebuild {1}-{2}.ebuild manifest".format(package, package.split("/")[-1], version))
    os.system("git add . && git commit -m \"{0}: Added v{1}\"".format(package.split("/")[-1], ", v".join(to_add_versions)))


def main():
    for category in filter(os.path.isdir, os.scandir()):
        for package in filter(os.path.isdir, os.scandir(category)):
            update(package.path)


if __name__ == "__main__":
    main()

