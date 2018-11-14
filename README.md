# ydapi

start:

1) install bundler  
`$gem install bundler`  
2) `$gem install pg`  
may meet issue:  
https://stackoverflow.com/questions/4335750/cant-install-pg-gem-on-windows  
worked: `$gem install pg -- --with-pg-dir="/Library/PostgreSQL/9.6"`


https://stackoverflow.com/questions/3146274/is-it-ok-to-use-dyld-library-path-on-mac-os-x-and-whats-the-dynamic-library-s/3172515#3172515

=== issue  
 LoadError: dlopen(/Library/Ruby/Gems/2.3.0/gems/pg-1.0.0/lib/pg_ext.bundle, 9): Library not loaded: libpq.5.dylib (Sequel::AdapterNotFound)  

to fix:  
http://visheshsinghal.com/post/142/Error-while-setting-up-postgres-with-rails  
`$sudo install_name_tool -change libpq.5.dylib /Library/PostgreSQL/9.6/lib/libpq.5.dylib /Library/Ruby/Gems/2.3.0/gems/pg-1.0.0/lib/pg_ext.bundle` 

=== nginx 
https://stackoverflow.com/questions/26589671/nginx-slow-on-every-second-request