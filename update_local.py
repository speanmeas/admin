import os
import re
import time
import paramiko

from tqdm import tqdm
from dotenv import load_dotenv

# load environment variables
load_dotenv("../server/pro.env")

print(os.getenv("SSH_HOST"))

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

    build_num = int(build_match.group(4))
    new_build_num = build_num + 1
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


# read lib/Environment.dart
with open("lib/Environment.dart", "r", encoding="utf-8") as f:
    env_content = f.read()
# print(env_content)

# change bool is_local = false;  to bool is_local = true;
env_content = re.sub(r"bool is_local = false;", "bool is_local = true;", env_content)

# write back to env.dart
with open("lib/Environment.dart", "w", encoding="utf-8") as f:
    f.write(env_content)


#! clean
# os.system("flutter clean")

#! build
os.system(f"flutter build web --release --base-href / --output=build/local --no-wasm-dry-run")

#! copy
os.system("xcopy build\\local\\* ..\\server\\service\\admin\\local\\ /E /I /Y")


#! delay
for _ in tqdm(range(100)):
    time.sleep(0.1)


#! git commit and push
os.chdir("../server")
os.system("git add .")
os.system('git commit -m "update"')
os.system("git push")
os.chdir("../admin")


#! delay for 10 seconds
for _ in tqdm(range(100), desc="Waiting"):
    time.sleep(0.1)


#! create SSH client
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

#! connect to the server
client.connect(
    hostname=os.getenv("SSH_HOST"),
    port=22,
    username=os.getenv("SSH_USERNAME"),
    password=os.getenv("SSH_PASSWORD"),
)


#! single line commands
command = [
    "cd /root/server",
    "git pull",
    "docker compose -f pro.docker-compose.yml up -d --build admin",  # update admin only
]

#! execute commands
stdin, stdout, stderr = client.exec_command(" && ".join(command))
print(stdout.read().decode())


#! print success message
print("Update successfully!")

#! close the connection
client.close()
#! change bool is_local = false;  to bool is_local = true;
env_content = re.sub(r"bool is_local = true;", "bool is_local = false;", env_content)

#! write back to env.dart
with open("lib/Environment.dart", "w", encoding="utf-8") as f:
    f.write(env_content)


print(f"Built: {build_num} -> {new_build_num}")
