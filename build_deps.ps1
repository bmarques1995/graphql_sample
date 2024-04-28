param (
    [string]$buildMode = "Debug"
)

if (($buildMode -eq "Debug" -or $buildMode -eq "Release"))
{
    git clone --recursive https://github.com/openssl/openssl.git ./modules/openssl
    $install_prefix= Join-Path (Get-Location) "/Windows/$buildMode"
    Set-Location ./modules/openssl
    Write-Host "$install_prefix"
    Start-Process vcvars64.bat
    perl ./Configure VC-WIN64A --prefix="$install_prefix" --openssldir="$install_prefix/openssl" -shared
    nmake
    nmake install
    Set-Location ../..
    git clone --recursive https://github.com/madler/zlib.git ./modules/zlib
    cmake -S ./modules/zlib -B ./dependencies/zlib -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode"
    cmake --build ./dependencies/zlib --config "$buildMode" --target install
    git clone --recursive https://github.com/open-source-parsers/jsoncpp.git ./modules/jsoncpp
    cmake -S ./modules/jsoncpp -B ./dependencies/jsoncpp -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode"
    cmake --build ./dependencies/jsoncpp --config "$buildMode" --target install
    git clone --recursive https://github.com/drogonframework/drogon.git ./modules/drogon
    cmake -S ./modules/drogon -B ./dependencies/drogon -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode" -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=OFF -DBUILD_CTL=OFF
    cmake --build ./dependencies/drogon --config "$buildMode" --target install
    git clone --recursive https://github.com/boostorg/boost.git ./modules/boost -DBUILD_SHARED_LIBS=ON
    cmake -S ./modules/boost -B ./dependencies/boost -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode"
    cmake --build ./dependencies/boost --config "$buildMode" --target install
    git clone --recursive https://github.com/karastojko/mailio.git ./modules/mailio 
    cmake -S ./modules/mailio -B ./dependencies/mailio -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode" -DMAILIO_BUILD_DOCUMENTATION=OFF
    cmake --build ./dependencies/mailio --config "$buildMode" --target install
}
else 
{
    Write-Output "Invalid build args"
}