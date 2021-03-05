# the name where the DB files will be stored.
# Right now it's using the directory of the main exec script
EXER_DB="$(dirname "$0")"

# The actual DB as it were
EXER_LIST="${EXER_DB}/exercises.list"

#Temp files where I'm keeping the randomized lists
CLEAN_LIST=/tmp/clean.tmp
RAND_LIST=/tmp/random_exer_list.tmp
