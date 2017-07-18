while read slug; do
  ln -sfn "~/workspace/${slug}" "public/${slug}"
done < ~/workspace/blogy/script/labs/slugs.txt
