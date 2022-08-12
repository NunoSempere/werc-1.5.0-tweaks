<hr>
<h2>Comments</h2>

% for(c in `{ls $comments_dir/}) {
%    if(test -s $c/body) {
        <div class="comment">
         <h5>By:
				 	<b><i>%
					  (`{cat $c/user | sed 's/:.*//g'}%)
					</i></b> 
					(%(`{cat $c/posted}%))
				</h5>
%       cat $c/body | escape_html | sed 's,$,<br>,'
        <hr></div>
%    }
% }

