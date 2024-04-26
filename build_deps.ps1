param (
    [string]$buildMode = "Debug"
)

if (($buildMode -eq "Debug" -or $buildMode -eq "Release"))
{
    git clone --recursive https://github.com/madler/zlib.git ./modules/zlib
    cmake -S ./modules/zlib -B ./dependencies/zlib -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode"
    cmake --build ./dependencies/zlib --config "$buildMode" --target install
    git clone --recursive https://github.com/open-source-parsers/jsoncpp.git ./modules/jsoncpp
    cmake -S ./modules/jsoncpp -B ./dependencies/jsoncpp -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode"
    cmake --build ./dependencies/jsoncpp --config "$buildMode" --target install
    git clone --recursive https://github.com/drogonframework/drogon.git ./modules/drogon
    cmake -S ./modules/drogon -B ./dependencies/drogon -DCMAKE_INSTALL_PREFIX="./Windows/$buildMode" -DBUILD_SHARED_LIBS=ON -DBUILD_EXAMPLES=OFF -DBUILD_CTL=OFF
    cmake --build ./dependencies/drogon --config "$buildMode" --target install
}
else 
{
    Write-Output "Invalid build args"
}