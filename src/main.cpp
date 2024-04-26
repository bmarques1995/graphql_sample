#include <iostream>
#include <drogon/drogon.h>

int main(int argc, char** argv)
{
    drogon::app().registerHandler(
        "/",
        [](const drogon::HttpRequestPtr&,
            std::function<void(const drogon::HttpResponsePtr&)>&& callback) {
                auto resp = drogon::HttpResponse::newHttpResponse();
                resp->setBody("Hello, World!");
                callback(resp);
        },
        { drogon::Get });

    drogon::app()
        .addListener("127.0.0.1", 8080)
        .setThreadNum(3)
        .setIdleConnectionTimeout(10000).run();

    return 0; 
}