<?xml version="1.0" encoding="UTF-8"?>

%{
fn statpost {
    f = $1
    post_uri = `{echo $f | sed 's,^'$sitedir',,'}
    title=`{read $f/index.md}
    relative_uri=`{cleanname `{echo $f | sed -e 's!^'$sitedir'!!'}}
    post_uri=$base_url^$relative_uri^'/'
    by=`{ls -m $f | sed 's/^\[//g; s/].*$//g' >[2]/dev/null}
    extracted_on=`{echo $relative_uri | sed 's|/blog/||g' | head -c 10 }
    published_on=`{ /bin/date -R -D '%Y/%m/%d' -d $extracted_on }
    ifs=() {summary=`{ cat $f/index.md | head -n 10 | strip_title_from_md_file | ifs=$difs {$formatter | escape_html} }}
    # % could also add a | head -n 10 to only show the first few lines.
}

%}

<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
        <atom:link href="%($base_url^$req_path%)" rel="self" type="application/rss+xml" />
        <title><![CDATA[%($siteTitle%)]]></title>
        <link>%($base_url^$req_path%)</link>
        <description><![CDATA[%($blogDesc%)]]></description>
        <language>en-us</language>
        <generator><![CDATA[Tom Duff's rc, and Kris Maglione's clever hackery]]></generator>
%{
        # <webMaster>uriel99+rss@gmail.com (Uriel)</webMaster>
	# rfc2822 last time channel content changed.
	lbd=`{ndate -m `{date `{mtime `{ls $blagh_root$blagh_dirs/[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]/[0-9] | tail -1} | awk '{print $1}'}}}
	echo '<lastBuildDate>'$"lbd'</lastBuildDate>'
	# rfc2822 publication date for content in the channel.
	pubdate=`{ndate -m}
        for(f in `{get_post_list $blagh_root$blagh_dirs}){
            statpost $f
%}
        <item>
            <title><![CDATA[%($title%)]]></title>
        %{
	   # <author><![CDATA[%($by%)@noreply.cat-v.org (%($by%))]]></author>
	   echo '<author><![CDATA[nuno.sempere@protonmail.com (Nuño Sempere)]]></author>'
	%}
            <link>%($post_uri%)</link>
            <guid isPermaLink="true">%($post_uri%)</guid>
            <pubDate>%( $published_on %)</pubDate>
            <description> %($summary%) </description>
        </item>
%        }
    </channel>
</rss>
