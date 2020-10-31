#!/bin/bash

while read slug; do
  ln -nfs ~/workspace/${slug} public/${slug}
done < ~/workspace/blogy/script/labs/slugs.txt
