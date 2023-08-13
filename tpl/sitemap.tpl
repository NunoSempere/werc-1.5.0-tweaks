<h1>Site map</h1>

%{
tmpfile=/tmp/werc_sitemap_$pid.txt
tmpfilex=/tmp/werc_sitemapx_$pid.txt
saveddf=$dirfilter
filtereddirs=( images )

MON2NUM='s/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/;'

fn get_mdate {
    t=`{mtime $1}
    t=`{date $t(1) | sed -e $MON2NUM -e 's/  ([0-9]) / 0\1 /g'} # Make sure day of the month is two digits.
    echo $t(6)^'-'^$t(2)^'-'^$t(3)
}

fn get_children {
    d=$1
    children = `{ls -dF $d^*/ $d^*.md $d^*.html $d^*.txt >[2]/dev/null | sed $dirfilter}
    echo $children
}

fn listDir {
    d=$1
    dirfilter=$saveddf

    if(test -f $d/_werc/config)
        . $d/_werc/config

    if(~ $#perm_redir_to 0) {
        siblings=`{get_children $d}
	numsiblings = $#siblings
	if(! ~ $numsiblings 0 && ! ~ $numsiblings 1){
            echo '<ul class="sitemap-list" style="list-style-type: none; list-style-position: outside;" >'
	}
        for(i in $siblings) {
	    ownchildren= `{get_children $i}
	    numownchildren=$#ownchildren
            filename=`{get_file_title $i}
            url=`{echo $i|sed 's!'$sitedir'!!; '$dirclean's!/index$!/!; '}
            dirname=`{echo /$url|sed 's/[\-_]/ /g; s,.*/([^/]+)/?$,\1,'}
            
	    ## Open list?
	    if(! ~ $numsiblings 1){
	      echo '<li style="list-style-type: none; list-style-position: outside; ">'
	    }

            if(! ~ $#filename 0 && ! ~ $filename '') {
                # filename=' — '$"filename
                echo '<a href="'$url'">'^$"filename^'</a>'
	    }
            if not {
                if(! ~ $"dirname $filtereddirs)
                echo '<a href="'$url'" style="text-decoration: none;"  >'^$"dirname^'</a>' 
	    }

            ## echo $numsiblings' '$numownchildren
	    ## ^ Useful for debugging purposes.
	    
	    ## Close list?
	    if(! ~ $numownchildren 1){
	      echo '</li>'
	    }
            if not {
              #  echo '/'
              echo '&nbsp;'
	    }

            echo $base_url^$url >> $tmpfile
            echo '<url><loc>'$base_url^$url'</loc><lastmod>'^`{get_mdate $i}^'</lastmod></url>' >> $tmpfilex
            if(test -d $i)
                @{ listDir $i }
        }
	if(! ~ $numsiblings 0 && ! ~ $numsiblings 1){
            echo '</ul>'
	}
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
