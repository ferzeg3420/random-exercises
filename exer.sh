#! /bin/bash

#set -x

. "$(dirname "$0")/exer_rc.sh"
. "$(dirname "$0")/edit_exer_db_lib.sh"

EXEC_NAME=${0##*/}
EXEC_NAME=${EXEC_NAME/\//}

e_flag=''
a_flag=''
d_flag=''
num_to_display=1

print_usage() 
{
   printf "Usage: $EXEC_NAME [-ea] [-d] [-n [0-9]+ ]\n"
}

while getopts 'eadn:' flag
do
  case "${flag}" 
  in
    e) e_flag='true' ;;
    a) a_flag='true' ;;
    d) d_flag='true' ;;
    n) num_to_display="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ "$e_flag" = 'true' ]
then
   vim "$EXER_LIST"
   exit 0 
fi

if [ "$a_flag" = 'true' ]
then
   add_exer
   exit 0
fi

# exit if num_to_display is not an integer
(( $num_to_display + 0 )) ||  exit 1

(sed '/^[ 	]*$/d' $EXER_LIST | sed '/^[ 	]*#/d') >${CLEAN_LIST}
NUM_WORK_OUTS=`wc -l <${CLEAN_LIST}`
(cat ${CLEAN_LIST} | sort -R | head -n ${num_to_display}) >${RAND_LIST}

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
      case "$TYPE" in
      second|minute|hour|day|year|decade|light-year)
         echo "Do a ${EXER_NAME} for 1 ${TYPE}." ;;
      *)
         echo "Do 1 ${EXER_NAME}." ;;
      esac
   else
      case "$TYPE" in
      second|minute|hour|day|year|decade|light-year)
         echo "Do a ${EXER_NAME} for ${RANDOM_REPS} ${TYPE}s." ;;
      *)
         echo "Do ${RANDOM_REPS} ${EXER_NAME}s." ;;
      esac
   fi

   if [ "${d_flag}" = 'true' ]
   then
      echo --------------- Description:
      cat "${EXER_DB}/${DESCRIPTION_FILE}" 
      echo ---------------------------
   fi
done < ${RAND_LIST}

