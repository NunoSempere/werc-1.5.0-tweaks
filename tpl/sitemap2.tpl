<h1>Site map</h1>

%{
tmpfile=/tmp/werc_sitemap2_$pid.txt
tmpfilex=/tmp/werc_sitemap2_$pid.txt
saveddf=$dirfilter

MON2NUM='s/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/;'

fn get_mdate {
    t=`{mtime $1}
    t=`{date $t(1) | sed -e $MON2NUM -e 's/  ([0-9]) / 0\1 /g'} # Make sure day of the month is two digits.
    echo $t(6)^'-'^$t(2)^'-'^$t(3)
}

fn listDir {
    d=$1
    dirfilter=$saveddf
    if(test -f $d/_werc/config)
        . $d/_werc/config

    if(~ $#perm_redir_to 0) {
        echo '<ul class="sitemap-list">'

        for(i in `{ls -dF $d^*/ $d^*.md $d^*.html $d^*.txt >[2]/dev/null | sed $dirfilter}) {
            filename=`{get_file_title $i}
            url=`{echo $i|sed 's!'$sitedir'!!; '$dirclean's!/index$!/!; '}
            dirname=`{echo /$url|sed 's/[\-_]/ /g; s,.*/([^/]+)/?$,\1,'}
            if(! ~ $#filename 0 && ! ~ $filename '') {
                # filename=' — '$"filename
                echo '<li><a href="'$url'">'^$"filename^'</a></li>' 
	    }
            if not {
                echo '<li><a href="'$url'">'^$"dirname^'</a></li>' 
	    }
            echo $base_url^$url >> $tmpfile
            echo '<url><loc>'$base_url^$url'</loc><lastmod>'^`{get_mdate $i}^'</lastmod></url>' >> $tmpfilex
            if(test -d $i)
                @{ listDir $i }
        }
        echo '</ul>'
    }
}


fltr_cache listDir $sitedir/

if(test -s $tmpfile) {
    mv $tmpfile $sitedir/sitemap.txt &
}
if not if(test -f $tmpfile)
    rm $tmpfile

if(test -s $tmpfilex) {
    {
        echo '<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

        cat $tmpfilex
        rm $tmpfilex &
        echo '</urlset>'
        # TODO Enable automaic search engine update notification.
        #hget 'http://google.com/ping?sitemap='^`{url_encode $base_url'/sitemap.gz'} > /dev/null
    
    } | gzip > $sitedir/sitemap.gz &
    #} > $sitedir/sitemap.xml &
}
if not if(test -f $tmpfilex)
    rm $tmpfilex

%}
