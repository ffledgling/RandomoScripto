usage()
{
    echo "ERROR!"
    echo -e "Usage: $0 <Url of Video>"
    return 0;
}

if [ $# -ne 1 ]
then
    usage;
    exit 1;
fi
echo "Downloading and converting $1"

youtube-dl -x --no-mtime --audio-format mp3 -t $1
echo "Completed conversion"
filename=$(ls -t *mp3| head -1)
echo $filename
sshpass -p 'music' scp "${filename}" mobile@192.168.0.101:~/Music/youtube/Pushed/
sshpass -p 'music' ssh mobile@192.168.0.101 -t "killall -9 play; play ~/Music/youtube/Pushed/'${filename}'"
