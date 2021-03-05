# EXERCISES

This is a script that generates random exercises with rep numbers. It takes these exercises from a file that can be maintained by the user through some commands that I put in here.

# Installation

### Clone this repository:
```
git clone 
```


### make the script executable:
```
chmod u+x exer
```

### Now run the script!
```
./exer 
```

## if you want to use this script as a command, do the following:

### Edit the **exer** file and go to the line that says **EXER_DB**. Here, change the value after the equals to the directory where you downloaded this code (or where you want to keep it).

```
EXER_DB="~/some/path"
```

### Now, copy the exer file and put it in the folder where you store all your other executables. It is usually something like the following:

```
cp exer ~/bin
```

### if that is not in the execution path for your shell, then you can grab one of the paths in between colons that result from the following command:

```
echo $PATH
```
