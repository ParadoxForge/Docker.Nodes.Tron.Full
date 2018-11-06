#docker system prune -a
docker build ./compiler -t tron-compiler
docker run -it --rm -v ${PWD}/compiled:/compiled tron-compiler cp -r ./ /compiled/