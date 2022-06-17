# WiresharkListener
Questo codice è implementato su Ubuntu 21.10 con Lua versione 5.2.4

# Prerequisiti

* lua sandbox (https://github.com/mozilla-services/lua_sandbox)
* lua sandbox extensions ( https://mozilla-services.github.io/lua_sandbox_extensions/ )
* CMake (3.6+)

# Istruzioni
```
cd /usr/lib/
mkdir lua
cd lua 
mkdir luasandbox
cd luasandbox

git clone https://github.com/mozilla-services/lua_sandbox.git
cd lua_sandbox
mkdir release
cd release
cmake -DCMAKE_BUILD_TYPE=release ..
make
ctest
cpack -G TGZ 
make install

cd ../../

git clone https://github.com/mozilla-services/lua_sandbox_extensions.git
cd lua_sandbox_extensions
mkdir release
cd release
cmake -DCMAKE_BUILD_TYPE=release -DEXT_hyperloglog=on -DCPACK_GENERATOR=TGZ ..
make
ctest
make packages
make install

```
