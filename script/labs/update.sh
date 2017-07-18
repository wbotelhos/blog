cd ~/workspace

while read slug; do
  if [ -d $slug ]; then
    echo -e "\n${GRAY}Pulling ${slug}...${NO_COLOR}"

    cd ~/workspace/${slug}
    git pull origin master
    cd -
  else
    echo -e "\n${GRAY}Cloning ${slug}...${NO_COLOR}"

    git clone "git@github.com:wbotelhos/${slug}.git"
  fi
done < ~/workspace/blogy/script/labs/slugs.txt
