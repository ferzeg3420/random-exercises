#!/bin/bash

get_description()
{
   local description_file_name="$1"
   if [ -e "${description_file_name}" ]
   then
      exit 1
   fi
   echo > "${EXER_DB}/${description_file_name}"
   
   echo "Type the exercise description (press ctrl-d to submit?)."
   while read -r user_line
   do
      echo "$user_line" >> "${EXER_DB}/${description_file_name}"
      fmt "${EXER_DB}/${description_file_name}" > /tmp/exer.tmp
      mv /tmp/exer.tmp "${EXER_DB}/${description_file_name}" 
   done
}

add_exer()
{
   echo "Exercise name:"
   read name_input
   echo "Exercise default min reps:"
   read min_reps
   echo "Exercise default max reps:"
   read max_reps
   description_file_name=`echo "${name_input}"     \
                         | sed 's/[[:space:]]/_/g' \
                         | sed 's/$/\.exer/'`
   echo "Second, minute, hour, rep? (singular): "
   read type
   get_description "${description_file_name}"
#   if [ -e description_file_name ]
#   then
#      exit 1
#   fi
#   echo > "${EXER_DB}/${description_file_name}"
#   
#   echo "Exercise description (press ctrl-d to exit)."
#   while read -r user_line
#   do
#      echo "$user_line" >> "${EXER_DB}/${description_file_name}"
#      fmt "${EXER_DB}/${description_file_name}" > /tmp/exer.tmp
#      mv /tmp/exer.tmp "${EXER_DB}/${description_file_name}" 
#   done

   echo "${name_input},"            \
        "${min_reps},"              \
        "${max_reps},"              \
        "${description_file_name}," \
        "${type},"                  \
        >> ${EXER_LIST}  

   sort "${EXER_LIST}" > "${EXER_LIST}.tmp"
   mv  "${EXER_LIST}.tmp" "${EXER_LIST}"
}
