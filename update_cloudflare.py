# %%
import os
import sys

sys.path.append(os.getcwd())


import re
import time
from tqdm import tqdm
from rich import print as pprint


#
#! read pubspec.yaml
content = ""
with open("pubspec.yaml", "r", encoding="utf-8") as f:
    content = f.read()


#! find the current build number
build_match = re.search(r"version: (\d+).(\d+).(\d+)\+(\d+)", content)
if build_match:

    major = int(build_match.group(1))
    # print(f"major : {major}")

    minor = int(build_match.group(2))
    # print(f"minor : {minor}")

    patch = int(build_match.group(3))
    # print(f"patch : {patch}")

    old_build_num = int(build_match.group(4))
    new_build_num = old_build_num + 1
    # print(f"build_num : {build_num} -> new_build_num : {new_build_num}")

    # update the build number in pubspec.yaml content
    new_content = re.sub(
        r"version: (\d+)\.(\d+)\.(\d+)\+(\d+)",
        f"version: {build_match.group(1)}.{build_match.group(2)}.{build_match.group(3)}+{new_build_num}",
        content,
    )
    # print(new_content)

    # write back to env.dart
    with open("pubspec.yaml", "w", encoding="utf-8") as f:
        f.write(new_content)

print(f"{old_build_num} -> {new_build_num}")

#! clean
os.system("flutter clean")

# build web release
# os.system("flutter build web --release --base-href /")
# os.system("flutter build web --release --base-href /app/ --output=build/github --no-wasm-dry-run")

#! build for cloudflare
os.system("flutter build web --release --base-href / --output=build/cloudflare --no-wasm-dry-run")

#! build for github
# os.system(f"flutter build web --release --base-href /{os.path.basename(os.getcwd())}/ --output=build/github --no-wasm-dry-run")


#! delay for 10 seconds
for _ in tqdm(range(100)):
    time.sleep(0.1)


#! git commit and push
os.system("git add .")
os.system(f'git commit -m "update"')
os.system("git push")


print("Done!")
