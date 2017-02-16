#!/bin/sh

usage () {
    cat <<__EOF__
usage: $(basename $0) [-hlp] [-u user] [-X args] [-d args]
  -h        print this help text
  -l        print list of files to download
  -p        prompt for password
  -u user   download as a different user
  -X args   extra arguments to pass to xargs
  -d args   extra arguments to pass to the download program

__EOF__
}

username=lroutledge
xargsopts=
prompt=
list=
while getopts hlpu:xX:d: option
do
    case $option in
    h)  usage; exit ;;
    l)  list=yes ;;
    p)  prompt=yes ;;
    u)  prompt=yes; username="$OPTARG" ;;
    X)  xargsopts="$OPTARG" ;;
    d)  download_opts="$OPTARG";;
    ?)  usage; exit 2 ;;
    esac
done

if test -z "$xargsopts"
then
   #no xargs option speficied, we ensure that only one url
   #after the other will be used
   xargsopts='-L 1'
fi

if [ "$prompt" != "yes" ]; then
   # take password (and user) from netrc if no -p option
   if test -f "$HOME/.netrc" -a -r "$HOME/.netrc"
   then
      grep -ir "dataportal.eso.org" "$HOME/.netrc" > /dev/null
      if [ $? -ne 0 ]; then
         #no entry for dataportal.eso.org, user is prompted for password
         echo "A .netrc is available but there is no entry for dataportal.eso.org, add an entry as follows if you want to use it:"
         echo "machine dataportal.eso.org login lroutledge password _yourpassword_"
         prompt="yes"
      fi
   else
      prompt="yes"
   fi
fi

if test -n "$prompt" -a -z "$list"
then
    trap 'stty echo 2>/dev/null; echo "Cancelled."; exit 1' INT HUP TERM
    stty -echo 2>/dev/null
    printf 'Password: '
    read password
    echo ''
    stty echo 2>/dev/null
fi

# use a tempfile to which only user has access 
tempfile=`mktemp /tmp/dl.XXXXXXXX 2>/dev/null`
test "$tempfile" -a -f $tempfile || {
    tempfile=/tmp/dl.$$
    ( umask 077 && : >$tempfile )
}
trap 'rm -f $tempfile' EXIT INT HUP TERM

echo "auth_no_challenge=on" > $tempfile
if [ -n "$prompt" ]; then
   echo "--http-user=$username" >> $tempfile
   echo "--http-password=$password" >> $tempfile

fi
WGETRC=$tempfile; export WGETRC

unset password

