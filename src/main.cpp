#include <iostream>
#include <drogon/drogon.h>
#include <mailio/mailboxes.hpp>
#include <mailio/message.hpp>
#include <mailio/smtp.hpp>

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

    drogon::app().registerHandler(
        "/mail",
        [](const drogon::HttpRequestPtr&,
            std::function<void(const drogon::HttpResponsePtr&)>&& callback) {
                auto resp = drogon::HttpResponse::newHttpResponse();

                try
                {
                    // create mail message
                    mailio::message msg;
                    msg.from(mailio::mail_address("Pairmeet Dev", "pairmeetdev@gmail.com"));// set the correct sender name and address
                    msg.add_recipient(mailio::mail_address("B Marques", "testebash@outlook.com"));// set the correct recipent name and address
                    msg.subject("smtps multipart message");
                    msg.boundary("012456789@mailio.dev");
                    msg.content_type(mailio::message::media_type_t::MULTIPART, "related");
                    msg.content("<p>Esse veio do C++</p>");

                    mailio::mime title;
                    title.content_type(mailio::message::media_type_t::TEXT, "html", "utf-8");
                    title.content_transfer_encoding(mailio::mime::content_transfer_encoding_t::BIT_8);
                    title.content("<html><head></head><body><h1>Senior Call</h1></body></html>");

                    msg.add_part(title);

                    // connect to server
                    mailio::smtps conn("smtp.gmail.com", 465);
                    // modify username/password to use real credentials
                    conn.authenticate("pairmeetdev@gmail.com", "i'm not crazy", mailio::smtps::auth_method_t::LOGIN);
                    conn.submit(msg);
                }
                catch (mailio::smtp_error& exc)
                {
                    std::cout << exc.what() << std::endl;
                }
                catch (mailio::dialog_error& exc)
                {
                    std::cout << exc.what() << std::endl;
                }

                resp->setBody("Executed");
                callback(resp);
        },
        { drogon::Get });

    drogon::app()
        .addListener("127.0.0.1", 8080)
        .setThreadNum(3)
        .setIdleConnectionTimeout(10000).run();

    return 0; 
}