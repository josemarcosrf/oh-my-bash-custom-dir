#!/bin/bash

say() {
 echo "$@" | sed \
         -e "s/\(\(@\(red\|green\|yellow\|blue\|magenta\|cyan\|white\|reset\|b\|u\)\)\+\)[[]\{2\}\(.*\)[]]\{2\}/\1\4@reset/g" \
         -e "s/@red/$(tput setaf 1)/g" \
         -e "s/@green/$(tput setaf 2)/g" \
         -e "s/@yellow/$(tput setaf 3)/g" \
         -e "s/@blue/$(tput setaf 4)/g" \
         -e "s/@magenta/$(tput setaf 5)/g" \
         -e "s/@cyan/$(tput setaf 6)/g" \
         -e "s/@white/$(tput setaf 7)/g" \
         -e "s/@reset/$(tput sgr0)/g" \
         -e "s/@b/$(tput bold)/g" \
         -e "s/@u/$(tput sgr 0 1)/g"
}

coln() {
  col=$1
  shift
  awk -v col="$col" '{print $col}' "${@--}"
}

now_deployments(){
  # first parameter is the app name
  # second parameter is the row number from where to start printing (latest deployment is in row 2)
  res=$(now ls $1 | coln 2 | tail -n +$2 | tr '\n' ' ')
  printf "\n$res\n\n"
}

docker-compose-restart(){
	docker-compose stop $@
	docker-compose rm -f -v $@
	docker-compose create --force-recreate $@
	docker-compose start $@
}

docker-rmi() {
  pattern=$1
  docker images -a | grep $pattern | awk '{print $3}' | xargs docker rmi $2
}


k8logs () {
  pod_pattrn=$1
  container=$2

  podID=$(kubectl get pods | grep $pod_pattrn | awk '{printf $1}')

  echo "pod pattern: $pod_pattrn"
  echo "pod ID: $podID"
  echo "container: $container"

  if [ ! -z "$container" ]; then
    kubectl logs $podID -c $container
  else
    kubectl logs $podID
  fi
}

restart_pod() {
   pod_name=$1
   kubectl scale deployment $pod_name --replicas=0
   sleep 5
   kubectl scale deployment $pod_name --replicas=1
}

kill_all_dockers() {
  # print only the first column skipping the firt row and
  # apply 'docker kill'
  docker ps | tail -n+2 | awk '{print $1}' | xargs docker kill
}

docks() {
  docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Ports}}"
}

backup_photos() {
    say @blue[["Copying ~/Pictures/Marcos/Olympus to Dropbox:Media/Photos/Olympus"]]
    rclone copy \
        ~/Pictures/Marcos/Olympus \
        'Dropbox:Media/Photos/Olympus' \
        --ignore-existing \
        --include *.ORF \
        --include *.JPG \
        --include *.jpg \
        --include *.pp3 \
        --progress

    say @blue[["Copying ~/Pictures/Marcos/Edited to Dropbox:Media/Photos/Edited"]]
    rclone copy \
        ~/Pictures/Marcos/Edited \
        'Dropbox:Media/Photos/Edited' \
        --ignore-existing \
        --include *.ORF \
        --include *.JPG \
        --include *.jpg \
        --include *.pp3 \
        --progress
}

pfwd() {
  # ssh port forwarding in the background without remote command
  # usage example: pfwd dev-CINT 8888 8889 8080
  for i in ${@:2}
  do
    echo Forwarding port $i
    ssh -f -N -L $i:localhost:$i $1
  done  
}

export -f coln
export -f now_deployments
export -f docker-compose-restart
export -f docker-rmi
export -f k8logs
export -f restart_pod
export -f kill_all_dockers
export -f docks
export -f backup_photos
export -f pfwd

# parse_git_branch() {
#      git branch 2> /dev/null | sed -e '/^[^*]/d ' -e 's/* \(.*\)/(\1) /'
# }
# export PS1="$PS1\[\033[33m\]\$(parse_git_branch)\[\033[00m\]"
