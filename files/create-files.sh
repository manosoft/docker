die () {
    printf >&2 "$@"
    exit 1
}

#Number of directories
ndir=$1
#Number of files
fil=$2
#Size of files
siz=$3
# Directory in which files needs to be created
dname=$4

[ "$#" -eq 4 ] || die "4 arguments are required, only $# provided\n
Usage: ./create_files.sh <no-of-dirs> <no-of-files> <size-of-file-500k-multiplier> <directory>
Example 1 ./create_files.sh 10 20 2 /var/lib/www/html
\tCreates 10 directories with 20 files each of size in [400k-1M] - Total data < 200M
Example 2 ./create_files.sh 10 20 1 /var/lib/www/html
\tCreates 10 directories with 20 files each of size in [200k-500k] - Total data < 100M
Example 3 ./create_files.sh 10 20 10 /var/lib/www/html
\tCreates 10 directories with 20 files each of size in [2M-5M] - Total data < 1000M
\nNOTE: All file sizes are random
"

if [ -e $dname/.created ]
then
        echo "Files already created."
        echo "Delete file \"$dname/.created\" and run again"
        exit 0
fi

echo "This will generate a maximum of $((ndir * fil * siz / 2)) MB of data in $dname, starting in 5 secs"
sleep 5

touch $dname/.created

#number of directories
for i in `seq $ndir`
do
        dirname=$dname/`date +%Y-%m-%d_%H-%M-%S-%3N`-$i
        mkdir $dirname
        #number of files in each directory
        for j in `seq $fil`
        do
                fname=`echo $RANDOM-$RANDOM-$RANDOM`
                # size of each file, randomly creating files with size of [800k - 1200k]
                for k in `seq $siz`
                do
                        shuf -n`shuf -n1 -i 20000-50000` /usr/share/dict/words >> $dirname/$fname.txt
                done
                clear;echo "PROGRESS : In directory $i/$ndir : Creating File $j/$fil"
        done
done
exit 0
