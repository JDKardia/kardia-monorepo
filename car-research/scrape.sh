#!/usr/bin/env bash
set -euo pipefail

CACHE_LOC="new_file_cache"
EDMUNDS_BASE="https://www.edmunds.com/gateway/api"
AUTOTRADER_BASE="https://www.autotrader.com/rest/searchresults/base?"
call-w-headers() {
	curl "$1" \
		--compressed \
		-H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0" \
		-H"Referer: https://www.edmunds.com/car-comparisons/"
}
YEARS=({2018..2023})

# make the files
START=$(mktemp -t start-XXXX) ## signals the workers are starting
FIFO=$(mktemp -t fifo-XXXX)   ## the queue
LOCK=$(mktemp -t lock-XXXX)   ## the lock file.

## mktemp makes a regular file. Delete that an make a fifo.
rm $FIFO
mkfifo $FIFO
echo $FIFO

rep() {
  i=$1
  data=$2
  ## run the replicate ....
}



## create a trap to cleanup on exit if we fail in the middle.
cleanup() {
  rm $FIFO
  rm $START
  rm $LOCK
}
trap cleanup 0

worker() {
  local fifo lock
  ID=$1 ## worker name
  fifo=3
  lock=4

  ## open fifo and locks
  exec $fifo<$FIFO
  exec $lock<$LOCK
  ## signal the worker has started.
  flock 4 # obtain the lock
  echo $ID >> $START
  flock -u 4
  while true; do
    flock $lock # obtain the lock
    read -st .2 -u $fifo data i ## read one line from fd 3 (the fifo)
    read_status=$?
    flock -u $lock ## release the lock
    ## check the line read.
    if [[ $read_status -eq 0 ]]; then
      # got a work item. do the work
      echo $ID got data=$data i=$i
      rep $i $data
    elif [[ $read_status -gt 128 ]]; then
      # a read_status > 128 means a timeout. on the FIFO read.
      # This means there should be a retry.
      continue
    else
      # a non-zero read status <= 128 means an EOF. actual status
      # is likely 1 but this is undocumented. In anycase the FIFO
      # is now closed on the write side an we can break out of the
      # loop.
      break
    fi
  done
  # clean up the fd(s)
  exec $fifo<&-
  exec $lock<&-
  echo $ID "done working"
}

## Start the workers.
WORKERS=4
for ((i=1;i<=$WORKERS;i++)); do
  echo will start $i
  work $i &
done

## Open the fifo for writing. This lets the workers start. Otherwise
## they will block on waiting for the producer to make the first
## item which causes wierd race conditions among them.
exec 3>$FIFO

## Wait for them to actually open their files.
while true; do
  echo waiting $(wc -l $START)
  if [[ "$(wc -l $START | cut -d \  -f 1)" -eq $WORKERS ]]; then
    echo ok starting producer $(wc -l $START)
    break
  else
    sleep 1
  fi
done

## Produce the jobs to run. In this case run 10 replicates of each
## dataset in the list.
for data in {dataset-A,dataset-B,dataset-C,dataset-D}; do
  for i in {1..10}; do
    echo "sending $data $i"
    echo $data $i 1>&3
  done
done
exec 3<&-
trap '' 0
## It is safe to delete the files because the workers
## already opened them. Thus, only the names are going away
## the actual files will stay there until the workers
## all finish.
cleanup
## now wait for all the workers.
wait

# get-makes-per-year(){
# for $year in 
# }
# get-models-for-make(){
# true
# }
# get-makes-per-year(){
# true
# }
# get-makes-per-year(){
# true
# }
# get-makes-per-year(){
# true
# }

main(){
echo $YEAR
echo "${YEAR[@]}"
}
main "$@"
