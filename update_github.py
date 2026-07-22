import os
import time
from tqdm import tqdm
from rich import print

#! read config file
content_old = ""
with open("lib/__config__.dart", "r", encoding="utf-8") as f:
    content_old = f.read()


#! find and replace
content_new = content_old.replace("bool is_github = false;", "bool is_github = true;")
if content_new != content_old:
    with open("lib/__config__.dart", "w", encoding="utf-8") as f:
        f.write(content_new)


#! clean
# os.system("flutter clean")


#! build for github
os.system("flutter build web --release --base-href /admin/ --output=build/github")


#! delay for 10 seconds
for _ in tqdm(range(100)):
    time.sleep(0.1)


#! git commit and push
os.system("git add .")
os.system(f'git commit -m "update"')
os.system("git push")


with open("lib/__config__.dart", "w", encoding="utf-8") as f:
    f.write(content_old)


print(f"Built and pushed to GitHub successfully!")
