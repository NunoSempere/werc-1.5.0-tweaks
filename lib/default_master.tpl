<header>
% 
% if(test -w `{pwd}^/sites^/`{echo $site }^/_werc/lib/top_bar.inc){
    <nav>
% cat `{pwd}^/sites^/`{echo $site }^/_werc/lib/top_bar.inc
    </nav>
% }
    <h1><a href="/">%($"siteTitle%) </a><span id="headerSubTitle">%($"siteSubTitle%)</span></h1>
</header>

% if(! ~ $#handlers_bar_left 0) {
    <nav id="side-bar">
%   for(h in $handlers_bar_left) {
        <div>
%       run_handler $$h
        </div>
%   }
    </nav>
% }

<article>
% run_handlers $handlers_body_head
% run_handler $handler_body_main
% run_handlers $handlers_body_foot
</article>

<footer>
% cat `{ get_lib_file footer.inc }
</footer>
