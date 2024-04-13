@echo off
if exist "C:\devBuilds" (
    rd /s /q "C:\devBuilds" && mkdir "C:\devBuilds"
) else (
    mkdir "C:\devBuilds"
)
mkdir "C:\devBuilds\src"
mkdir "C:\devBuilds\src\openssl"
mkdir "C:\devBuilds\src\zlib"
mkdir "C:\devBuilds\src\curl"

git clone --depth 1 https://github.com/openssl/openssl.git "C:\devBuilds\src\openssl"
git clone --depth 1 https://github.com/madler/zlib.git "C:\devBuilds\src\zlib"
git clone --depth 1 https://github.com/curl/curl.git "C:\devBuilds\src\curl"

call "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"

cd C:\devBuilds\src\openssl
perl Configure VC-WIN64A --prefix=c:\devBuilds\openssl
nmake
nmake install

cd C:\devBuilds\src\zlib
nmake /f win32/Makefile.msc
mkdir "C:\devBuilds\zlib\include"
mkdir "C:\devBuilds\zlib\lib"
mkdir "C:\devBuilds\zlib\bin"
copy C:\devBuilds\src\zlib\zlib.h C:\devBuilds\zlib\include
copy C:\devBuilds\src\zlib\zconf.h C:\devBuilds\zlib\include
copy C:\devBuilds\src\zlib\zlib.lib C:\devBuilds\zlib\lib
copy C:\devBuilds\src\zlib\zdll.lib C:\devBuilds\zlib\lib
copy C:\devBuilds\src\zlib\zlib.pdb C:\devBuilds\zlib\lib
copy C:\devBuilds\src\zlib\zlib1.pdb C:\devBuilds\zlib\lib
copy C:\devBuilds\src\zlib\zlib1.dll C:\devBuilds\zlib\bin

call "C:\devBuilds\src\curl\buildconf.bat"
cd C:\devBuilds\src\curl\winbuild
nmake /f Makefile.vc mode=dll MACHINE=x64 WITH_SSL=dll SSL_PATH=C:\devBuilds\openssl WITH_ZLIB=dll ZLIB_PATH=C:\devBuilds\zlib
mkdir "C:\devBuilds\curl\include"
mkdir "C:\devBuilds\curl\lib"
mkdir "C:\devBuilds\curl\bin"

xcopy C:\devBuilds\src\curl\builds\libcurl-vc-x64-release-dll-ssl-dll-zlib-dll-ipv6-sspi\* C:\devBuilds\curl\ /s /i
xcopy C:\devBuilds\curl\include\curl\* C:\devBuilds\curl\include /s /i
xcopy C:\devBuilds\openssl\include\openssl\* C:\devBuilds\openssl\include\ /s /i
RD /S /Q "C:\devBuilds\curl\include\curl"
RD /S /Q "C:\devBuilds\openssl\include\openssl\"
RD /S /Q "C:\devBuilds\openssl\html"