#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <iostream>
#include <winsock2.h> 
#pragma comment(lib, "ws2_32.lib")

int main()
{
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in serverAddr{};
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(5051);
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");

    if (connect(sock, (sockaddr*)&serverAddr, sizeof(serverAddr)) == 0) 
    {
        std::cout << "Connected to TMInterface!\n";

        while (true) 
        {
            uint32_t speed = 0;
            int bytes = recv(sock, (char*)&speed, sizeof(speed), 0);
            if (bytes <= 0) break;

            std::cout << "Speed: " << speed << " km/h" << std::endl;
        }
    }
    else 
    {
        std::cerr << "Connection failed.\n";
    }

    closesocket(sock);
    WSACleanup();
}
