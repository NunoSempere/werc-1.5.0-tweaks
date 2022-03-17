# Old config:
# server {
# 
# 
#      listen 443 ssl; # managed by Certbot
#      ssl_certificate /etc/letsencrypt/live/nunosempere.com/fullchain.pem; # managed by Certbot
#      ssl_certificate_key /etc/letsencrypt/live/nunosempere.com/privkey.pem; # managed by Certbot
#      include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
#      ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
#      # listen 80;
#      # listen [::]:80;
# 
#      root /home/www/werc/werc-1.5.0/sites/nunosempere.com;
#      index index.html index.htm index.nginx-debian.html;
#      server_name nunosempere.com;
# 
#      location / {
#         try_files $uri $uri/ =404;
#      }
# }

server {
    server_name  nunosempere.com; # Replace with your domain name.

    #charset utf-8;

    #access_log  logs/host.access.log  main;

    location / {

    # FastCGI params, usually stored in fastcgi_params
    # and imported with a command like the following:
    #include        fastcgi_params;

    # Typical contents of fastcgi_params (inlined here):
    fastcgi_pass localhost:9000;

    fastcgi_param  QUERY_STRING       $query_string;
    fastcgi_param  REQUEST_METHOD     $request_method;
    fastcgi_param  CONTENT_TYPE       $content_type;
    fastcgi_param  CONTENT_LENGTH     $content_length;

    #fastcgi_param  SCRIPT_FILENAME   /var/www/werc/bin/werc.rc;
    fastcgi_param  SCRIPT_NAME        /home/www/werc/werc-1.5.0/bin/werc.rc;
    #fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;

    fastcgi_param  REQUEST_URI        $request_uri;
    fastcgi_param  DOCUMENT_URI       $document_uri;
    fastcgi_param  DOCUMENT_ROOT      $document_root;
    fastcgi_param  SERVER_PROTOCOL    $server_protocol;

    fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

    fastcgi_param  REMOTE_ADDR        $remote_addr;
    fastcgi_param  REMOTE_PORT        $remote_port;
    fastcgi_param  SERVER_ADDR        $server_addr;
    fastcgi_param  SERVER_PORT        $server_port;
    fastcgi_param  SERVER_NAME        $server_name;
    fastcgi_param  REMOTE_USER        $remote_user;

    #root /home/uriel/werc/werc-1.5.0/sites/nunosempere.com;
    #root   /var/www/werc/sites/$server_addr; # XXX This doesn't work, not sure why :(
    #nuno: I confirm that the above doesn't work.
    root /;
    #root /home/www/werc/werc-1.5.0/sites/nunosempere.com;

    #index  index.html index.htm;
  }

    # listen 443 ssl; # managed by Certbot
    # ssl_certificate /etc/letsencrypt/live/nunosempere.com/fullchain.pem; # managed by Certbot
    # ssl_certificate_key /etc/letsencrypt/live/nunosempere.com/privkey.pem; # managed by Certbot
    # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot



    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/nunosempere.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/nunosempere.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

server {
    if ($host = nunosempere.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen 80;
    server_name  nunosempere.com;
    return 404; # managed by Certbot


}