if test -n "$list"
then cat
else xargs $xargsopts wget --no-check-certificate $download_opts
fi <<'__EOF__'
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:41:14.494/KMOS.2016-10-02T18:41:14.494.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:29:59.875/KMOS.2016-10-16T10:29:59.875.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:51:03.999/KMOS.2016-10-10T09:51:03.999.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:26:07.643.NL/KMOS.2016-10-07T10:26:07.643.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:10:33.451.NL/KMOS.2016-10-17T10:10:33.451.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:16:05.617.NL/KMOS.2016-10-18T10:16:05.617.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:31:46.452.NL/KMOS.2016-10-08T12:31:46.452.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:04:10.875/KMOS.2016-10-12T10:04:10.875.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:19:38.766/KMOS.2016-10-28T09:19:38.766.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:14:18.063/KMOS.2016-10-14T11:14:18.063.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:25:06.834.NL/KMOS.2016-10-27T09:25:06.834.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:16:05.617/KMOS.2016-10-18T10:16:05.617.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:00:50.624/KMOS.2016-10-02T10:00:50.624.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:13:09.608.NL/KMOS.2016-10-14T11:13:09.608.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:44:15.665/KMOS.2016-10-29T09:44:15.665.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:19:46.355/KMOS.2016-10-25T09:19:46.355.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-01T23:54:23.139/KMOS.2016-10-01T23:54:23.139.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:27:15.694.NL/KMOS.2016-10-07T10:27:15.694.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:27:15.120/KMOS.2016-10-08T12:27:15.120.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:15:26.052/KMOS.2016-10-14T11:15:26.052.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:29:30.440.NL/KMOS.2016-10-08T12:29:30.440.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:31:45.500/KMOS.2016-10-26T09:31:45.500.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:27:15.120.NL/KMOS.2016-10-08T12:27:15.120.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:49:56.790.NL/KMOS.2016-10-10T09:49:56.790.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:28:22.497/KMOS.2016-10-07T10:28:22.497.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:48:01.375/KMOS.2016-10-24T09:48:01.375.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T16:00:37.137/KMOS.2016-10-21T16:00:37.137.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:08:37.034/KMOS.2016-10-13T10:08:37.034.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:08:37.034.NL/KMOS.2016-10-13T10:08:37.034.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:23:39.909/KMOS.2016-10-09T10:23:39.909.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:56:39.819.NL/KMOS.2016-10-04T09:56:39.819.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-23T09:51:44.789/KMOS.2016-10-23T09:51:44.789.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:46:29.397/KMOS.2016-10-29T09:46:29.397.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:59:13.679/KMOS.2016-10-11T09:59:13.679.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:20:46.747/KMOS.2016-10-28T09:20:46.747.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:59:29.139.NL/KMOS.2016-10-21T15:59:29.139.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:56:39.819/KMOS.2016-10-04T09:56:39.819.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:58:44.929/KMOS.2016-10-06T09:58:44.929.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:05:18.973/KMOS.2016-10-12T10:05:18.973.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:54:15.013/KMOS.2016-10-15T08:54:15.013.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:55:49.612.NL/KMOS.2016-10-11T09:55:49.612.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:54:23.770/KMOS.2016-10-04T09:54:23.770.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:40:06.556/KMOS.2016-10-02T18:40:06.556.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:35:52.745.NL/KMOS.2016-10-30T09:35:52.745.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:28:49.210.NL/KMOS.2016-10-02T18:28:49.210.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:22:02.752/KMOS.2016-10-25T09:22:02.752.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:21:44.006/KMOS.2016-10-27T09:21:44.006.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:37:00.723/KMOS.2016-10-30T09:37:00.723.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:50:02.539.NL/KMOS.2016-10-21T09:50:02.539.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:32:53.474/KMOS.2016-10-26T09:32:53.474.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:13:09.608/KMOS.2016-10-14T11:13:09.608.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:53:18.852/KMOS.2016-10-10T09:53:18.852.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:55:49.612/KMOS.2016-10-11T09:55:49.612.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:35:08.280/KMOS.2016-10-26T09:35:08.280.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:29:59.875.NL/KMOS.2016-10-16T10:29:59.875.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-01T23:49:52.352/KMOS.2016-10-01T23:49:52.352.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:51:59.017.NL/KMOS.2016-10-15T08:51:59.017.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:53:16.174.NL/KMOS.2016-10-04T09:53:16.174.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:08:23.774.NL/KMOS.2016-10-03T10:08:23.774.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-20T09:52:30.925/KMOS.2016-10-20T09:52:30.925.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:55:16.945.NL/KMOS.2016-11-01T09:55:16.945.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:05:20.389/KMOS.2016-10-02T10:05:20.389.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:24:47.845/KMOS.2016-10-09T10:24:47.845.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:53:16.174/KMOS.2016-10-04T09:53:16.174.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:58:21.124/KMOS.2016-10-21T15:58:21.124.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:45:56.750.NL/KMOS.2016-10-21T15:45:56.750.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:08:43.958/KMOS.2016-10-12T10:08:43.958.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:53:00.844/KMOS.2016-11-01T09:53:00.844.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-19T09:50:47.381/KMOS.2016-10-19T09:50:47.381.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:14:18.063.NL/KMOS.2016-10-14T11:14:18.063.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:53:00.844.NL/KMOS.2016-11-01T09:53:00.844.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:48:48.880/KMOS.2016-10-10T09:48:48.880.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:07:29.100.NL/KMOS.2016-10-13T10:07:29.100.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:06:21.103.NL/KMOS.2016-10-13T10:06:21.103.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:23:01.552/KMOS.2016-10-28T09:23:01.552.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:56:05.040/KMOS.2016-10-21T15:56:05.040.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:53:18.852.NL/KMOS.2016-10-10T09:53:18.852.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:24:47.845.NL/KMOS.2016-10-09T10:24:47.845.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:54:23.770.NL/KMOS.2016-10-04T09:54:23.770.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:51:22.823.NL/KMOS.2016-10-22T09:51:22.823.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:52:18.560.NL/KMOS.2016-10-21T09:52:18.560.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:56:57.662.NL/KMOS.2016-10-11T09:56:57.662.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:45:22.564.NL/KMOS.2016-10-29T09:45:22.564.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:52:32.259/KMOS.2016-10-24T09:52:32.259.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:18:21.644.NL/KMOS.2016-10-18T10:18:21.644.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:38:08.727.NL/KMOS.2016-10-30T09:38:08.727.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:25:28.788/KMOS.2016-10-16T10:25:28.788.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:49:06.749.NL/KMOS.2016-10-22T09:49:06.749.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:04:12.369.NL/KMOS.2016-10-02T10:04:12.369.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:27:03.770/KMOS.2016-10-09T10:27:03.770.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-20T09:53:38.915/KMOS.2016-10-20T09:53:38.915.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:23:58.812/KMOS.2016-10-27T09:23:58.812.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:48:54.483/KMOS.2016-10-21T09:48:54.483.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:23:01.552.NL/KMOS.2016-10-28T09:23:01.552.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:25:06.834/KMOS.2016-10-27T09:25:06.834.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:23:10.762/KMOS.2016-10-25T09:23:10.762.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:27:43.840.NL/KMOS.2016-10-16T10:27:43.840.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:30:38.442/KMOS.2016-10-08T12:30:38.442.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:51:59.017/KMOS.2016-10-15T08:51:59.017.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:56:57.662/KMOS.2016-10-11T09:56:57.662.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:44:15.665.NL/KMOS.2016-10-29T09:44:15.665.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:51:03.999.NL/KMOS.2016-10-10T09:51:03.999.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:27:43.840/KMOS.2016-10-16T10:27:43.840.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:50:14.852.NL/KMOS.2016-10-22T09:50:14.852.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:47:37.531.NL/KMOS.2016-10-29T09:47:37.531.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:05:14.359.NL/KMOS.2016-10-13T10:05:14.359.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:06:27.498.NL/KMOS.2016-10-12T10:06:27.498.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:47:46.527.NL/KMOS.2016-10-21T09:47:46.527.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:56:25.003/KMOS.2016-11-01T09:56:25.003.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:20:54.751/KMOS.2016-10-25T09:20:54.751.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:57:36.957.NL/KMOS.2016-10-06T09:57:36.957.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:18:38.364/KMOS.2016-10-25T09:18:38.364.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:27:15.694/KMOS.2016-10-07T10:27:15.694.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:26:35.842.NL/KMOS.2016-10-16T10:26:35.842.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:06:01.299.NL/KMOS.2016-10-17T10:06:01.299.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:47:37.531/KMOS.2016-10-29T09:47:37.531.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:09:31.764.NL/KMOS.2016-10-03T10:09:31.764.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:12:02.285.NL/KMOS.2016-10-14T11:12:02.285.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:07:09.320.NL/KMOS.2016-10-17T10:07:09.320.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:23:39.909.NL/KMOS.2016-10-09T10:23:39.909.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:04:06.350.NL/KMOS.2016-10-13T10:04:06.350.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:46:29.397.NL/KMOS.2016-10-29T09:46:29.397.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:23:58.812.NL/KMOS.2016-10-27T09:23:58.812.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:28:23.599/KMOS.2016-10-08T12:28:23.599.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-19T09:53:02.187/KMOS.2016-10-19T09:53:02.187.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:19:46.355.NL/KMOS.2016-10-25T09:19:46.355.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:40:42.821/KMOS.2016-10-05T09:40:42.821.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:34:44.733/KMOS.2016-10-30T09:34:44.733.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:40:42.821.NL/KMOS.2016-10-05T09:40:42.821.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:50:17.362.NL/KMOS.2016-10-24T09:50:17.362.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-20T09:55:53.664/KMOS.2016-10-20T09:55:53.664.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:54:15.013.NL/KMOS.2016-10-15T08:54:15.013.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:41:50.742/KMOS.2016-10-05T09:41:50.742.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:07:35.921.NL/KMOS.2016-10-12T10:07:35.921.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:00:50.624.NL/KMOS.2016-10-02T10:00:50.624.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:37:00.723.NL/KMOS.2016-10-30T09:37:00.723.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:48:45.587.NL/KMOS.2016-10-29T09:48:45.587.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:58:21.124.NL/KMOS.2016-10-21T15:58:21.124.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:24:09.531/KMOS.2016-10-28T09:24:09.531.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:57:36.957/KMOS.2016-10-06T09:57:36.957.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:23:51.643/KMOS.2016-10-07T10:23:51.643.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:01:57.438.NL/KMOS.2016-10-02T10:01:57.438.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:09:31.764/KMOS.2016-10-03T10:09:31.764.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:59:29.139/KMOS.2016-10-21T15:59:29.139.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T10:00:20.442/KMOS.2016-10-11T10:00:20.442.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:30:37.531.NL/KMOS.2016-10-26T09:30:37.531.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:53:38.934/KMOS.2016-10-22T09:53:38.934.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:54:08.905.NL/KMOS.2016-11-01T09:54:08.905.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-19T09:55:18.157/KMOS.2016-10-19T09:55:18.157.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:49:09.420/KMOS.2016-10-24T09:49:09.420.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-19T09:51:55.384/KMOS.2016-10-19T09:51:55.384.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:15:26.052.NL/KMOS.2016-10-14T11:15:26.052.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:20:46.747.NL/KMOS.2016-10-28T09:20:46.747.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:07:15.876/KMOS.2016-10-03T10:07:15.876.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:49:09.420.NL/KMOS.2016-10-24T09:49:09.420.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:16:34.052.NL/KMOS.2016-10-14T11:16:34.052.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:23:10.762.NL/KMOS.2016-10-25T09:23:10.762.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:45:56.750/KMOS.2016-10-21T15:45:56.750.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:12:02.285/KMOS.2016-10-14T11:12:02.285.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T16:00:37.137.NL/KMOS.2016-10-21T16:00:37.137.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:22:02.752.NL/KMOS.2016-10-25T09:22:02.752.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:26:35.842/KMOS.2016-10-16T10:26:35.842.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:52:30.856.NL/KMOS.2016-10-22T09:52:30.856.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:48:45.587/KMOS.2016-10-29T09:48:45.587.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-01T23:53:16.356/KMOS.2016-10-01T23:53:16.356.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:50:51.103/KMOS.2016-10-15T08:50:51.103.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:35:52.745/KMOS.2016-10-30T09:35:52.745.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:28:51.827.NL/KMOS.2016-10-16T10:28:51.827.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:23:51.643.NL/KMOS.2016-10-07T10:23:51.643.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:52:18.560/KMOS.2016-10-21T09:52:18.560.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:58:44.929.NL/KMOS.2016-10-06T09:58:44.929.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:29:30.440/KMOS.2016-10-08T12:29:30.440.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:21:53.614/KMOS.2016-10-28T09:21:53.614.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:08:43.958.NL/KMOS.2016-10-12T10:08:43.958.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:38:08.727/KMOS.2016-10-30T09:38:08.727.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:24:59.634/KMOS.2016-10-07T10:24:59.634.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T10:00:20.442.NL/KMOS.2016-10-11T10:00:20.442.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:34:44.733.NL/KMOS.2016-10-30T09:34:44.733.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:48:54.483.NL/KMOS.2016-10-21T09:48:54.483.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-19T09:54:10.157/KMOS.2016-10-19T09:54:10.157.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:34:00.283/KMOS.2016-10-26T09:34:00.283.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:19:29.548.NL/KMOS.2016-10-18T10:19:29.548.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:57:13.080.NL/KMOS.2016-10-21T15:57:13.080.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:35:08.280.NL/KMOS.2016-10-26T09:35:08.280.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:08:17.279/KMOS.2016-10-17T10:08:17.279.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:50:14.852/KMOS.2016-10-22T09:50:14.852.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:31:46.452/KMOS.2016-10-08T12:31:46.452.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:42:22.500/KMOS.2016-10-02T18:42:22.500.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:42:58.846.NL/KMOS.2016-10-05T09:42:58.846.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:07:15.876.NL/KMOS.2016-10-03T10:07:15.876.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:26:07.643/KMOS.2016-10-07T10:26:07.643.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:05:18.973.NL/KMOS.2016-10-12T10:05:18.973.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:58:05.682/KMOS.2016-10-11T09:58:05.682.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:06:07.889.NL/KMOS.2016-10-03T10:06:07.889.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:08:23.774/KMOS.2016-10-03T10:08:23.774.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:18:38.364.NL/KMOS.2016-10-25T09:18:38.364.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:38:58.565/KMOS.2016-10-02T18:38:58.565.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:45:15.164.NL/KMOS.2016-10-05T09:45:15.164.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:30:38.442.NL/KMOS.2016-10-08T12:30:38.442.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:24:09.531.NL/KMOS.2016-10-28T09:24:09.531.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:17:13.625/KMOS.2016-10-18T10:17:13.625.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:09:25.301/KMOS.2016-10-17T10:09:25.301.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:56:25.003.NL/KMOS.2016-11-01T09:56:25.003.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:42:22.500.NL/KMOS.2016-10-02T18:42:22.500.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:55:16.945/KMOS.2016-11-01T09:55:16.945.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:06:21.103/KMOS.2016-10-13T10:06:21.103.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:03:04.274.NL/KMOS.2016-10-02T10:03:04.274.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:59:53.053/KMOS.2016-10-06T09:59:53.053.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-23T09:52:52.794/KMOS.2016-10-23T09:52:52.794.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:28:22.497.NL/KMOS.2016-10-07T10:28:22.497.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:50:17.362/KMOS.2016-10-24T09:50:17.362.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:57:13.080/KMOS.2016-10-21T15:57:13.080.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:30:37.531/KMOS.2016-10-26T09:30:37.531.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:19:38.766.NL/KMOS.2016-10-28T09:19:38.766.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:51:24.204/KMOS.2016-10-24T09:51:24.204.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:07:09.320/KMOS.2016-10-17T10:07:09.320.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:56:29.530/KMOS.2016-10-06T09:56:29.530.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-29T09:45:22.564/KMOS.2016-10-29T09:45:22.564.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:21:44.006.NL/KMOS.2016-10-27T09:21:44.006.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:27:03.770.NL/KMOS.2016-10-09T10:27:03.770.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:57:48.379/KMOS.2016-10-04T09:57:48.379.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:25:55.725.NL/KMOS.2016-10-09T10:25:55.725.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-23T09:54:00.716/KMOS.2016-10-23T09:54:00.716.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:04:06.350/KMOS.2016-10-13T10:04:06.350.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:55:22.957.NL/KMOS.2016-10-15T08:55:22.957.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:06:01.299/KMOS.2016-10-17T10:06:01.299.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:52:32.259.NL/KMOS.2016-10-24T09:52:32.259.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:51:52.811.NL/KMOS.2016-11-01T09:51:52.811.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-25T09:20:54.751.NL/KMOS.2016-10-25T09:20:54.751.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:04:12.369/KMOS.2016-10-02T10:04:12.369.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:03:04.274/KMOS.2016-10-02T10:03:04.274.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:26:14.845.NL/KMOS.2016-10-27T09:26:14.845.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-14T11:16:34.052/KMOS.2016-10-14T11:16:34.052.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:51:10.583.NL/KMOS.2016-10-21T09:51:10.583.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:51:10.583/KMOS.2016-10-21T09:51:10.583.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:19:29.548/KMOS.2016-10-18T10:19:29.548.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:33:36.725.NL/KMOS.2016-10-30T09:33:36.725.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:59:53.053.NL/KMOS.2016-10-06T09:59:53.053.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:18:21.644/KMOS.2016-10-18T10:18:21.644.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:22:50.788/KMOS.2016-10-27T09:22:50.788.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-01T23:52:08.328/KMOS.2016-10-01T23:52:08.328.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:53:07.014.NL/KMOS.2016-10-15T08:53:07.014.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-20T09:54:46.867/KMOS.2016-10-20T09:54:46.867.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:38:58.565.NL/KMOS.2016-10-02T18:38:58.565.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:40:06.556.NL/KMOS.2016-10-02T18:40:06.556.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:43:30.439/KMOS.2016-10-02T18:43:30.439.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:47:46.527/KMOS.2016-10-21T09:47:46.527.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-28T09:21:53.614.NL/KMOS.2016-10-28T09:21:53.614.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:41:50.742.NL/KMOS.2016-10-05T09:41:50.742.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:44:06.945/KMOS.2016-10-05T09:44:06.945.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-08T12:28:23.599.NL/KMOS.2016-10-08T12:28:23.599.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:48:01.375.NL/KMOS.2016-10-24T09:48:01.375.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:22:31.947.NL/KMOS.2016-10-09T10:22:31.947.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:25:55.725/KMOS.2016-10-09T10:25:55.725.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:51:22.823/KMOS.2016-10-22T09:51:22.823.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:26:14.845/KMOS.2016-10-27T09:26:14.845.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-23T09:50:36.794/KMOS.2016-10-23T09:50:36.794.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:57:48.379.NL/KMOS.2016-10-04T09:57:48.379.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:28:51.827/KMOS.2016-10-16T10:28:51.827.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:42:58.846/KMOS.2016-10-05T09:42:58.846.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-30T09:33:36.725/KMOS.2016-10-30T09:33:36.725.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:59:13.679.NL/KMOS.2016-10-11T09:59:13.679.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:53:38.934.NL/KMOS.2016-10-22T09:53:38.934.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:52:10.787/KMOS.2016-10-10T09:52:10.787.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:06:27.498/KMOS.2016-10-12T10:06:27.498.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:51:52.811/KMOS.2016-11-01T09:51:52.811.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-11-01T09:54:08.905/KMOS.2016-11-01T09:54:08.905.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:04:59.863/KMOS.2016-10-03T10:04:59.863.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-09T10:22:31.947/KMOS.2016-10-09T10:22:31.947.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:04:10.875.NL/KMOS.2016-10-12T10:04:10.875.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:55:31.789.NL/KMOS.2016-10-04T09:55:31.789.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-16T10:25:28.788.NL/KMOS.2016-10-16T10:25:28.788.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:05:14.359/KMOS.2016-10-13T10:05:14.359.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T10:01:00.936.NL/KMOS.2016-10-06T10:01:00.936.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:45:15.164/KMOS.2016-10-05T09:45:15.164.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-20T09:57:01.677/KMOS.2016-10-20T09:57:01.677.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-01T23:51:00.301/KMOS.2016-10-01T23:51:00.301.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:09:25.301.NL/KMOS.2016-10-17T10:09:25.301.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:53:07.014/KMOS.2016-10-15T08:53:07.014.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:04:59.863.NL/KMOS.2016-10-03T10:04:59.863.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-07T10:24:59.634.NL/KMOS.2016-10-07T10:24:59.634.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:08:17.279.NL/KMOS.2016-10-17T10:08:17.279.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-12T10:07:35.921/KMOS.2016-10-12T10:07:35.921.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:34:00.283.NL/KMOS.2016-10-26T09:34:00.283.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:41:14.494.NL/KMOS.2016-10-02T18:41:14.494.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:52:10.787.NL/KMOS.2016-10-10T09:52:10.787.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-13T10:07:29.100/KMOS.2016-10-13T10:07:29.100.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:48:48.880.NL/KMOS.2016-10-10T09:48:48.880.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:50:51.103.NL/KMOS.2016-10-15T08:50:51.103.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:49:06.749/KMOS.2016-10-22T09:49:06.749.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T10:01:00.936/KMOS.2016-10-06T10:01:00.936.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-24T09:51:24.204.NL/KMOS.2016-10-24T09:51:24.204.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:20:37.558.NL/KMOS.2016-10-18T10:20:37.558.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:32:53.474.NL/KMOS.2016-10-26T09:32:53.474.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:43:30.439.NL/KMOS.2016-10-02T18:43:30.439.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-06T09:56:29.530.NL/KMOS.2016-10-06T09:56:29.530.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:17:13.625.NL/KMOS.2016-10-18T10:17:13.625.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:01:57.438/KMOS.2016-10-02T10:01:57.438.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-15T08:55:22.957/KMOS.2016-10-15T08:55:22.957.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T18:28:49.210/KMOS.2016-10-02T18:28:49.210.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-17T10:10:33.451/KMOS.2016-10-17T10:10:33.451.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T15:56:05.040.NL/KMOS.2016-10-21T15:56:05.040.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-18T10:20:37.558/KMOS.2016-10-18T10:20:37.558.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-03T10:06:07.889/KMOS.2016-10-03T10:06:07.889.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-02T10:05:20.389.NL/KMOS.2016-10-02T10:05:20.389.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-26T09:31:45.500.NL/KMOS.2016-10-26T09:31:45.500.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-04T09:55:31.789/KMOS.2016-10-04T09:55:31.789.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-05T09:44:06.945.NL/KMOS.2016-10-05T09:44:06.945.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-21T09:50:02.539/KMOS.2016-10-21T09:50:02.539.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-23T09:49:28.752/KMOS.2016-10-23T09:49:28.752.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-10T09:49:56.790/KMOS.2016-10-10T09:49:56.790.fits.Z"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-11T09:58:05.682.NL/KMOS.2016-10-11T09:58:05.682.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-27T09:22:50.788.NL/KMOS.2016-10-27T09:22:50.788.NL.txt"
"https://dataportal.eso.org/dataPortal/api/requests/lroutledge/254496/SAF/KMOS.2016-10-22T09:52:30.856/KMOS.2016-10-22T09:52:30.856.fits.Z"

__EOF__
