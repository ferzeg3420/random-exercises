#! /bin/bash

#set -x

# including exer_rc.sh and edit exer modules
. "$(dirname "$0")/exer_rc.sh"
. "$(dirname "$0")/edit_exer_db_lib.sh"

# get the name of this executable (script)
EXEC_NAME=${0##*/}
EXEC_NAME=${EXEC_NAME/\//}

# Constants
SUCCESS=0

e_flag=''
a_flag=''
d_flag=''
num_to_display=1

print_usage() 
{
   echo 
   printf "Usage: $EXEC_NAME [-eah] [-d] [-n number] ]\n"
   echo
   echo "Gives you a random number of reps and an exercise to maintain that"
   echo "glorius boody"
   echo
   echo "    -e Edit the exercise file"
   echo "    -a Add an exercise using a helper script"
   echo "    -d Delete an exercise"
   echo "    -n *number* Get multiple exercises"
   echo "    -h Print this page"
}

while getopts 'eadhn:' flag
do
  case "${flag}" 
  in
    e) e_flag='true' ;; # Edit an exercise
    a) a_flag='true' ;; # Add an exercise to the list
    d) d_flag='true' ;; # Get a description along with the exercise
    n) num_to_display="${OPTARG}" ;; # Get multiple exercises
    h) print_usage 
       exit $SUCCESS ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ "$e_flag" = 'true' ]
then
   vim "$EXER_LIST"
   exit $SUCCESS 
fi

if [ "$a_flag" = 'true' ]
then
   add_exer
   exit $SUCCESS 
fi

# exit if num_to_display (number of exercises) is not an integer
(( $num_to_display + 0 )) ||  exit 1

# Preprocess the list of exercises
(sed '/^[ 	]*$/d' $EXER_LIST | sed '/^[ 	]*#/d') >${CLEAN_LIST}

# Get the number of exercises in the list
NUM_WORK_OUTS=`wc -l <${CLEAN_LIST}`

# Create a list with the exercises in random order
(cat ${CLEAN_LIST} | sort -R | head -n ${num_to_display}) >${RAND_LIST}

# Iterate through the list of exercises that is in random order
while read -r line
do
   EXER_NAME=$(echo "$line" | cut -d , -f 1)
   REP_MIN=$(echo "$line" | cut -d , -f 2)
   REP_MAX=$(echo "$line" | cut -d , -f 3)
   DESCRIPTION_FILE=`echo $line      \
                     | cut -d , -f 4 \
                     | sed 's/^[[:space:]][[:space:]]*//'`
   TYPE=`echo "$line"                                      \
                     | cut -d , -f 5                       \
                     | sed 's/[[:space:]][[:space:]]*$//'  \
                     | sed 's/^[[:space:]][[:space:]]*//'`  
   
   # the +1 makes it so that the reps include REP_MAX.
   let "RANDOM_REPS = $RANDOM % ($REP_MAX - $REP_MIN + 1) + $REP_MIN"
   
   if [ $RANDOM_REPS = '1' ]
   then
      # Display the name of the exercise, singular time units
      case "$TYPE" in
      second|minute|hour|day|year|decade|light-year)
         echo "Do a ${EXER_NAME} for 1 ${TYPE}." ;;
      *)
         echo "Do 1 ${EXER_NAME}." ;;
      esac
   else
      # Display the name of the exercise, plural time units
      case "$TYPE" in
      second|minute|hour|day|year|decade|light-year)
         echo "Do a ${EXER_NAME} for ${RANDOM_REPS} ${TYPE}s." ;;
      *)
         echo "Do ${RANDOM_REPS} ${EXER_NAME}s." ;;
      esac
   fi

   if [ "${d_flag}" = 'true' ]
   then
      # show the description if user used the description flag
      echo --------------- Description:
      cat "${EXER_DB}/${DESCRIPTION_FILE}" 
      echo ---------------------------
   fi
done < ${RAND_LIST}

