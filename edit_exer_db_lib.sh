#!/bin/bash

EXER_NAME=
MIN_REPS= 
MAX_REPS=

to_lower() {
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

get_description()
{
   local description_file_name="$1"
   if [ -e "${description_file_name}" ]
   then
      exit 1
   fi

   # create the exercise description file
   echo > "${EXER_DB}/${description_file_name}"
   
   echo "Type the exercise description (press ctrl-d to submit?)."
   while read -r user_line
   do
      echo "$user_line" >> "${EXER_DB}/${description_file_name}"
      fmt "${EXER_DB}/${description_file_name}" > /tmp/exer.tmp
      mv /tmp/exer.tmp "${EXER_DB}/${description_file_name}" 
   done
}

set_exer_name() 
{
  while true
  do
     echo -n "Exercise name: "
     read -r name_input

     local exer_name=`to_lower "$name_input"`

     if [ -n "$exer_name" ]
     then
        EXER_NAME="$exer_name"
        break
     fi
  done
}

set_exer_min_reps() 
{
  while true
  do
     echo -n "Min reps: "
     read -r rep_input

     if [[ "$rep_input" =~ ^[1-9][0-9]*$ ]]
     then
        MIN_REPS="$rep_input"
        break
     fi
  done
}

set_exer_max_reps() 
{
  while true
  do
     echo -n "Max reps: "
     read -r rep_input

     if [[ "$rep_input" =~ ^[1-9][0-9]*$ ]]
     then
        if [ $rep_input -gt $MIN_REPS ]
        then
           MAX_REPS="$rep_input"
           break
        fi
     fi
  done
}

add_exer()
{
   set_exer_name
   set_exer_min_reps
   set_exer_max_reps

   description_file_name=`echo "${EXER_NAME}"     \
                         | sed 's/[[:space:]]/_/g' \
                         | sed 's/$/\.exer/'`
   echo "Rep units? (second, minute, hour, rep): "
   read type
   get_description "${description_file_name}"

   echo "${EXER_NAME},"             \
        "${MIN_REPS},"              \
        "${MAX_REPS},"              \
        "${description_file_name}," \
        "${type},"                  \
        >> ${EXER_LIST}  

   sort "${EXER_LIST}" > "${EXER_LIST}.tmp"
   mv  "${EXER_LIST}.tmp" "${EXER_LIST}"
}
