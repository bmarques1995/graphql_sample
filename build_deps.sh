buildMode="${1:-Debug}"

passed=false

if [[ $buildMode == "Debug" ]]; then
    passed=true
fi

if [[ $buildMode == "Release" ]]; then
    passed=true
fi


if [[ $passed ]];
then
    git clone --recursive https://github.com/openssl/openssl.git ./modules/openssl
    install_prefix="$(pwd)/Linux/$buildMode"
    lowerBuildMode="${buildMode,,}"
    cd ./modules/openssl
    git clean -dfx
    echo "$install_prefix"
    perl ./Configure "--$lowerBuildMode" --prefix="$install_prefix" --openssldir="$install_prefix/openssl" no-shared
    make -j6
    make install
    cd ../..
    git clone --recursive https://github.com/madler/zlib.git ./modules/zlib
    cmake -S ./modules/zlib -B ./dependencies/linux/zlib -DCMAKE_INSTALL_PREFIX="./Linux/$buildMode" -DCMAKE_BUILD_TYPE="$buildMode"
    cmake --build ./dependencies/linux/zlib --target install
    git clone --recursive https://github.com/open-source-parsers/jsoncpp.git ./modules/jsoncpp
    cmake -S ./modules/jsoncpp -B ./dependencies/linux/jsoncpp -DCMAKE_INSTALL_PREFIX="./Linux/$buildMode" -DCMAKE_BUILD_TYPE="$buildMode"
    cmake --build ./dependencies/linux/jsoncpp --target install
    git clone --recursive https://github.com/drogonframework/drogon.git ./modules/drogon
    cmake -S ./modules/drogon -B ./dependencies/linux/drogon -DCMAKE_INSTALL_PREFIX="./Linux/$buildMode" -DBUILD_EXAMPLES=OFF -DBUILD_CTL=OFF -DCMAKE_BUILD_TYPE="$buildMode"
    cmake --build ./dependencies/linux/drogon --target install
    git clone --recursive https://github.com/boostorg/boost.git ./modules/boost
    cmake -S ./modules/boost -B ./dependencies/linux/boost -DCMAKE_INSTALL_PREFIX="./Linux/$buildMode" -DCMAKE_BUILD_TYPE="$buildMode"
    cmake --build ./dependencies/linux/boost --target install
    git clone --recursive https://github.com/karastojko/mailio.git ./modules/mailio 
    cmake -S ./modules/mailio -B ./dependencies/linux/mailio -DCMAKE_INSTALL_PREFIX="./Linux/$buildMode" -DMAILIO_BUILD_DOCUMENTATION=OFF -DCMAKE_BUILD_TYPE="$buildMode" -DBUILD_SHARED_LIBS=OFF
    cmake --build ./dependencies/linux/mailio --target install

else 
    echo "Invalid build args"
fi